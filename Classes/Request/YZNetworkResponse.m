//
//  YZNetworkRepose.m
//  YZNetwork
//
//  Created by zhuo on 2019/5/8.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "YZNetworkResponse.h"

@interface YZNetworkResponse()
@property (nonatomic, strong, readwrite, nullable) id responseObject;
@property (nonatomic, strong, readwrite, nullable) NSHTTPURLResponse *httpURLResponse;
@property (nonatomic, strong, readwrite, nullable) NSError * error;
@property (nonatomic, strong, readwrite, nullable) NSURLSessionTask *sessionTask;
@property (nonatomic,assign, readwrite) YZResponseErrorType errorType;
@end

@implementation YZNetworkResponse

+ (instancetype)responseWithSessionTask:(nullable NSURLSessionTask *)sessionTask
                         responseObject:(nullable id)responseObject
                                  error:(nullable NSError *)error {
    
    YZNetworkResponse *response = [[YZNetworkResponse alloc] init];
    response.sessionTask = sessionTask;
    response.error = error;
    response.responseObject = responseObject;
    if (error) {
        response.error = error;
        YZResponseErrorType errorType;
        switch (error.code) {
            case NSURLErrorTimedOut:
                errorType = YZResponseErrorTypeTimedOut;
                break;
            case NSURLErrorCancelled:
                errorType = YZResponseErrorTypeCancle;
                break;
            default:
                errorType = YZResponseErrorTypeNone;
                break;
        }
        response.errorType = errorType;
    }
    return response;
}

#pragma mark getter

- (NSHTTPURLResponse *)httpURLResponse {
    if (self.sessionTask && [self.sessionTask.response isKindOfClass:NSHTTPURLResponse.class]) {
        return (NSHTTPURLResponse *)self.sessionTask.response;
    }
    return nil;
}

@end
