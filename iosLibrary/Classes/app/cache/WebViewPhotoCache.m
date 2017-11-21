//
//  WebViewPhotoCache.m
//  iosLibrary
//
//  Created by liu on 2017/10/17.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "WebViewPhotoCache.h"
#import "NSString+NSStringHelper.h"
#import <YYCache/YYCache.h>
#import <UIKit/UIKit.h>
#import "UIImage+SubImage.h"
#import "toolMacro.h"

static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";
static NSString * const CACHE_NAME = @"ljh_webview_cache_name";
static NSSet * CachingSupportedSchemes;

@interface WebViewPhotoCache()<NSURLConnectionDelegate>

@property(nonatomic, strong) YYCache * cache;
@property(nonatomic, strong) NSURLConnection * connection;
@property(nonatomic, strong) NSMutableData * data;
@property(nonatomic, strong) NSURLResponse * response;

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

-(YYCache *)cache
{
    if (!_cache)
    {
        _cache = [YYCache cacheWithName:CACHE_NAME];
    }
    return _cache;
}

- (void)startLoading
{
    //获取本地缓存文件
    NSString * url = [[self.request URL] absoluteString];
    NSString * md5 = [url md5];
    NSData * data = (NSData *)[self.cache objectForKey:md5];
    if (data)
    {
        NSString * mimeType = @"image/*.*";
        NSMutableDictionary *header = [[NSMutableDictionary alloc] initWithCapacity:2];
        NSString *contentType = [mimeType stringByAppendingString:@";charset=UTF-8"];
        header[@"Content-Type"] = contentType;
        header[@"Content-Length"] = [NSString stringWithFormat:@"%lu", (unsigned long) data.length];

        NSHTTPURLResponse * httpResponse = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL
                                                                      statusCode:200
                                                                     HTTPVersion:@"1.1"
                                                                    headerFields:header];

        [self.client URLProtocol:self didReceiveResponse:httpResponse cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
        return;
    }
    NSMutableURLRequest * mutableRequest = [[self request] mutableCopy];

    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableRequest];
    self.connection = [NSURLConnection connectionWithRequest:mutableRequest
                                                    delegate:self];
}

- (void)stopLoading
{
    [[self connection] cancel];
    self.connection = nil;
}

#pragma mark - NSURLConnectionDelegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.client URLProtocol:self didFailWithError:error];
}

-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if (response != nil)
    {
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

-(BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self.client URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [self.client URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.client URLProtocol:self didLoadData:data];
    if (self.data == nil)
    {
        self.data = [data mutableCopy];
        return;
    }
    [self.data appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.client URLProtocolDidFinishLoading:self];
    [self.cache setObject:self.data forKey:[[[self.request URL] absoluteString] md5]];
}

@end
