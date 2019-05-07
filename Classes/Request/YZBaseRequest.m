//
//  YZBaseRequest.m
//  YZNetwork
//
//  Created by zhuo on 2019/5/6.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "YZBaseRequest.h"

@interface YZBaseRequest()

@end

@implementation YZBaseRequest


#pragma mark - Getter & Setter


#pragma mark - Delegate

#pragma mark - Public

- (void)start {
    
}

- (void)cancle {
    
}

#pragma mark - Private

- (void)clearRequestBlocks {
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}

@end
