//
//  WebViewPhotoCache.m
//  iosLibrary
//
//  Created by liu on 2017/10/17.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "WebViewPhotoCache.h"
#import "NSString+NSStringHelper.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";
static NSSet * CachingSupportedSchemes;

@interface WebViewPhotoCache()<NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection * connection;
@property (nonatomic, strong) NSMutableData * data;
@property (nonatomic, strong) NSURLResponse * response;

@end

@implementation WebViewPhotoCache

+(void)initialize
{
    if (self == [WebViewPhotoCache class])
    {
        CachingSupportedSchemes = [NSSet setWithObjects:@"http", @"https", nil];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    if ([CachingSupportedSchemes containsObject:[[request URL] scheme]])
    {
        NSString * path = request.URL.path;
        if ([path hasSuffix:@".jpg"]
            || [path hasSuffix:@".jpeg"]
            || [path hasSuffix:@".png"])
        {
            if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request])
            {
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

- (void)startLoading
{
    NSData
    //获取本地缓存文件
    NSString * url = [[self.request URL] absoluteString];
    NSString * urlMd5 = [url md5];

}

@end
