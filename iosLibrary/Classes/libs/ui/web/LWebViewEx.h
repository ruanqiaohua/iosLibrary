//
//  LWebViewEx.h
//  iosLibrary
//
//  Created by liu on 2017/11/2.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@protocol LWebViewExDelegate <NSObject>

//-(void)

@end

@interface LWebViewEx : WKWebView

-(void)loadUrl:(NSString *)url;
-(void)addJsFunNames:(NSArray<NSString *> *)js;
-(void)clearCache;

@end
