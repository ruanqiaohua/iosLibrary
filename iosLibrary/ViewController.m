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

@interface ViewController()//<TagDelegate>
{
    LWaveView * wave;
    TagLayout * view;
}
@end

@implementation ViewController

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    MyRelativeLayout * rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = [UIColor whiteColor];
    rootLayout.insetsPaddingFromSafeArea = ~UIRectEdgeBottom;  //默认情况下底部的安全区会和布局视图的底部padding进行叠加，当这样设置后底部安全区将不会叠加到底部的padding上去。您可以注释这句代码看看效果。
    self.view = rootLayout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel * lab = [UILabel createWithFont:[UIFont systemFontOfSize:100] textColor:[UIColor blackColor]];
    [lab setHtml:@"花羊羊领取了你的<font color = \"red\">红包</font>"];
    lab.myCenterX = lab.myCenterY = 0;
    lab.wrapContentSize = YES;
    [self.view addSubview:lab];

//    [NSURLProtocol registerClass:[WebViewPhotoCache class]];
//
//    self.view.backgroundColor = [UIColor cyanColor];
//    UIWebView * web = ONEW(UIWebView);
//    web.frame = self.view.frame;
//    web.scalesPageToFit = NO;
//    NSURL * baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
//    NSString *html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [web loadHTMLString:html baseURL:baseURL];
//    [self.view addSubview:web];

//    UIButton * btn = ONEW(UIButton);
//    [btn setNormalTitle:@"提示" textColor:[UIColor blackColor]];
//    [btn sizeToFit];
//    btn.bottomPos.equalTo(self.view);
//    btn.myCenterX = 0;
//    [self.view addSubview:btn];
//    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    view = [TagLayout new];
//
//    TagInfo * fi = [TagInfo new];
//    fi.name = @"文本1";
//
//    TagInfo * fi1 = [TagInfo new];
//    fi1.name = @"文本2";
//
//    TagStyle * fbs = [TagStyle new];
//    fbs.nlBgColor = [UIColor whiteColor];
//    fbs.nlBorderColor = nil;
//    fbs.nlTextColor = [UIColor blackColor];
//    fbs.nlTextFont = [UIFont systemFontOfSize:15];
//        //
//    fbs.selBgColor = nil;
//    fbs.selBorderColor = [UIColor purpleColor];
//    fbs.selTextColor = [UIColor purpleColor];
//        //
//    fbs.borderWidth = 1;
//    fbs.flagMinWidth = 100;
//    fbs.borderRadius = 3;
//
//
//    [self.view addSubview:view];
//
//    view.myTop = 60;
//    view.myLeft = 0;
//    view.widthSize.equalTo(self.view);
//    view.heightSize.equalTo(self.view);
//    [view addTags:@[fi, fi1] tagStyle:fbs];
//    view.delegate = self;
//    view.hidden = YES;
}

//-(void)btnClick:(id)sender
//{
//    view.hidden = NO;
//}
//
//-(void)clickTagInfo:(TagInfo *)ti
//{
//    view.hidden = YES;
//}

@end
