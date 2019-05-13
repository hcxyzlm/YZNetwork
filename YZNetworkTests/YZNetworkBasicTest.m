//
//  YZNetworkBasicTest.m
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

@interface YZNetworkBasicTest : XCTestCase

@end

@implementation YZNetworkBasicTest {
    DefaultServerApi * _api;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    _api = [[DefaultServerApi alloc] init];
    _api.requestParameter = @{@"city":@"北京"};
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testBasicRequest {
    [_api startWithSuccess:^(YZNetworkResponse *response) {
        XCTAssertTrue(response.error == nil);
        NSLog(@"basic request objcet = %@", response.responseObject);
    } failure:^(YZNetworkResponse *response) {
        
    }];
}

@end
