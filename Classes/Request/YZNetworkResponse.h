//
//  YZNetworkRepose.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/8.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZNetworkResponse : NSObject

/** 请求成功数据*/
@property (nonatomic, strong, readonly, nullable) id responseObject;

/** 错误*/
@property (nonatomic, strong, readonly, nullable) NSError * error;

/** 请求原始http数据*/
@property (nonatomic, strong, readonly, nullable) NSHTTPURLResponse *httpURLResponse;

/** 请求任务*/
@property (nonatomic, strong, readonly, nullable) NSURLSessionTask *sessionTask;

/** 错误*/
@property (nonatomic,assign, readonly) YZResponseErrorType errorType;

+ (instancetype)responseWithSessionTask:(nullable NSURLSessionTask *)sessionTask
                         responseObject:(nullable id)responseObject
                                  error:(nullable NSError *)error;


@end

NS_ASSUME_NONNULL_END
