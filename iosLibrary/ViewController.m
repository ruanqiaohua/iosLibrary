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
#import "RLTopBottomView.h"

@interface ViewController()
{
    SngRowLayout    * srl;
}
@end

@implementation ViewController

-(void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    MyRelativeLayout * rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = [UIColor purpleColor];
    rootLayout.insetsPaddingFromSafeArea = ~UIRectEdgeBottom;  //默认情况下底部的安全区会和布局视图的底部padding进行叠加，当这样设置后底部安全区将不会叠加到底部的padding上去。您可以注释这句代码看看效果。
    self.view = rootLayout;
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    RLTopBottomView * tbv = ONEW(RLTopBottomView);
    tbv.myWidth = SCREEN_WIDTH / 3;
    tbv.myHeight = PXTO6SW(450);
    tbv.myTop = 64;
    tbv.backgroundColor = [UIColor whiteColor];
    [tbv setSpace:PXTO6SH(30)];
    [self.view addSubview:tbv];
    tbv.labTop.text = @"100";
    tbv.labBottom.text = @"测试";
}



@end
