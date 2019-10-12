//
//  LWebViewEx.m
//  iosLibrary
//
//  Created by liu on 2017/11/2.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "LWebViewEx.h"
#import <UIKit/UIKit.h>
#import "toolMacro.h"
#import "WeakWebViewScriptMessageDelegate.h"
#import "UIView+UIViewHelper.h"
#import <WebKit/WKScriptMessageHandler.h>
#import "BaseAppVC.h"

@interface LWebViewEx()<WKScriptMessageHandler,WKUIDelegate, WKNavigationDelegate>
{
    NSMutableArray                  * jsNameList;
    NSString                        * lastUrl;
    UIActivityIndicatorView         * loadingView;
}
@end

@implementation LWebViewEx

@synthesize webDelegate,jsDelegate,isWebLoadErr;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // UI代理
        self.UIDelegate = self;
        // 导航代理
        self.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        //self.allowsBackForwardNavigationGestures = YES;
        
        //保存js回调的所有名字，用于注销
        jsNameList = ONEW(NSMutableArray);
        
        loadingView = [[UIActivityIndicatorView alloc] init];
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        loadingView.hidesWhenStopped = YES;
        [self addSubview:loadingView];
    }
    return self;
}

+(WKWebViewConfiguration *)configWebView
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];            
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    config.allowsInlineMediaPlayback = YES;
    
    if (@available(iOS 9.0, *))
    {
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.requiresUserActionForMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        //config.applicationNameForUserAgent = @"ChinaDailyForiPad";
    }
    //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
    //这个类主要用来做native与JavaScript的交互管理
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
    //[wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
    //[wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
    
    config.userContentController = wkUController;
    
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    //用于进行JavaScript注入
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript];
    return config;
}

+(instancetype)get
{
    return [[LWebViewEx alloc] initWithFrame:CGRectZero configuration: [LWebViewEx configWebView]];
}

-(void)loadUrl:(NSString *)url
{
    NSURL * nurl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nurl];
    NSString * cookie = [self getCurrentCookieWithDomain:[nurl host]];
    if (cookie.length > 0)
    {
        [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (nullable WKNavigation *)loadRequest:(NSURLRequest *)request
{
    WKNavigation * nav = [super loadRequest:request];
    self.isWebLoadErr = [request.URL.absoluteString hasSuffix:@"error.html"];
    if (!self.isWebLoadErr)
    {
        lastUrl = request.URL.absoluteString;
    }
    return nav;
}

-(void)runJs:(NSString *)js
{
    [self evaluateJavaScript:js completionHandler:nil];
}

-(void)reloadEx
{
    self.isWebLoadErr = NO;
    [self loadUrl:lastUrl];
}

-(id)getWebView
{
    return self;
}

-(NSInteger)getWebType
{
    return WEB_TYPE_WK;
}

#pragma mask ---------- JS
-(void)addJsFunNames:(NSArray<NSString *> *)js
{
    if (js.count == 0)return;
    @synchronized (self)
    {
        [jsNameList addObjectsFromArray:js];
    }
    WKUserContentController * wkUController = self.configuration.userContentController;
    WeakWebViewScriptMessageDelegate * delegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
    for (NSString * fn in js)
    {
        [wkUController addScriptMessageHandler:delegate  name:fn];
    }
}

-(void)removeJsFunName:(NSString *)fun
{
    WKUserContentController * wkUController = self.configuration.userContentController;
    [wkUController removeScriptMessageHandlerForName:fun];
    @synchronized (self)
    {
        NSInteger index = [jsNameList indexOfObject:fun];
        if (index != -1)
        {
            [jsNameList removeObjectAtIndex:index];
        }
    }
}

-(void)removeAllJs
{
    WKUserContentController * wkUController = self.configuration.userContentController;
    @synchronized (self)
    {
        for (NSString * fn in jsNameList)
        {
            [wkUController removeScriptMessageHandlerForName:fn];
        }
        [jsNameList removeAllObjects];
    }
}

#pragma mask ---------- cookie
-(NSString *)getCurrentCookieWithDomain:(NSString *)domain
{
    NSHTTPCookieStorage * cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableString * cookieString = [[NSMutableString alloc] init];
    for (NSHTTPCookie * cookie in [cookieJar cookies])
    {
        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
    }
    //删除最后一个“;”
    if ([cookieString hasSuffix:@";"])
    {
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
    }
    return cookieString;
}

//解决 页面内跳转（a标签等）还是取不到cookie的问题
-(void)autoSetCookie
{
    //取出cookie
    NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //js函数
    NSString * jsStr =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }\
    function getCookie(name)\
    {\
    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
    if(arr != null) return unescape(arr[2]); return null;\
    }\
    function delCookie(name)\
    {\
    var exp = new Date();\
    exp.setTime(exp.getTime() - 1);\
    var cval=getCookie(name);\
    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
    }";
    
    //拼凑js字符串
    NSMutableString * JSCookieString = jsStr.mutableCopy;
    for (NSHTTPCookie * cookie in cookieStorage.cookies) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
        [JSCookieString appendString:excuteJSString];
    }
    //执行js
    [self evaluateJavaScript:JSCookieString completionHandler:nil];
}

