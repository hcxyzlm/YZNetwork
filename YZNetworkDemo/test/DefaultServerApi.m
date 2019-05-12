//
//  DefaultServerApi.m
//  YZNetwork
//
//  Created by zhuo on 2019/5/8.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "DefaultServerApi.h"

@implementation DefaultServerApi

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)baseURL {
    return @"https://www.apiopen.top";
}

- (NSTimeInterval)timeoutInterval {
    return 60;
}

- (NSString *)requestURL {
    return @"weatherApi";
}

- (YZRequestMethod)requestMethod {
    return YZRequestMethodGET;
}
- (YZRequestSerializerType)requestSerializerType {
    return YZRequestSerializerTypeJSON;
}

#pragma mark - Override


@end
