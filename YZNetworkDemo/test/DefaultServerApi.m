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
        self.baseURL = @"https://www.apiopen.top";
        self.timeoutInterval = 25;
    }
    return self;
}

#pragma mark - Override


@end
