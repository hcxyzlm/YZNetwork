//
//  YZBaseRequest+Private.m
//  YZNetwork
//
//  Created by zhuo on 2019/5/7.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "YZBaseRequest+Private.h"

@implementation YZBaseRequest (Private)

- (NSString *)requestHttpMethedString {
    switch (self.requestMethod) {
        case YZRequestMethodGET:
            return @"GET";
        case YZRequestMethodPOST:
            return @"POST";
        case YZRequestMethodHEAD:
            return @"HEAD";
        case YZRequestMethodPUT:
            return @"PUT";
        case YZRequestMethodDELETE:
            return @"DELETE";
        case YZRequestMethodPATCH:
            return @"PATCH";
    }
}

- (NSString *)buildRequestUrl {
    
    NSParameterAssert(self != nil);
    NSString * baseUrl = self.baseUrl;
    NSURL *url = [NSURL URLWithString: baseUrl];
    
    if (baseUrl.length > 0 && ![baseUrl hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    
    return [NSURL URLWithString:self.requestUrl relativeToURL:url].absoluteString;
}



@end
