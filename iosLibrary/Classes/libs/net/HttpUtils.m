//
//  HttpUtils.m
//  iosLibrary
//
//  Created by liu on 2017/9/14.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "HttpUtils.h"
#import "aes.h"
#import <AFNetworking.h>
#import <YYModel.h>

@interface HttpUtils()
{
    AFHTTPSessionManager * manager;
}
@end

@implementation HttpUtils

singleton_implementation(HttpUtils)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        manager.requestSerializer.timeoutInterval = 8;
    }
    return self;
}

-(NSString *)catReqParam:(NSDictionary *)param url:(NSString *)url isVer:(BOOL)isVer isSign:(BOOL)isSign
{
    char inbuf[1024];
    char outbuf[1024];
    //
    NSMutableString * ms = [[NSMutableString alloc] init];
    
    for (NSString * key in param)
    {
        [ms appendFormat:@"%@=%@&",key,param[key]];
    }
    long time = [[NSDate date] timeIntervalSince1970];
    [ms appendFormat:@"t=%ld", time];
    
    NSLog(@"url_param = %@%@", url, ms);
    
    NSString * req = url;
    if (isVer)
    {
        req = [req stringByAppendingFormat:@"v=%@", APP_VERSION];
    }
    if (isSign)
    {
        NSData * data = [ms dataUsingEncoding:NSUTF8StringEncoding];
        int len = (int)data.length;
        len = aes_ecb_encrypt_PKCS5Padding((char *)data.bytes, len, outbuf, [self.aseKey UTF8String], 128);
        bin2Hex(outbuf, len, inbuf, 1024);
        
        req = [req stringByAppendingFormat:isVer ? @"&sign=%s" : @"sign=%s", inbuf];
    }else
    {
        req = [req stringByAppendingString:ms];
    }
    
    NSLog(@"url aes = %@", req);
    return req;
}

+(NetResult *)convertStrToNetResult:(NSString *)json
{
    NSRange r = [json rangeOfString:@"}}"];
    if (r.location != NSNotFound)
    {
        json = [json substringToIndex:r.location + 2];
    }else
    {
        r = [json rangeOfString:@"}"];
        if (r.location != NSNotFound)
        {
            json = [json substringToIndex:r.location + 1];
        }
    }
    return [NetResult yy_modelWithJSON:json];
}

+(NSString *)URLDecodedString:(NSString *)stringURL
{
    return [stringURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(void)procFailureTask:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error onResult:(void (^)(NetResult * nr))onResult
{
    NetResult * nr = ONEW(NetResult);
    nr.state = STATE_CODE_ERROR;
    if (task && task.response)
    {
        nr.ret = FRMSTR(@"网络错误（hc = %ld）",(long)((NSHTTPURLResponse *)task.response).statusCode);
    }else
    {
        nr.ret = FRMSTR(@"网络错误（ec = %ld）",(long)error.code);
    }
    onResult(nr);
}

-(void)procFailureTask:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error onStrResult:(void (^)(BOOL isSuccess, NSString * nr))onResult
{
    NSString * str;
    if (task && task.response)
    {
        str = FRMSTR(@"网络错误（hc = %ld）",(long)((NSHTTPURLResponse *)task.response).statusCode);
    }else
    {
        str = FRMSTR(@"网络错误（ec = %ld）",(long)error.code);
    }
    onResult(NO, str);
}

+(NetResult *)analyesDecodeData:(NSData *)data aesKey:(NSString *)aesKey
{
    int len = (int)data.length;
    char inbuf[len];
    char outbuf[len];
    len = hex2bin((char *)[data bytes], (unsigned char *)inbuf, len);
    if (len > 0)
    {
        aes_ecb_decrypt_PKCS5Padding(inbuf, len, outbuf, [aesKey UTF8String], 128);
        NSString * vl = [NSString stringWithFormat:@"%s", outbuf];
        vl = [HttpUtils URLDecodedString:vl];
        
        NSLog(@"ret = %@ len = %lu",vl, (unsigned long)vl.length);
        return [HttpUtils convertStrToNetResult:vl];
    }
    return nil;
}

-(void)getUrl:(NSString *)url param:(NSDictionary *)param onResult:(void (^)(NetResult * nr))onResult
{
    WEAKOBJ(self);
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress)
     {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSString * vl = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         vl = [HttpUtils URLDecodedString:vl];
         onResult([NetResult yy_modelWithJSON:vl]);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [weak_self procFailureTask:task error:error onResult:onResult];
     }];
}

