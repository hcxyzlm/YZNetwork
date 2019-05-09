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
#import "YZNetworkResponse.h"

#define YZNETWORK_MAIN_QUEUE_ASYNC(block) YBNETWORK_QUEUE_ASYNC(dispatch_get_main_queue(), block)

@interface YZBaseRequest()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;

@end

@implementation YZBaseRequest


#pragma mark - Getter & Setter

#pragma mark - Public

- (void)startWithSuccess:(nullable YZRequestSuccessBlock)success
                 failure:(nullable YZRequestSuccessBlock)failure {
    [self startWithUploadProgress:nil downloadProgress:nil success:success failure:failure];
}

- (void)startWithUploadProgress:(YZRequestProgressBlock)uploadProgress downloadProgress:(YZRequestProgressBlock)downloadProgress success:(YZRequestSuccessBlock)success failure:(YZRequestFailureBlock)failure {
    self.uploadProgressBlock = uploadProgress;
    self.downloadProgressBlock = downloadProgress;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [self start];
}

- (void)start {
    
    __weak typeof(self) weakSelf = self;
    [[YZNetworkManager sharedManager] startNetworkingWithRequest:self uploadProgress:self.uploadProgressBlock downloadProgress:self.downloadProgressBlock completion:^(YZNetworkResponse * _Nonnull response) {
        __strong typeof(weakSelf) self = weakSelf;
        [self handleCompletionWithResponse:response];
    }];
}

- (void)cancle {
    
}

#pragma mark - Private

- (void)handleCompletionWithResponse:(YZNetworkResponse *)response {
    if (response.error) {
        [self requestFailureWithResponse:response];
    } else {
        [self requestSuccessWithResponse:response];
    }
}

- (void)clearRequestBlocks {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
    self.uploadProgressBlock = nil;
    self.downloadProgressBlock = nil;
}

- (void)requestSuccessWithResponse:(YZNetworkResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request:successWithResponse:)]) {
            [self.delegate request:self successWithResponse:response];
        }
        if (self.successCompletionBlock) {
            self.successCompletionBlock(response);
        }
    });
}

- (void)requestFailureWithResponse:(YZNetworkResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(request:failureWithResponse:)]) {
            [self.delegate request:self failureWithResponse:response];
        }
        if (self.failureCompletionBlock) {
            self.failureCompletionBlock(response);
        }
    });
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


#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, [self buildRequestUrl], self.requestHttpMethedString, self.requestParameter];
}

@end
