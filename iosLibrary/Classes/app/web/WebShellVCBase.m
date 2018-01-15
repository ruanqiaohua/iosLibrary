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
#import "WebPluginBase.h"
#import "toolMacro.h"

#define FUN_NAME    @"funName"
#define PARAM       @"param"
#define CALL_BACK   @"callback"

@implementation WebShellVCBase

-(void)initUI
{
    _titleView = ONEW(LTitleView);
    _titleView.backgroundColor = self.skinCfg.titleViewBgColor;
    [self.contentLayout addSubview:_titleView];
    _titleView.myHeight = TITLE_VIEW_HEIGHT;
    _titleView.widthSize.equalTo(self.contentLayout);
    //web
    _webView = ONEW(UIWebViewEx);
    [self.contentLayout addSubview:_webView];
    _webView.topPos.equalTo(_titleView.bottomPos);
    _webView.widthSize.equalTo(self.contentLayout);
    _webView.bottomPos.equalTo(self.contentLayout);
}

-(void)onInitData:(NSDictionary *)data
{
    [self activeWebPluginEvent:EVENT_INIT data:data];
}



-(void)onVCResult:(NSDictionary *)data
{
    if (data)
    {
        [self activeWebPluginEvent:EVENT_RESULT_DATA data:data];
    }
}

-(UIImage *)getReturnBtnImage
{
    return nil;
}

-(void)activeWebPluginEvent:(NSInteger)event data:(NSDictionary *)data
{
    switch (event)
    {
        case EVENT_INIT:
            for (id<IWebPlugin> plg in _plugins)
            {
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
                if ([plg execWithFunName:data[FUN_NAME] param:data[PARAM] callback:data[CALL_BACK]]) break;
            }
            break;
    }
}

#pragma -------------------------------------------------
-(void)openUrl:(NSString *)url title:(NSString *)title bShowReturn:(BOOL)bShowReturn titleLocation:(NSUInteger)tl closeLevel:(NSInteger)level bCloseReload:(BOOL)bCloseReload closeExecJs:(NSString *)js
{
    NSDictionary * data = @{WS_URL:url,
                            WS_TITLE:title,
                            WS_SHOW_RETURN:@(bShowReturn),
                            WS_TITLE_LOCATION:@(tl),
                            WS_CLOSE_PARENT_CLOSE_LEVEL:@(level),
                            WS_CLOSE_RELOAD:@(bCloseReload),
                            WS_CLOSE_EXEC_JS:js
                            };
    [BaseViewController showPresentVC:self withVC:[BaseViewController getCurrVC] data:data];
}

-(void)closeWindowWithLevel:(NSInteger)level bCloseReload:(BOOL)bCloseReload closeExecJs:(NSString *)js
{
    NSDictionary * data = @{
                            WS_CLOSE_PARENT_CLOSE_LEVEL:@(level),
                            WS_CLOSE_RELOAD:@(bCloseReload),
                            WS_CLOSE_EXEC_JS:js
                            };
    [self closeWindowVCWithData:data delay:0];
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

-(void)execJScript:(NSString *)js
{
    [self.webView execJs:js];
}

-(void)execPluginWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    [self activeWebPluginEvent:EVENT_EXEC data:@{FUN_NAME:name,PARAM:param,CALL_BACK:cb}];
}

-(UIWebViewEx *)getWebView
{
    return self.webView;
}

-(id<ITitleView>)getTitleView
{
    return self.titleView;
}

-(void)jsCallWithFunName:(NSString *)name param:(NSObject *)param
{

}

-(void)pluginCallbackWithFunName:(NSString *)name param:(NSObject *)param
{

}

@end
