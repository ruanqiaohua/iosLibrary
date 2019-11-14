//
//  WebViewDelegate.h
//  iosLibrary
//
//  Created by jinhui liu on 2019/10/12.
//  Copyright © 2019 liu. All rights reserved.
//

#ifndef WebViewDelegate_h
#define WebViewDelegate_h
#import <WebKit/WebKit.h>

#define WEB_TYPE_UI     0
#define WEB_TYPE_WK     1
#define WEB_JS_SCHEME   @"ios:"
#define WEB_JS_EXEC     @"exec"
#define FUN_NAME        @"method"
#define PARAM           @"param"
#define CALL_BACK       @"callback"

@protocol WebViewDelegate <NSObject>

@optional
//将要开始加载网页时回调，返回true为加载
-(BOOL)webView:(id)webView shouldStartLoadWithUrl:(NSURL *)url webViewType:(NSInteger)type;
//开始加载网页
-(void)webView:(id)webView didStartLoadWithWebViewType:(NSInteger)type;
//网页加载完成
-(void)webView:(id)webView didFinishLoadWithWebViewType:(NSInteger)type;
//网页加载失败
-(void)webView:(id)webView didFailLoadWithError:(NSError *)error webViewType:(NSInteger)type;
//
-(void)scrollViewDidEndDecelerating:(UIScrollView *)sv;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
//返回错误页面
-(NSString *)getErrorWeb;
@end

@protocol WebJsInterface <NSObject>

-(void)procJsCallWithFunName:(NSString *)fn params:(NSArray *)params;
-(void)procJson:(NSString *)json;

@end

//UIWebView 和 WKWebView 统一实现r接口
@protocol IWebView <NSObject>

@property(assign,nonatomic) BOOL isWebLoadErr;
@property(weak,nonatomic) id<WebViewDelegate> webDelegate;
@property(weak,nonatomic) id<WebJsInterface> jsDelegate;

-(id)getWebView;
-(NSInteger)getWebType;
-(void)loadUrl:(NSString *)url;
-(void)runJs:(NSString *)js;
-(void)reloadEx;

@end

#endif /* WebViewDelegate_h */
