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
#import "WebViewDelegate.h"

@class UIWebViewEx;

@interface AbsWebJsInterfaceImpl : NSObject<WebJsInterface>

@property(weak,nonatomic) UIWebViewEx           * web;
@property(weak,nonatomic) BaseViewController    * parentVC;
@property(weak,nonatomic) TitleViewEx           * titleView;

@end

@interface UIWebViewEx : UIWebView<UIWebViewDelegate,IWebView>

@end
