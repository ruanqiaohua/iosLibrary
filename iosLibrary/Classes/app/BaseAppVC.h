//
//  AppViewController.h
//  cjcs
//
//  Created by liu on 2017/7/31.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "BaseViewController.h"
#import <MyLayout.h>
#import "UISkinConfig.h"

@interface BaseAppVC : BaseViewController

@property(strong, nonatomic) MyBaseLayout   * rootLayout;
@property(strong, nonatomic) MyBaseLayout   * contentLayout;
@property(readonly, nonatomic) UISkinConfig * skinCfg;

+(UIView *)addHLineColor:(UIColor *)lc lrSpace:(CGFloat)space toView:(UIView *)view;
+(UIView *)addVLineColor:(UIColor *)lc tbSpace:(CGFloat)space toView:(UIView *)view;
//-----------------------------------------------------
-(void)setupConfig;
-(void)setupRootLayout;
-(void)setupSVContentLayout;
-(void)setupVertContentLayout;
-(void)initUI;
-(UISkinConfig *)getSkinConfig;

@end
