//
//  YZNetworkManager.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/7.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

/// 网络请求管理类

@class YZBaseRequest;
@class YZNetworkResponse;

typedef void(^YZRequestCompletionBlock)(YZNetworkResponse *response);

@interface YZNetworkManager : NSObject

- (instancetype)init OBJC_UNAVAILABLE("use 'sharedManager' instead");
+ (instancetype)new OBJC_UNAVAILABLE("use 'sharedManager' instead");
+ (instancetype)sharedManager;

- (NSNumber *)startNetworkingWithRequest:(YZBaseRequest *)request uploadProgress:(nullable YZRequestProgressBlock)uploadProgress downloadProgress:(nullable YZRequestProgressBlock)downloadProgress completion:(YZRequestCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
