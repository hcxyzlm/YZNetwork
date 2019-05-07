//
//  YZNetworkManager.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/7.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 网络请求管理类

@class YZBaseRequest;

@interface YZNetworkManager : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
+ (instancetype)shareManager;

- (void)addRequest:(YZBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
