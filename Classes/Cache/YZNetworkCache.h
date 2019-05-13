//
//  YZNetworkCache.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/12.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZNetworkDefine.h"

#if __has_include(<YYCache/YYCache.h>)
#import <YYCache/YYCache.h>
#else
#import "YYCache.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/// 网络缓存类

@interface YZNetworkCache : NSObject
/** 网络缓存模式，默认不缓存*/
@property (nonatomic,assign) YZRequestCacheWriteMode wirteMode;

/** 缓存时间，单位为秒, 默认不限制*/
@property (nonatomic,assign) NSInteger cacheTime;
/**
 缓存
 @param object 缓存对象
 @param key 存储key
 */
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;


/**
 获取缓存

 @param key 存储key
 @param block 回调
 */
- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> _Nullable object))block;

/**
 清除内存中缓存
 */
- (void)removeMemoryCache;


/**
 清除磁盘缓存
 */
- (void)removeDiskCache;
/**
 清除所有缓存
 */
- (void)removeAllCache;

#pragma mark yycache

@property (strong, readonly) YYMemoryCache *memoryCache;

@property (strong, readonly) YYDiskCache *diskCache;

@end

NS_ASSUME_NONNULL_END
