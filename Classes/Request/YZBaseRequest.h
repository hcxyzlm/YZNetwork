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
@property (nonatomic, copy) NSString *requestURL;

/** 请求参数 */
@property (nonatomic, copy, nullable) NSDictionary *requestParameter;

/** 请求超时 */
@property (nonatomic,assign) NSTimeInterval timeoutInterval;

/** 请求优先级 */
@property (nonatomic,assign) YZRequestPriority requestPriority;

/** 请求上传文件包 */
@property (nonatomic, copy, nullable) void(^requestConstructingBody)(id<AFMultipartFormData> formData);

/** 请求序列化类型*/
@property (nonatomic,assign) YZRequestSerializerType requestSerializerType;

/** api是否在请求 */
@property (nonatomic, readonly, getter=isExecuting) BOOL executing;

/** 服务器地址(例如：https://www.baidu.com) */
@property (nonatomic, copy) NSString *baseURL;

/** 下载地址*/
/** 注释 */
@property (nonatomic, copy) NSString *downloadPath; 

#pragma mark 请求回调
/** 请求成功回调闭包*/
@property (nonatomic, copy, nullable) YZRequestSuccessBlock successCompletionBlock;

/** 请求成功回调闭包*/
@property (nonatomic, copy, nullable) YZRequestFailureBlock failureCompletionBlock;

/** 上传文件进度闭包*/
@property (nonatomic, copy, nullable) YZRequestProgressBlock uploadProgressBlock;

/** 下载文件进度闭包*/
@property (nonatomic, copy, nullable) YZRequestProgressBlock downloadProgressBlock;

#pragma mark delegate
/** 请求成功代理*/
@property (nonatomic, weak) id<YZRequestDelegate> delegate;

#pragma mark http 相关

@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;

#pragma mark request

/** 发起网络请求带回调 */
- (void)startWithSuccess:(nullable YZRequestSuccessBlock)success
                 failure:(nullable YZRequestSuccessBlock)failure;

- (void)startWithUploadProgress:(nullable YZRequestProgressBlock)uploadProgress downloadProgress:(nullable YZRequestProgressBlock)downloadProgress success:(nullable YZRequestSuccessBlock)success failure:(nullable YZRequestFailureBlock)failure;

- (void)start;

/** 取消网络请求*/
- (void)cancle;

@end

NS_ASSUME_NONNULL_END
