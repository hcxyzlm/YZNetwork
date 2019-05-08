//
//  YZNeworkDefine.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/6.
//  Copyright © 2019 zhuo. All rights reserved.
//

#ifndef YZNeworkDefine_h
#define YZNeworkDefine_h

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

void YZLog(NSString *format, ...) {
#ifdef DEBUG
    va_list argptr;
    va_start(argptr, format);
    NSLogv(format, argptr);
    va_end(argptr);
#endif
}


/// http请求方法类型
typedef NS_ENUM(NSInteger, YZRequestMethod) {
    YZRequestMethodGET = 0,
    YZRequestMethodPOST,
    YZRequestMethodHEAD,
    YZRequestMethodPUT,
    YZRequestMethodDELETE,
    YZRequestMethodPATCH,
};

///  请求序列化器
typedef NS_ENUM(NSInteger, YZRequestSerializerType) {
    YZRequestSerializerTypeHTTP = 0,
    YZRequestSerializerTypeJSON,
};

///  请求优先级
typedef NS_ENUM(NSInteger, YZRequestPriority) {
    YZRequestPriorityLow = -4L,
    YZRequestPriorityDefault = 0,
    YZRequestPriorityHigh = 4,
};

@class YZBaseRequest;
@class YZNetworkResponse;

// 请求成功闭包
typedef void(^YZBaseRequestSuccessBlock)(YZNetworkResponse *response);

/// 请求失败闭包
typedef void(^YZBaseRequestFailureBlock)(YZNetworkResponse *response);

/// 上传进度
typedef void (^YZBaseRequestUploadProgressBlock)(NSProgress *uploadProgress);

/// 下载进度
typedef void (^YZBaseRequestDownloadProgressBlock)(NSProgress *uploadProgress);


/// 网络请求响应代理
@protocol YZBaseRequestDelegate <NSObject>
@optional

- (void)request:(__kindof YZBaseRequest *)request successWithResponse:(YZNetworkResponse *)response;

- (void)request:(__kindof YZBaseRequest *)request failureWithResponse:(YZNetworkResponse *)response;

- (void)request:(__kindof YZBaseRequest *)request uploadProgress:(NSProgress *)progress;

- (void)request:(__kindof YZBaseRequest *)request downloadProgress:(NSProgress *)progress;

@end

#endif /* YZNeworkDefine_h */
