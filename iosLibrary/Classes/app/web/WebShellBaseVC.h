//
//  WebShellBaseVC.h
//  iosLibrary
//
//  Created by liu on 2018/1/3.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebPluginBase.h"
#import "LTitleView.h"
@class BaseAppVC;
@class UIWebViewEx;


@protocol IWebShell

-(void)openUrl:(NSString *)url title:(NSString *)title isShowReturn:(BOOL)isShowReturn titleLocation:(NSUInteger)tl isCloseReload:(BOOL)isCloseReload;
-(void)closeWindowWithParentClose:(BOOL)isParentClose execJs:(NSString *)js;
-(BaseViewController *)getVC;
-(Class)getVCClass;
-(id<IWebPlugin>)getWebPluginWithName:(NSString *)name;
-(void)execJScript:(NSString *)js;
-(void)execPluginWithFunName:(NSString *)name json:(NSDictionary *)json callback:(NSString *)cb;
-(UIWebViewEx *)getWebView;
-(id<ITitleView>)getTitleView;
-(void)jsCallWithFunName:(NSString *)name param:(NSObject *)param;
-(void)pluginCallbackWithFunName:(NSString *)name param:(NSObject *)param;

@end

@interface WebShellVCBase : BaseAppVC<IWebShell>



@end
