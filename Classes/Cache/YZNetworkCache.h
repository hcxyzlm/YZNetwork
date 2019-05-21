//
//  YZNetworkCache.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/12.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZNetworkDefine.h"

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
 清除所有缓存
 */
- (void)removeAllCache;

#pragma mark cache

@property (strong, readonly) NSCache *memoryCache;

@end

NS_ASSUME_NONNULL_END
