//
//  YZNetworkManager.m
//  YZNetwork
//
//  Created by zhuo on 2019/5/7.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "YZNetworkManager.h"
#import "YZBaseRequest.h"
#import "YZNetworkDefine.h"
#import "YZBaseRequest+Private.h"
#import <pthread/pthread.h>
#import "YZNetworkResponse.h"

/// 宏
#define YZ_RequestsRecord_LOCK(...) \
pthread_mutex_lock(&_lock); \
__VA_ARGS__ \
pthread_mutex_unlock(&_lock);


@interface YZNetworkManager()

/** 网络的唯一标示管理类 */
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, YZBaseRequest *> *requestsRecord;

@end

@implementation YZNetworkManager{
    /// 队列
    dispatch_queue_t _processingQueue;
    // 互斥锁
    pthread_mutex_t _lock;
    //afn 队列
    AFHTTPSessionManager *_manager;
}

#pragma mark - Life Cycle

+ (instancetype)sharedManager {
    static YZNetworkManager *instacne;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[self alloc] init];
    });
    
    return instacne;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _processingQueue = dispatch_queue_create("com.YZNetworkManager.processingQueue", DISPATCH_QUEUE_CONCURRENT);
        pthread_mutex_init(&_lock, NULL);
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration]];
        _manager.completionQueue = _processingQueue;
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}


#pragma mark - Public

- (NSNumber *)startNetworkingWithRequest:(YZBaseRequest *)request uploadProgress:(nullable YZRequestProgressBlock)uploadProgress downloadProgress:(nullable YZRequestProgressBlock)downloadProgress completion:(YZRequestCompletionBlock)completion {
    NSParameterAssert(request != nil);
    
    NSError * __autoreleasing requestSerializationError = nil;
    
    // 构建网络请求数据
    NSString *method = [request requestHttpMethedString];
    NSString *URLString = [self URLStringForRequest:request];
    id parameter = [self parameterForRequest:request];
    
    // 构建 URLRequest
    NSURLRequest *urlRequest = nil;
    AFHTTPRequestSerializer *serializer = [self requestSerializerForRequest:request];
    if (request.requestConstructingBody) {
        urlRequest = [serializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameter constructingBodyWithBlock:request.requestConstructingBody error:&requestSerializationError];
    } else {
        urlRequest = [serializer requestWithMethod:method URLString:URLString parameters:parameter error:&requestSerializationError];
    }
    if (requestSerializationError) {
        if (completion) completion([YZNetworkResponse responseWithSessionTask:nil responseObject:nil error:requestSerializationError]);
        return nil;
    }
    return [self startDataTaskWithRequest:request URLRequest:urlRequest uploadProgress:uploadProgress downloadProgress:downloadProgress completion:completion];
}

#pragma mark - Private

- (NSNumber *)startDataTaskWithRequest:(YZBaseRequest *)request URLRequest:(NSURLRequest *)URLRequest uploadProgress:(nullable YZRequestProgressBlock)uploadProgress downloadProgress:(nullable YZRequestProgressBlock)downloadProgress completion:(YZRequestCompletionBlock)completion {
    
    __block NSURLSessionDataTask *task = [_manager dataTaskWithRequest:URLRequest uploadProgress:^(NSProgress * _Nonnull _uploadProgress) {
        if (uploadProgress) {
            uploadProgress(_uploadProgress);
        }
    } downloadProgress:^(NSProgress * _Nonnull _downloadProgress) {
        if (downloadProgress) {
            downloadProgress(_downloadProgress);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self removeRequestfromRecord: request];
        if (completion) {
            completion([YZNetworkResponse responseWithSessionTask:task responseObject:responseObject error:error]);
        }
    }];
    request.requestTask = task;
    NSAssert(request.requestTask != nil, @"requestTask should not be nil");
    [self addRequestToRecord:request];
    [task resume];
    return @(task.taskIdentifier);
}

- (NSString *)URLStringForRequest:(YZBaseRequest *)request {
    NSString *URLString = [request buildRequestUrl];
    // todo, 插件机制
    
    return URLString;
}

- (id)parameterForRequest:(YZBaseRequest *)request {
    id parameter = request.requestParameter;
    /// todo
    return parameter;
}

- (void)addRequestToRecord:(YZBaseRequest *)request {
    YZNetworkLog(@"Add request: %@", NSStringFromClass([request class]));
    YZ_RequestsRecord_LOCK(self.requestsRecord[@(request.requestTask.taskIdentifier)] = request;)
}

- (void)removeRequestfromRecord:(YZBaseRequest *)request {
    YZ_RequestsRecord_LOCK([self.requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];)
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(YZBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == YZRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == YZRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [request timeoutInterval];
    return requestSerializer;
}

#pragma mark getter

- (NSMutableDictionary<NSNumber *,YZBaseRequest *> *)requestsRecord {
    if (!_requestsRecord) {
        _requestsRecord = [NSMutableDictionary dictionary];
    }
    return _requestsRecord;
}

@end
