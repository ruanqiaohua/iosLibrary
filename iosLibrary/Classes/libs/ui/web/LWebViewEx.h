//
//  LWebViewEx.h
//  iosLibrary
//
//  Created by liu on 2017/11/2.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewDelegate.h"

API_AVAILABLE(ios(8.0))
@interface LWebViewEx : WKWebView<IWebView>

+(instancetype)get;
//js
-(void)addJsFunNames:(NSArray<NSString *> *)js;
-(void)removeJsFunName:(NSString *)fun;
-(void)removeAllJs;
//cookie
-(NSString *)getCurrentCookieWithDomain:(NSString *)domain;
-(void)clearCache;

@end
