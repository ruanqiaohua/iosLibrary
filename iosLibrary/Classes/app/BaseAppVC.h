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
-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actNames:(NSArray<NSString *> *)actNames redActIndex:(NSInteger)rai clickAction:(void(^)(NSInteger index))clickAction;
-(NSString *)getTFTextWithViewTag:(NSInteger)tag;
-(void)setTFTextWithViewTag:(NSInteger)tag text:(NSString *)text;
-(NSString *)getLabTextWithViewTag:(NSInteger)tag ;
-(void)setLabTextWithViewTag:(NSInteger)tag text:(NSString *)text;
@end
