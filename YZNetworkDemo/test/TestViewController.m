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
#import "DownLoadFileApi.h"

@interface TestViewController ()

@property (nonatomic, strong) DefaultServerApi *defaultApi;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
- (IBAction)testNormalRequest:(id)sender {
    DefaultServerApi *request = [[DefaultServerApi alloc] init];
    request.requestParameter = @{@"city":@"深圳"};
    [request startWithSuccess:^(YZNetworkResponse *response) {
        NSData * jsonData= [NSJSONSerialization dataWithJSONObject:response.responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", jsonString);
    } failure:^(YZNetworkResponse *response) {
        NSLog(@"%@", response.responseObject);
    }];
}

- (IBAction)testDownRequest:(id)sender {
    DownLoadFileApi *request = [[DownLoadFileApi alloc] init];
    request.requestMethod = YZRequestMethodGET;
    request.requestURL = @"sinacn/w1080h1511/20180105/de4d-fyqincu4427157.jpg";
    request.downloadPath = [self homePath];
    [request startWithUploadProgress:nil downloadProgress:^(NSProgress *progress) {
        NSLog(@"文件下载进度= %@", progress);
    } success:^(YZNetworkResponse *response) {
        NSLog(@"文件下载成功, 路径：%@", response.responseObject);
    } failure:^(YZNetworkResponse *response) {
        NSLog(@"文件下载失败, 错误：%@", response.error);
    }];
}

- (NSString *)homePath{
    return NSHomeDirectory();
}


@end