-(void)getUrl:(NSString *)url aesParam:(NSDictionary *)param onResult:(void (^)(NetResult * nr))onResult
{
    WEAKOBJ(self);
    NSString * reqUrl = [self catReqParam:param url:url isVer:NO isSign:YES];
    [manager GET:reqUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress)
     {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         onResult([HttpUtils analyesDecodeData:responseObject aesKey:weak_self.aseKey]);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [weak_self procFailureTask:task error:error onResult:onResult];
     }];
}

-(void)getCmd:(NetReqCmd *)cmd onResult:(void (^)(NetResult * nr))onResult
{
    if (cmd.isEnc)
    {
        [self getUrl:cmd.url aesParam:[cmd.params yy_modelToJSONObject] onResult:onResult];
        return;
    }
    [self getUrl:cmd.url param:cmd.params onResult:onResult];
}

-(void)uploadFile:(NSDictionary<NSString *, NSData *> *)fileDatas reqCmd:(NetReqCmd *)cmd onStrResult:(void (^)(NSString * nr))onResult onProgress:(void (^)(float progress))onProgress failure:(void (^)(BOOL isSuccess, NSString * nr)) failure
{
    WEAKOBJ(self);
    [manager POST:cmd.url parameters:[cmd.params yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         for (NSString * name in fileDatas.allKeys)
         {
             [formData appendPartWithFormData:fileDatas[name] name:name];
         }
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
         if (!onProgress)return;
         onProgress(1.0f * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         onResult(str);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         [weak_self procFailureTask:task error:error onStrResult:failure];
     }];
}

-(void)uploadImage:(NSDictionary<NSString *, UIImage *> *)images reqCmd:(NetReqCmd *)cmd onStrResult:(void (^)(NSString * result))onResult onProgress:(void (^)(float progress))onProgress failure:(void (^)(BOOL isSuccess, NSString * err)) failure
{
    float icq = self.imageCompressionQuality;
    WEAKOBJ(self);
    [manager POST:cmd.url parameters:[cmd.params yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData * data;
         int i = 0;
         for (NSString * name in images.allKeys)
         {
             data = UIImageJPEGRepresentation(images[name], icq);
             if (data)
             {
                 [formData appendPartWithFileData:data name:name fileName:FRMSTR(@"upfile_%d.jpg",i) mimeType:@"image/jpeg"];
             }else
             {
                 data = UIImagePNGRepresentation(images[name]);
                 if (data)
                 {
                     [formData appendPartWithFileData:data name:name fileName:FRMSTR(@"upfile_%d.png",i) mimeType:@"image/png"];
                 }
             }
         }
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
         if (!onProgress)return;
         onProgress(1.0f * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         onResult(str);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         [weak_self procFailureTask:task error:error onStrResult:failure];
     }];
}

-(void)uploadImage:(NSDictionary<NSString *, UIImage *> *)images reqCmd:(NetReqCmd *)cmd onResult:(void (^)(NetResult * nr))onResult
{
    float icq = self.imageCompressionQuality;
    WEAKOBJ(self);
    [manager POST:cmd.url parameters:[cmd.params yy_modelToJSONObject] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         NSData * data;
         int i = 0;
         for (NSString * name in images.allKeys)
         {
             data = UIImageJPEGRepresentation(images[name], icq);
             if (data)
             {
                 [formData appendPartWithFileData:data name:name fileName:FRMSTR(@"upfile_%d.jpg",i) mimeType:@"image/jpeg"];
             }else
             {
                 data = UIImagePNGRepresentation(images[name]);
                 if (data)
                 {
                     [formData appendPartWithFileData:data name:name fileName:FRMSTR(@"upfile_%d.png",i) mimeType:@"image/png"];
                 }
             }
         }
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
         NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NetResult * nr = [NetResult yy_modelWithJSON:str];
         onResult(nr);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         [weak_self procFailureTask:task error:error onResult:onResult];
     }];
}

-(void)postUrl:(NSString *)url param:(NSDictionary *)param head:(NSDictionary *)head onResult:(void (^)(BOOL isSucess, NSString * result))onResult
{
    WEAKOBJ(self);
    if (head)
    {
        for (NSString * key in head)
        {
            [manager.requestSerializer setValue:head[key] forHTTPHeaderField:key];
        }
    }
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString * str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        onResult(YES, str);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weak_self procFailureTask:task error:error onStrResult:onResult];
    }];
}

@end