-(void)clearCache
{
    if (@available(iOS 9.0, *)) {
        NSSet * types = [NSSet setWithArray:@[WKWebsiteDataTypeDiskCache,
                                              WKWebsiteDataTypeMemoryCache]];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:types modifiedSince:[NSDate dateWithTimeIntervalSince1970:0] completionHandler:^{}];
    } else {
        // Fallback on earlier versions
        NSString * path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        [[NSFileManager defaultManager] removeItemAtPath:[path stringByAppendingString:@"/Cookies"] error:nil];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    loadingView.frame = CGRectMake((self.width - 50) / 2, (self.height - 50) / 2, 50, 50);
}

#pragma mark -- WKNavigationDelegate
//决定是否允许或取消导航, 在发送请求之前，决定是否跳转
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString * scheme = navigationAction.request.URL.absoluteString;
    if ([self.webDelegate respondsToSelector:@selector(webView:shouldStartLoadWithUrl:webViewType:)])
    {
        decisionHandler([self.webDelegate webView:self shouldStartLoadWithUrl:navigationAction.request.URL webViewType:WEB_TYPE_WK] ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel);
        return;
    }else if (![scheme hasPrefix:@"http"])//不是http开头
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if (!loadingView.isAnimating)
    {
        [loadingView startAnimating];
    }
    if ([self.webDelegate respondsToSelector:@selector(webView:didStartLoadWithWebViewType:)])
    {
        [self.webDelegate webView:self didStartLoadWithWebViewType:WEB_TYPE_WK];
    }
}
    
// 页面加载失败时调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [loadingView stopAnimating];
    if ([error code] != NSURLErrorCancelled)
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html"];
        NSURL * url = [NSURL fileURLWithPath:path];
        NSURLRequest * request = [NSURLRequest requestWithURL:url] ;
        [webView loadRequest:request];
    }
    if ([self.webDelegate respondsToSelector:@selector(webView:didFailLoadWithError:webViewType:)])
    {
        [self.webDelegate webView:self didFailLoadWithError:error webViewType:WEB_TYPE_WK];
    }
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self autoSetCookie];
    [loadingView stopAnimating];
    //self.isWebLoadErr = [webView.request.URL.absoluteString hasSuffix:@"error.html"];
    if ([self.webDelegate respondsToSelector:@selector(webView:didFinishLoadWithWebViewType:)])
    {
        [self.webDelegate webView:self didFinishLoadWithWebViewType:WEB_TYPE_WK];
    }
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [self reloadEx];
}

#pragma mark -- WKUIDelegate ----------------------

-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:webView.title
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action)
    {
        completionHandler();
    }];
    [ac addAction:cancelAction];
    [[BaseAppVC getCurrVC] presentViewController:ac animated:YES completion:NULL];
}

-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:webView.title
                                                                message:message
                                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action)
    {
        completionHandler(true);
    }];
    [ac addAction:confirmAction];

    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action)
    {
        completionHandler(false);
    }];
    [ac addAction:cancelAction];
    [[BaseAppVC getCurrVC] presentViewController:ac animated:YES completion:NULL];
}

-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler
{
    UIAlertController * ac = [UIAlertController alertControllerWithTitle:webView.title
                                                                message:prompt
                                                         preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action)
    {
        completionHandler(false);
    }];
    [ac addAction:cancelAction];

    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action)
    {
        completionHandler(ac.textFields.firstObject.text);
    }];
    [ac addAction:confirmAction];
    [[BaseAppVC getCurrVC] presentViewController:ac animated:YES completion:NULL];
}

#pragma mark -- WKScriptMessageHandler js事件回调 ----------------------
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSArray * ps = [message.body componentsSeparatedByString:@"!"];
    if ([message.name isEqualToString:@"reload"])
    {
        if (self.isWebLoadErr)
        {
            [self reloadEx];
        }else
        {
            [self reload];
        }
    }else
    {
        [self.jsDelegate procJsCallWithFunName:message.name params:ps];
    }
}

@end
