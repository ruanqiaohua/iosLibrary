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

@interface ViewController()<CameraManagerDelegate>
{
    //'iosLibrary/Assets/*.{png,bundle,html,css,js}',
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
    UIButton * btn = ONEW(UIButton);
    [btn setNormalTitle:@"上传文件" textColor:[UIColor blackColor]];
    btn.titleLabel.font = SYS_FONT(39);
    btn.wrapContentSize = YES;
    [btn addTarget:self action:@selector(upClick:) forControlEvents:(UIControlEventTouchUpInside)];
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
