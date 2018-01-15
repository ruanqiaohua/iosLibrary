//
//  AppViewController.m
//  cjcs
//
//  Created by liu on 2017/7/31.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "BaseAppVC.h"
#import "toolMacro.h"
#import "NSObject+NSObjectHelper.h"

@interface BaseAppVC()

@end

@implementation BaseAppVC

+(UIView *)addHLineColor:(UIColor *)lc lrSpace:(CGFloat)space toView:(UIView *)view
{
    UIView * v = ONEW(UIView);
    v.backgroundColor = lc;
    v.myLeft = v.myRight = space;
    v.myHeight = 1;
    [view addSubview:v];
    return v;
}

+(UIView *)addVLineColor:(UIColor *)lc tbSpace:(CGFloat)space toView:(UIView *)view
{
    UIView * v = ONEW(UIView);
    v.backgroundColor = lc;
    v.myTop = v.myBottom = space;
    v.myWidth = 1;
    [view addSubview:v];
    return v;
}

#pragma ----------------------------------------
-(BOOL)onInitViewTime:(NSUInteger)time
{
    if (time == INIT_TIME_LOAD_VIEW)
    {
        [self setupConfig];
        [self setupRootLayout];
        [self initUI];
        return YES;
    }
    return NO;
}

-(void)setupConfig
{
    _skinCfg = [self getSkinConfig];
}

-(UISkinConfig *)getSkinConfig
{
    return [UISkinConfig createDefault];
}

-(void)setupRootLayout
{
    self.rootLayout = ONEW(MyRelativeLayout);
    self.rootLayout.insetsPaddingFromSafeArea = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    self.rootLayout.myWidth = SCREEN_WIDTH;
    self.rootLayout.myVertMargin = 0;
    self.rootLayout.backgroundColor = self.skinCfg.rootBgColor;
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
    sv.backgroundColor = self.skinCfg.contentBgColor;
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
    llVert.backgroundColor = self.skinCfg.contentBgColor;
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

-(void)initUI{}

@end
