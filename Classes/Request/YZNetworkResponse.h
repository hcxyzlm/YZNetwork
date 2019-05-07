//
//  YZNetworkRepose.h
//  YZNetwork
//
//  Created by zhuo on 2019/5/8.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZNetworkResponse : NSObject

/** 请求成功数据*/
@property (nonatomic, strong, readonly, nullable) id responseObject;

/** 请求原始http数据*/
@property (nonatomic, strong, readonly, nullable) NSHTTPURLResponse *httpURLResponse;

/** 错误*/
@property (nonatomic, strong, readonly, nullable) NSError * error;

@end

NS_ASSUME_NONNULL_END
