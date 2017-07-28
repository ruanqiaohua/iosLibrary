//
//  TitleViewEx.h
//  cjcr
//
//  Created by liu on 2017/1/19.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MyLayout.h>

#define TITLE_ALIG_LEFT         0
#define TITLE_ALIG_MIDDLE       1

#define TITLE_BTN_LEF           0
#define TITLE_BTN_RIGHT         1
#define TITLE_BTN_ALL           2

#define TITLE_EXEC_TYPE_WEB     0
#define TITLE_EXEC_TYPE_PK      1
#define TITLE_EXEC_TYPE_JS      2
#define TITLE_EXEC_TYPE_BTN     3

@class TitleViewEx;

@protocol TitleViewDelegate <NSObject>

@optional

-(void)onTitleExitClick;
-(void)onTitleBtnClick:(TitleViewEx *)tve sender:(UIButton *)btn param:(NSDictionary *)param execType:(int)et;
-(void)onTitleClick;

@end

@interface TitleViewEx : MyRelativeLayout

@property(weak,nonatomic) id<TitleViewDelegate> delegate;
+(instancetype)createTitleView;

-(void)setTitle:(NSString *)title;
-(void)setTitle:(NSString *)title titleFont:(UIFont *)tf titleColor:(UIColor *)tc; //默认居中
-(void)setTitle:(NSString *)title titleFont:(UIFont *)tf titleColor:(UIColor *)tc titleAlignment:(int)ta;
-(void)setExitImgStr:(NSString *)eis;
//
-(void)addButton:(UIButton *)btn btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et;
-(void)addButtonWithText:(NSString *)text btnTextColor:(UIColor *)tc font:(UIFont *)font btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et;
-(void)addButtonWithImage:(NSString *)imgUrl btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et;
//
-(void)mdBtnImgUrl:(NSString *)imgUrl btnIndex:(int)index;
-(void)mdBtnText:(NSString *)text btnIndex:(int)index;
-(void)showBadgeBtnIndex:(int)index;
-(void)hiddenBadgeBtnIndex:(int)index;
//
-(void)setTitleViewBottomLineColor:(UIColor *)color lineHeight:(int)height;
//
-(void)clearTitleBtn:(int)btnLoc;

@end
