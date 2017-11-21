//
//  AppViewController.m
//  cjcs
//
//  Created by liu on 2017/7/31.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "BaseAppVC.h"
#import "toolMacro.h"
#import <SPAlertController.h>
#import "NSObject+NSObjectHelper.h"

@interface BaseAppVC()

@end

@implementation BaseAppVC

-(BOOL)onInitViewTime:(NSUInteger)time
{
    if (time == INIT_TIME_LOAD_VIEW)
    {
        [self darkStatusBar];
        [self setupRootLayout];
        [self initUI];
        return YES;
    }
    return NO;
}

-(void)setupRootLayout
{
    self.rootLayout = ONEW(MyRelativeLayout);
    self.rootLayout.insetsPaddingFromSafeArea = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.rootLayout.myWidth = SCREEN_WIDTH;
    self.rootLayout.myVertMargin = 0;
    self.rootLayout.backgroundColor = [self getRootBgColor];
    self.view = self.contentLayout = self.rootLayout;
}

-(void)setupSVContentLayout
{
    UIScrollView * sv = ONEW(UIScrollView);
    if (@available(iOS 11.0, *))
    {
        sv.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
    }else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    sv.myHorzMargin = 0;
    if (self.rootLayout.subviews.count > 0)
    {
        sv.topPos.equalTo(self.rootLayout.subviews.lastObject.bottomPos);
    }else
    {
        sv.topPos.equalTo(self.rootLayout);
    }
    sv.backgroundColor = [self getContentBgColor];
    sv.bottomPos.equalTo(self.rootLayout);
    [self.rootLayout addSubview:sv];
    
    MyLinearLayout * llVert = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    llVert.backgroundColor = sv.backgroundColor;
    llVert.myHorzMargin = 0;
    llVert.heightSize.lBound(sv.heightSize, 1, 1);
    [sv addSubview:llVert];
    self.contentLayout = llVert;
}

-(void)setupVertContentLayout
{
    MyLinearLayout * llVert = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    llVert.backgroundColor = [self getContentBgColor];
    llVert.myHorzMargin = 0;
    if (self.rootLayout.subviews.count > 0)
    {
        llVert.topPos.equalTo(self.rootLayout.subviews.lastObject.bottomPos);
    }else
    {
        llVert.topPos.equalTo(self.rootLayout);
    }
    llVert.bottomPos.equalTo(self.rootLayout);
    [self.rootLayout addSubview:llVert];
    self.contentLayout = llVert;
}

-(UIColor *)getRootBgColor
{
    return [UIColor whiteColor];
}

-(UIColor *)getContentBgColor
{
    return [UIColor whiteColor];
}

-(void)initUI{}

-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actNames:(NSArray<NSString *> *)actNames redActIndex:(NSInteger)rai clickAction:(void(^)(NSInteger index))clickAction
{
    SPAlertController * spac = [SPAlertController alertControllerWithTitle:title message:msg preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];
    SPAlertAction * spAct;
    for (NSInteger i = 0;i < actNames.count;i++)
    {
        spAct = [SPAlertAction actionWithTitle:actNames[i] style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action)
                 {
                     [self performUIAsync:^{
                         clickAction(i);
                     } time:0.1];
                 }];
        spAct.titleColor = i == rai ? [UIColor redColor] : [UIColor blackColor];
        [spac addAction:spAct];
    }
    [self presentViewController:spac animated:YES completion:nil];
}

-(NSString *)getTFTextWithViewTag:(NSInteger)tag
{
    return ((UITextField *)[self.contentLayout viewWithTag:tag]).text;
}

-(void)setTFTextWithViewTag:(NSInteger)tag text:(NSString *)text
{
    ((UITextField *)[self.contentLayout viewWithTag:tag]).text = text;
}

-(NSString *)getLabTextWithViewTag:(NSInteger)tag
{
    return ((UILabel *)[self.contentLayout viewWithTag:tag]).text;
}

-(void)setLabTextWithViewTag:(NSInteger)tag text:(NSString *)text
{
    ((UILabel *)[self.contentLayout viewWithTag:tag]).text = text;
}

@end
