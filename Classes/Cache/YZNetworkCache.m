//
//  YZNetworkCache.m
//  YZNetwork
//
//  Created by zhuo on 2019/5/12.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "YZNetworkCache.h"

@interface YZNetworkCacheItem: NSObject<NSCoding>

@property (nonatomic, strong) id<NSCoding> object;
@property (nonatomic, strong) NSDate *updateDate;
@end


static NSString * const YZNetworkCacheName = @"YZNetworkCacheName";
//static YYDiskCache *_diskCache = nil;
static NSCache *_memoryCache = nil;

@implementation YZNetworkCacheItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    self.object = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(object))];
    self.updateDate = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(updateDate))];
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.object forKey:NSStringFromSelector(@selector(object))];
    [aCoder encodeObject:self.updateDate forKey:NSStringFromSelector(@selector(updateDate))];
}

@end

@implementation YZNetworkCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.wirteMode = YZRequestCacheWriteModeNone;
        self.cacheTime = 0;
    }
    return self;
}

#pragma mark  public method
- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key {
    YZNetworkCacheItem *chachePackage = [[YZNetworkCacheItem alloc] init];
    chachePackage.object = object;
    chachePackage.updateDate = [NSDate date];
    
    if (self.wirteMode & YZRequestCacheWriteModeMemory) {
        [[YZNetworkCache memoryCache] setObject:chachePackage forKey:key];
    }
}

- (void)objectForKey:(NSString *)key withBlock:(void(^)(NSString *key, id<NSCoding> _Nullable object))block {
    if (!block || !key) {
        return;
    }
    void(^callBack)(id<NSCoding>) = ^(id<NSCoding> obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (obj && [((NSObject *)obj) isKindOfClass:YZNetworkCacheItem.class]) {
                YZNetworkCacheItem *package = (YZNetworkCacheItem *)obj;
                if (self.cacheTime != 0 && -[package.updateDate timeIntervalSinceNow] > self.cacheTime) {
                    block(key, nil);
                } else {
                    block(key, package.object);
                }
            } else {
                block(key, nil);
            }
        });
    };
    
    id <NSCoding> object = [[YZNetworkCache memoryCache] objectForKey:key];
    if (object) {
        callBack(object);
    } else {
        callBack(nil);
    }
}

- (void)removeMemoryCache {
    [[YZNetworkCache memoryCache] removeAllObjects];
}
- (void)removeAllCache {
    [self removeMemoryCache];
}

#pragma mark getter
+ (NSCache *)memoryCache {
    if (!_memoryCache) {
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.name = YZNetworkCacheName;
    }
    
    return _memoryCache;
}
@end
