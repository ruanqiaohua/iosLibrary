//
//  HttpNet.m
//  iosLibrary
//
//  Created by liu on 2018/10/17.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "HttpNet.h"
#import <AFNetworking.h>

#define NET_ERR_RELOGIN     @"请登录"
#define NET_ERR_REQ         @"请求出错"

@interface HttpNet()
{
    AFHTTPSessionManager * httpManager;
    AFHTTPSessionManager * jsonManager;
}
@end

@implementation HttpNet

singleton_implementation(HttpNet)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        httpManager = [AFHTTPSessionManager manager];
        httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [httpManager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        httpManager.requestSerializer.timeoutInterval = 8;
        //
        jsonManager = [AFHTTPSessionManager manager];
        jsonManager.requestSerializer = [AFJSONRequestSerializer serializer];
        jsonManager.responseSerializer = [AFJSONResponseSerializer serializer];
        [jsonManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        jsonManager.requestSerializer.timeoutInterval = 8;
    }
    return self;
}

-(void)postUrl:(NSString *)url param:(NSDictionary *)param onResult:(void (^)(BOOL isOK, NSString * msg, NSInteger httpCode, NSDictionary * dict))onResult
{
    [httpManager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        onResult(YES, nil, HTTP_CODE_OK, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger hc = ((NSHTTPURLResponse *)task.response).statusCode;
        onResult(NO, FRMSTR(@"%@ (%ld)", NET_ERR_REQ, (long)hc), hc, @{HTTP_ERR_KEY:error});
    }];
}

-(void)postUrl:(NSString *)url json:(NSDictionary *)json onResult:(void (^)(BOOL isOK, NSString * msg, NSInteger httpCode, NSDictionary * dict))onResult
{
    [jsonManager POST:url parameters:json progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        onResult(YES, nil, HTTP_CODE_OK, responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger hc = ((NSHTTPURLResponse *)task.response).statusCode;
        onResult(NO, FRMSTR(@"%@ (%ld)", NET_ERR_REQ, (long)hc), hc, @{HTTP_ERR_KEY:error});
    }];
}

@end
