//
//  WebShellBaseVC.m
//  iosLibrary
//
//  Created by liu on 2018/1/3.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebShellVCBase.h"
#import "LTitleView.h"
#import "UIWebViewEx.h"
#import "LWebViewEx.h"
#import "WebPluginBase.h"
#import "toolMacro.h"
#import <YYModel.h>
//plugin
#import "WebWXPlugin.h"
#import "WebSystemPlugin.h"
#import "WebTitleViewPlugin.h"
#import "WebWindowPlugin.h"

@interface WebShellVCBase()<WebJsInterface>
@end

@implementation WebShellVCBase

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _plugins = ONEW(NSMutableArray);
    }
    return self;
}

-(void)initUI
{
    _titleView = ONEW(LTitleView);
    _titleView.backgroundColor = self.skinCfg.titleViewBgColor;
    [self.contentLayout addSubview:_titleView];
    _titleView.myHeight = TITLE_VIEW_HEIGHT;
    _titleView.widthSize.equalTo(self.contentLayout);
    _titleView.space = self.skinCfg.titleViewSpace;
    _titleView.lrSpace = self.skinCfg.titleViewLRSpace;
    //web
    if (@available(iOS 8.0, *)) {
        _webView = [LWebViewEx get];
        [((LWebViewEx *)_webView) addJsFunNames:@[@"exec"]];
    } else {
        _webView = ONEW(UIWebViewEx);
    }
    UIView * v = [_webView getWebView];
    [self.contentLayout addSubview:v];
    v.topPos.equalTo(_titleView.bottomPos);
    v.widthSize.equalTo(self.contentLayout);
    v.bottomPos.equalTo(self.contentLayout);
    _webView.jsDelegate = self;
}

-(void)onInitData:(NSDictionary *)data
{
    [_webView loadUrl:data[WS_URL]];
    [self loadWebPlugin];
    [self activeWebPluginEvent:EVENT_INIT data:data];
}

-(void)onVCResult:(NSDictionary *)data
{
    if (data)
    {
        [self activeWebPluginEvent:EVENT_RESULT_DATA data:data];
    }
}

-(void)activeWebPluginEvent:(NSInteger)event data:(NSDictionary *)data
{
    switch (event)
    {
        case EVENT_INIT:
            for (WebPluginBase * plg in _plugins)
            {
                plg.shell = self;
                [plg initPluginWithData:data];
            }
            break;
        case EVENT_DEINIT:
            for (id<IWebPlugin> plg in _plugins)
            {
                [plg deInitPlugin];
            }
            break;
        case EVENT_RESULT_DATA:
            for (id<IWebPlugin> plg in _plugins)
            {
                [plg vcResultData:data];
            }
            break;
        case EVENT_EXEC:
            for (id<IWebPlugin> plg in _plugins)
            {
                if ([plg execWithFunName:data[FUN_NAME] param:data callback:data[CALL_BACK]]) break;
            }
            break;
    }
}

#pragma -------------------------------------------------
-(void)openUrl:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn titleLocation:(NSUInteger)tl bNextSelfClose:(BOOL)bNextSelfClose
{
    NSDictionary * data = @{WS_URL:url,
                            WS_TITLE:title,
                            WS_SHOW_RETURN:@(bShowReturn),
                            WS_TITLE_LOCATION:@(tl)
                            };
    self.showInfo.isNextCloseSelfColse = bNextSelfClose;
    [BaseViewController showPresentClass:[self class] withVC:self data:data];
}

-(void)closeWindowWithLevel:(NSInteger)level bCloseReload:(BOOL)bCloseReload closeExecJs:(NSString *)js
{
    NSDictionary * data = @{
                            WS_CLOSE_PARENT_CLOSE_LEVEL:@(level),
                            WS_CLOSE_RELOAD:@(bCloseReload),
                            WS_CLOSE_EXEC_JS:SAFESTR(js)
                            };
    [BaseViewController popCount:level data:data];
}

-(BaseAppVC *)getVC
{
    return self;
}

-(Class)getVCClass
{
    return self.class;
}

-(id<IWebPlugin>)getWebPluginWithName:(NSString *)name
{
    for (id<IWebPlugin> plg in _plugins)
    {
        if ([[plg getName] isEqualToString:name])
        {
            return plg;
        }
    }
    return nil;
}

-(void)runJScript:(NSString *)js
{
    [self.webView runJs:js];
}

-(void)execPluginWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    [self activeWebPluginEvent:EVENT_EXEC data:@{FUN_NAME:name,PARAM:param,CALL_BACK:cb}];
}

-(id<IWebView>)getWebView
{
    return self.webView;
}

-(id<ITitleView>)getTitleView
{
    return self.titleView;
}

#pragma ------------- public fun
-(NSString *)getTitleViewReturnBtn
{
    return nil;
}

+(void)openClass:(Class)cls url:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn titleLocation:(NSUInteger)tl isDirect:(BOOL)isDirect
{
    NSDictionary * data = @{WS_URL:url,
                            WS_TITLE:title,
                            WS_SHOW_RETURN:@(bShowReturn),
                            WS_TITLE_LOCATION:@(TITLE_ALIG_MIDDLE)
                            };
    if (isDirect)
    {
        [BaseAppVC showVCClass:cls showType:VC_SHOW_DIRECT isAnimated:NO withVC:nil data:data];
        return;
    }
    [BaseAppVC showVCClass:cls showType:VC_SHOW_PRESENT isAnimated:YES withVC:[BaseAppVC getCurrVC] data:data];
}

+(void)openClass:(Class)cls url:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn isDirect:(BOOL)isDirect
{
    [WebShellVCBase openClass:cls url:url title:title bShowReturn:bShowReturn titleLocation:TITLE_ALIG_MIDDLE isDirect:isDirect];
}

+(void)openClass:(Class)cls url:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn
{
    [WebShellVCBase openClass:cls url:url title:title bShowReturn:bShowReturn titleLocation:TITLE_ALIG_MIDDLE isDirect:NO];
}

-(void)loadWebPlugin
{
    [self.plugins addObject:ONEW(WebWXPlugin)];
    [self.plugins addObject:ONEW(WebTitleViewPlugin)];
    [self.plugins addObject:ONEW(WebSystemPlugin)];
    [self.plugins addObject:ONEW(WebWindowPlugin)];
}

#pragma ---------- web js
-(void)procJsCallWithFunName:(NSString *)fn params:(NSArray *)params
{
    if ([fn isEqualToString:WEB_JS_EXEC])
    {
        NSData * jsonData = [params[0] dataUsingEncoding : NSUTF8StringEncoding];
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        for (NSDictionary * dict in arr)
        {
            [self activeWebPluginEvent:EVENT_EXEC data:dict];
        }
    }
}

-(void)procJson:(NSString *)json
{
    
}

@end
