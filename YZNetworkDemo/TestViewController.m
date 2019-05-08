//
//  TestViewController.m
//  YZNetworkTests
//
//  Created by zhuo on 2019/5/8.
//  Copyright © 2019 zhuo. All rights reserved.
//

#import "TestViewController.h"
#import "DefaultServerApi.h"
#import "YZBaseRequest.h"
#import "YZNetworkResponse.h"

@interface TestViewController ()

@property (nonatomic, strong) DefaultServerApi *defaultApi;


@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self testNormalRequest];
}

- (void)testNormalRequest {
    DefaultServerApi *request = [[DefaultServerApi alloc] init];
    request.requestMethod = YZRequestMethodGET;
    request.requestURL = @"novelSearchApi";
    request.requestParameter = @{@"name":@"盗墓笔记"};
    request.requestSerializerType = YZRequestSerializerTypeJSON;
    [request startWithSuccess:^(YZNetworkResponse *response) {
        NSLog(@"%@", response.responseObject);
    } failure:^(YZNetworkResponse *response) {
        NSLog(@"%@", response.responseObject);
    }];
}


@end
