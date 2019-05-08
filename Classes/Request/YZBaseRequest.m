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

@interface YZBaseRequest()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;

@end

@implementation YZBaseRequest


#pragma mark - Getter & Setter


#pragma mark - Delegate

#pragma mark - Public

- (void)start {
    
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

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ URL: %@ } { method: %@ } { arguments: %@ }", NSStringFromClass([self class]), self, [self buildRequestUrl], self.requestHttpMethedString, self.requestParameter];
}

@end
