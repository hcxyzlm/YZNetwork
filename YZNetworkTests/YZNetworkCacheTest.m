//
//  YZNetworkCacheTest.m
//  YZNetworkTests
//
//  Created by zhuo on 2019/5/14.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DefaultServerApi.h"
#import "YZBaseRequest.h"
#import "YZNetworkResponse.h"
#import "YZNetworkCache.h"

@interface YZNetworkCacheTest : XCTestCase

@end

@implementation YZNetworkCacheTest {
    DefaultServerApi * _api;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _api = [[DefaultServerApi alloc] init];
    _api.requestParameter = @{@"city":@"深圳"};
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [_api.cacheHandler removeAllCache];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testMemoryCache {
    [_api.cacheHandler removeAllCache];
    __weak typeof(self) weakSelf = self;
    _api.cacheHandler.wirteMode = YZRequestCacheWriteModeMemory;
    [_api startWithSuccess:^(YZNetworkResponse *response) {
        __strong typeof(weakSelf) self = weakSelf;
        XCTAssertTrue(response.error == nil);
        // cache
    } failure:^(YZNetworkResponse *response) {
    }];
    
    sleep(5);
    
    id cacheObject = [_api getObjectFromCache];
    NSLog(@"memory cache json = %@", cacheObject);
    XCTAssertTrue(cacheObject != nil);
}

- (void)testDiskCache {
    [_api.cacheHandler removeAllCache];
    __weak typeof(self) weakSelf = self;
    _api.cacheHandler.wirteMode = YZRequestCacheWriteModeDisk;
    [_api startWithSuccess:^(YZNetworkResponse *response) {
        
        __strong typeof(weakSelf) self = weakSelf;
        XCTAssertTrue(response.error == nil);
        
    } failure:^(YZNetworkResponse *response) {
    }];
    sleep(5);
    id cacheObject = [self->_api getObjectFromCache];
    NSLog(@"disk cache json = %@", cacheObject);
    XCTAssertTrue(cacheObject != nil);
}

@end
