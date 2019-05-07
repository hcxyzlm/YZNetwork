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

/// 宏
#define YZMutexLock() pthread_mutex_lock(&_lock)
#define YZMutexUnLock() pthread_mutex_unlock(&_lock)

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
    AFHTTPRequestSerializer *_Serializer;
}

#pragma mark - Life Cycle

+ (instancetype)shareManager {
    static YZNetworkManager *instacne;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instacne = [[self alloc] init];
    });
    
    return instacne;
}

// 重写该方法，调用alloc会调用改方法
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return  [self shareManager];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _requestsRecord = [NSMutableDictionary dictionary];
        _processingQueue = dispatch_queue_create("com.YZNetworkManager.processingQueue", DISPATCH_QUEUE_CONCURRENT);
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}


#pragma mark - Public

- (void)addRequest:(YZBaseRequest *)request {
    NSParameterAssert(request != nil);
    
    NSError * __autoreleasing requestSerializationError = nil;
    NSString *requestUrlString = [request buildRequestUrl];
    
    // 构建网络请求数据
    NSString *method = [request requestHttpMethedString];
    NSString *URLString = [self URLStringForRequest:request];
    id parameter = [self parameterForRequest:request];
    
    // 构建 URLRequest
    NSError *error = nil;
    NSMutableURLRequest *URLRequest = nil;
    if (request.requestConstructingBody) {
        URLRequest = [serializer multipartFormRequestWithMethod:@"POST" URLString:URLString parameters:parameter constructingBodyWithBlock:request.requestConstructingBody error:&error];
    } else {
        URLRequest = [serializer requestWithMethod:method URLString:URLString parameters:parameter error:&error];
    }
    
    if (error) {
        if (completion) completion([YBNetworkResponse responseWithSessionTask:nil responseObject:nil error:error]);
        return nil;
    }
    
    // 发起网络请求
    AFHTTPSessionManager *manager = [self sessionManagerForRequest:request];
    if (request.downloadPath.length > 0) {
        return [self startDownloadTaskWithManager:manager URLRequest:URLRequest downloadPath:request.downloadPath downloadProgress:downloadProgress completion:completion];
    } else {
        return [self startDataTaskWithManager:manager URLRequest:URLRequest uploadProgress:uploadProgress downloadProgress:downloadProgress completion:completion];
    }
    
//    NSURLRequest *customUrlRequest= [request buildCustomUrlRequest];
//    if (customUrlRequest) {
//        __block NSURLSessionDataTask *dataTask = nil;
//        dataTask = [_manager dataTaskWithRequest:customUrlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//            [self handleRequestResult:dataTask responseObject:responseObject error:error];
//        }];
//        request.requestTask = dataTask;
//    } else {
//        request.requestTask = [self sessionTaskForRequest:request error:&requestSerializationError];
//    }
//
//    if (requestSerializationError) {
//        [self requestDidFailWithRequest:request error:requestSerializationError];
//        return;
//    }
//
//    NSAssert(request.requestTask != nil, @"requestTask should not be nil");
//
//    // Set request task priority
//    // !!Available on iOS 8 +
//    if ([request.requestTask respondsToSelector:@selector(priority)]) {
//        switch (request.requestPriority) {
//            case YTKRequestPriorityHigh:
//                request.requestTask.priority = NSURLSessionTaskPriorityHigh;
//                break;
//            case YTKRequestPriorityLow:
//                request.requestTask.priority = NSURLSessionTaskPriorityLow;
//                break;
//            case YTKRequestPriorityDefault:
//                /*!!fall through*/
//            default:
//                request.requestTask.priority = NSURLSessionTaskPriorityDefault;
//                break;
//        }
//    }
//
//    // Retain request
//    YTKLog(@"Add request: %@", NSStringFromClass([request class]));
//    [self addRequestToRecord:request];
//    [request.requestTask resume];
}



#pragma mark - Private

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
    YZMutexLock();
    YZMutexUnLock();
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(YZBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == YZRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == YZRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = [request requestTimeout];
//    requestSerializer.allowsCellularAccess = [request allowsCellularAccess];
    
    // If api needs server username and password
    NSArray<NSString *> *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
    if (authorizationHeaderFieldArray != nil) {
        [requestSerializer setAuthorizationHeaderFieldWithUsername:authorizationHeaderFieldArray.firstObject
                                                          password:authorizationHeaderFieldArray.lastObject];
    }
    
    // If api needs to add custom value to HTTPHeaderField
    NSDictionary<NSString *, NSString *> *headerFieldValueDictionary = [request requestHeaderFieldValueDictionary];
    if (headerFieldValueDictionary != nil) {
        for (NSString *httpHeaderField in headerFieldValueDictionary.allKeys) {
            NSString *value = headerFieldValueDictionary[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}

@end
