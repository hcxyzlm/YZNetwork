//
//  YZBaseRequest.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/6.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZNetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN

/* 网络的基础api类，一般一个api对应一个YZBaseRequest对象 */

@interface YZBaseRequest : NSObject

#pragma mark 网络请求数据

/** 请求类型 */
@property (nonatomic,assign) YZRequestMethod requestMethod;

/** 服务里路径(例如： movie/detail) */
@property (nonatomic, copy) NSString *requestUrl;

/** 请求参数 */
@property (nonatomic, copy, nullable) NSDictionary *requestParameter;

/** 请求超时 */
@property (nonatomic,assign) NSTimeInterval requestTimeout;

/** 请求优先级 */
@property (nonatomic,assign) YZRequestPriority requestPriority;

/** 请求上传文件包 */
@property (nonatomic, copy, nullable) void(^requestConstructingBody)(id<AFMultipartFormData> formData);

/** 请求序列化类型*/
@property (nonatomic,assign) YZRequestSerializerType requestSerializerType;

/** api是否在请求 */
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;

/** 服务器地址(例如：https://www.baidu.com) */
@property (nonatomic, copy) NSString *baseUrl;

#pragma mark 请求回调
/** 请求成功回调闭包*/
@property (nonatomic, copy, nullable) YZBaseRequestSuccessBlock successCompletionBlock;

/** 请求成功回调闭包*/
@property (nonatomic, copy, nullable) YZBaseRequestFailureBlock failureCompletionBlock;

#pragma mark delegate
/** 请求成功代理*/
@property (nonatomic, weak) id<YZBaseRequestDelegate> delegate;

#pragma mark request

- (void)start;

/** 取消网络请求*/
- (void)cancle;

@end

NS_ASSUME_NONNULL_END
