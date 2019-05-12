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

#if DEBUG
// 自定义调试宏
#define YZNetworkLog(format, ...)  {                                                                               \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
}
#else

#define YZNetworkLog(format, ...)
#endif


/// http请求方法类型
typedef NS_ENUM(NSInteger, YZRequestMethod) {
    YZRequestMethodGET = 0,
    YZRequestMethodPOST,
    YZRequestMethodHEAD,
    YZRequestMethodPUT,
    YZRequestMethodDELETE,
    YZRequestMethodPATCH,
};

/// 网络出差类型
typedef NS_ENUM(NSInteger, YZResponseErrorType) {
    YZResponseErrorTypeNone,            // 无
    YZResponseErrorTypeTimedOut,         // 请求超时
    YZResponseErrorTypeCancle,          // 网络取消
    YZResponseErrorTypeNotReachable,    // 无网络
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

/// cache类型
typedef  NS_ENUM(NSInteger, YZRequestCacheWriteMode) {
    YZRequestCacheWriteModeNone = 0,            // 没缓存
    YZRequestCacheWriteModeMemory = 1 << 0,     // 内存缓存
    YZRequestCacheWriteModeDisk = 1 << 1,     // 文件缓存
    YZRequestCacheWriteModeMemoryAndDisk = YZRequestCacheWriteModeMemory | YZRequestCacheWriteModeDisk,     // 文件缓存
};


@class YZBaseRequest;
@class YZNetworkResponse;

// 请求成功闭包
typedef void(^YZRequestSuccessBlock)(YZNetworkResponse *response);

/// 请求失败闭包
typedef void(^YZRequestFailureBlock)(YZNetworkResponse *response);

/// 进度
typedef void (^YZRequestProgressBlock)(NSProgress *progress);


/// 网络请求响应代理
@protocol YZRequestDelegate <NSObject>
@optional

- (void)request:(__kindof YZBaseRequest *)request successWithResponse:(YZNetworkResponse *)response;

- (void)request:(__kindof YZBaseRequest *)request failureWithResponse:(YZNetworkResponse *)response;

- (void)request:(__kindof YZBaseRequest *)request uploadProgress:(NSProgress *)progress;

- (void)request:(__kindof YZBaseRequest *)request downloadProgress:(NSProgress *)progress;

@end

#endif /* YZNeworkDefine_h */
