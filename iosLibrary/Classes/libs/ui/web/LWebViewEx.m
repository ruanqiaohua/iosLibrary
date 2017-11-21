//
//  LWebViewEx.m
//  iosLibrary
//
//  Created by liu on 2017/11/2.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "LWebViewEx.h"
#import "toolMacro.h"
#import <WebKit/WKScriptMessageHandler.h>

@implementation LWebViewEx

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

-(void)clearCache
{
    if (IOS_VERSION >= 9)
    {
        NSSet * types = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
                                              WKWebsiteDataTypeMemoryCache]];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:[NSDate date] completionHandler:^{}];
    }else
    {
        NSString * path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingString:@"/Cookies"] error:nil];
    }
}

@end
