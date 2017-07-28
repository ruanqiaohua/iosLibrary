//
//  UIWebViewEx.h
//  masterlive
//
//  Created by liu on 15/10/30.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleViewEx.h"
#import "BaseViewController.h"

@protocol WebViewDelegate <NSObject>

@optional
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
-(void)scrollViewDidEndDecelerating:(UIScrollView *)sv;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end

@protocol WebJsInterface <NSObject>

-(void)procJsCallWithFunName:(NSString *)fn params:(NSArray *)params;

@end

@class UIWebViewEx;

@interface AbsWebJsInterfaceImpl : NSObject<WebJsInterface>

@property(weak,nonatomic) UIWebViewEx           * web;
@property(weak,nonatomic) BaseViewController    * parentVC;
@property(weak,nonatomic) TitleViewEx           * titleView;

@end

@interface UIWebViewEx : UIWebView

@property(weak,nonatomic) id<WebViewDelegate> webDelegate;
@property(weak,nonatomic) id<WebJsInterface> jsDelegate;

-(void)setUrl:(NSString *)url;

@end
