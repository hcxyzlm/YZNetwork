//
//  YZBaseRequest.m
//  YZNetwork
//
//  Created by zhuo on 2019/5/6.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "YZBaseRequest.h"
#import "YZBaseRequest+Private.h"
#import "YZNetworkManager.h"

#define YZNETWORK_MAIN_QUEUE_ASYNC(block) YBNETWORK_QUEUE_ASYNC(dispatch_get_main_queue(), block)

@interface YZBaseRequest()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;

@end

@implementation YZBaseRequest


#pragma mark - Getter & Setter

#pragma mark - Public

- (void)startWithSuccess:(nullable YZRequestSuccessBlock)success
                 failure:(nullable YZRequestSuccessBlock)failure {
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}

- (void)start {
    [[YZNetworkManager sharedManager] startNetworkingWithRequest:self uploadProgress:self.uploadProgressBlock downloadProgress:self.downloadProgressBlock completion:^(YZNetworkResponse * _Nonnull response) {
        
    }];
}

- (void)cancle {
    
}

#pragma mark - Private

- (void)clearRequestBlocks {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    self.uploadProgressBlock = nil;
    self.downloadProgressBlock = nil;
}

- (void)requestUploadProgress:(NSProgress *)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request:uploadProgress:)]) {
            [self.delegate request:self uploadProgress:progress];
        }
        if (self.uploadProgressBlock) {
            self.uploadProgressBlock(progress);
        }
    });
}

- (void)requestDownloadProgress:(NSProgress *)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request:downloadProgress:)]) {
            [self.delegate request:self downloadProgress:progress];
        }
        if (self.downloadProgressBlock) {
            self.downloadProgressBlock(progress);
        }
    });
}

- (void)requestFailureWithResponse:(YZNetworkResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, [self buildRequestUrl], self.requestHttpMethedString, self.requestParameter];
}

@end
