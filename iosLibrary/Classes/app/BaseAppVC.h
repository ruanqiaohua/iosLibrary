//
//  AppViewController.h
//  cjcs
//
//  Created by liu on 2017/7/31.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "BaseViewController.h"
#import "TitleViewEx.h"

@interface BaseAppVC : BaseViewController<TitleViewDelegate>

@property(strong, nonatomic) MyBaseLayout * rootLayout;
@property(strong, nonatomic) MyBaseLayout * contentLayout;
@property(strong, nonatomic) TitleViewEx  * titleView;

-(void)setupRootLayout;
-(void)setupSVContentLayout;
-(void)setupVertContentLayout;
-(void)initUI;
-(UIColor *)getRootBgColor;
-(UIColor *)getContentBgColor;

@end
