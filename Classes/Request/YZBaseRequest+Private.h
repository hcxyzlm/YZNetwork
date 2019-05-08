//
//  YZBaseRequest+Private.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/7.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "YZBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZBaseRequest (Setter)

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;

@end

@interface YZBaseRequest (Private)

/// 请求方法字符串
- (NSString *)requestHttpMethedString;

// 返回最终的请求字符串
- (NSString *)buildRequestUrl;

@end

NS_ASSUME_NONNULL_END
