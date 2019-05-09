//
//  DownLoadFileApi.m
//  YZNetwork
//
//  Created by zhuo on 2019/5/9.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "DownLoadFileApi.h"

@implementation DownLoadFileApi

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.baseURL = @"http://n.sinaimg.cn";
        self.timeoutInterval = 25;
    }
    return self;
}

@end
