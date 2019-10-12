//
//  ViewController.m
//  iosLibrary
//
//  Created by liu on 2017/7/27.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "ViewController.h"
#import "LWaveView.h"
#import "toolMacro.h"
#import "UIViewController+ViewControllerHelper.h"
#import <MyLayout.h>
#import "category_inc.h"
#import "WebViewPhotoCache.h"
#import "TagLayout.h"
#import "UILabel+Html.h"
#import "ContactsManager.h"
#import "SngRowLayout.h"
#import "SPAlertController.h"
#import "TBTextView.h"
#import "ScrollTabbar.h"
#import "ZFScanViewController.h"
#import "SRActionSheet.h"
#import "CameraManager.h"
#import "HttpUtils.h"
#import "LWebViewEx.h"

@interface ViewController()<CameraManagerDelegate>
{
    //'iosLibrary/Assets/*.{png,bundle,html,css,js}',
    LWebViewEx       * web;
}
@property (nonatomic, strong) WKWebView *  webView;
@end

@implementation ViewController

//-(void)loadView
//{
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    MyRelativeLayout * rootLayout = [MyRelativeLayout new];
//    rootLayout.backgroundColor = [UIColor whiteColor];
//    rootLayout.insetsPaddingFromSafeArea = ~UIRectEdgeBottom;  //默认情况下底部的安全区会和布局视图的底部padding进行叠加，当这样设置后底部安全区将不会叠加到底部的padding上去。您可以注释这句代码看看效果。
//    self.view = rootLayout;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    WKUserContentController *userController = [[WKUserContentController alloc] init];
//    configuration.userContentController = userController;
//    web = [[LWebViewEx alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:configuration];
//    [self.view addSubview:web];
//    [web loadUrl:@"http://www.baidu.com"];
    [self.view addSubview:self.webView];
    
}

- (WKWebView *)webView{
    
    if(_webView == nil){
        
        //创建网页配置对象
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
        //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
        config.mediaTypesRequiringUserActionForPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        config.allowsPictureInPictureMediaPlayback = YES;
        //设置请求的User-Agent信息中应用程序名称 iOS9后可用
        config.applicationNameForUserAgent = @"ChinaDailyForiPad";
        
        //自定义的WKScriptMessageHandler 是为了解决内存不释放的问题
//        WeakWebViewScriptMessageDelegate *weakScriptMessageDelegate = [[WeakWebViewScriptMessageDelegate alloc] initWithDelegate:self];
//        //这个类主要用来做native与JavaScript的交互管理
//        WKUserContentController * wkUController = [[WKUserContentController alloc] init];
//        //注册一个name为jsToOcNoPrams的js方法 设置处理接收JS方法的对象
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcNoPrams"];
//        [wkUController addScriptMessageHandler:weakScriptMessageDelegate  name:@"jsToOcWithPrams"];
//
//        config.userContentController = wkUController;
        
        //以下代码适配文本大小
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        //用于进行JavaScript注入
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [config.userContentController addUserScript:wkUScript];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:config];
        // UI代理
        //_webView.UIDelegate = self;
        // 导航代理
        //_webView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _webView.allowsBackForwardNavigationGestures = YES;
        //可返回的页面列表, 存储已打开过的网页
       WKBackForwardList * backForwardList = [_webView backForwardList];
        
        //        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chinadaily.com.cn"]];
        //        [request addValue:[self readCurrentCookieWithDomain:@"http://www.chinadaily.com.cn"] forHTTPHeaderField:@"Cookie"];
        //        [_webView loadRequest:request];
        
        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"JStoOC.html" ofType:nil];
//        NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//        [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        _webView.backgroundColor = [UIColor blueColor];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
        
    }
    return _webView;
}

-(void)testBut
{
    UIButton * btn = ONEW(UIButton);
    [btn setNormalTitle:@"ttt"];
    [btn setNormalTitle:@"ttt" textColor:[UIColor blackColor]];
    btn.frame = CGRectMake(0, 0, 200, 200);
    [self.view addSubview:btn];
}

-(void)upClick:(id)sender
{
    [CameraManager sharedInst].delegate = self;
    [CameraManager sharedInst].maxImageWHPX = 500;
    [[CameraManager sharedInst] openPhotoLibraryWithVC:self];
}

+(NSString *)imageBase64WithDataURL:(UIImage *)image
{
    NSData * imageData = nil;
    NSString * mimeType = nil;//图片要压缩的比例，此处100根据需求，自行设置
    CGFloat x = 100 / image.size.height;
    if (x > 1)
    {
        x = 1.0;
    }
    imageData = UIImageJPEGRepresentation(image,x);
    mimeType = @"image/jpeg";
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,[imageData base64EncodedStringWithOptions:0]];
}

-(void)onCMImage:(UIImage *)image
{
//    NSString * b64 = [image imageToBase64];
//    [API postUrl:@"http://115.29.64.206:8763/dguser/photo/uploadPhotoBaseFile" param:@{@"content":b64} onResult:^(BOOL isOK, NSString *msg, NSDictionary *dict)
//     {
//         NSLog(@"isOk = %d, msg = %@ val = %@",isOK,msg,dict);
//     }];
}

@end
