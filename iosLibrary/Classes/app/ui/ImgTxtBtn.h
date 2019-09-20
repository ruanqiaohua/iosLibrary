//
//  ImgTxtBtn.h
//  iosLibrary
//
//  Created by liu on 2018/9/26.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>

@interface ImgTxtBtn : MyRelativeLayout

@property(nonatomic, strong) UIImageView * img;
@property(nonatomic, strong) UILabel * text;
@property(nonatomic, assign) BOOL isSelect;
@property(nonatomic, strong) id tagObj;

-(void)setTopImageStr:(NSString *)imgStr topSelImgStr:(NSString *)selImgStr bottomText:(NSString *)txt font:(UIFont *)font txtColor:(UIColor *)tc txtSelColor:(UIColor *)tsc space:(CGFloat)space;

-(void)setLeftImageStr:(NSString *)imgStr leftSelImgStr:(NSString *)selImgStr bottomText:(NSString *)txt font:(UIFont *)font txtColor:(UIColor *)tc txtSelColor:(UIColor *)tsc space:(CGFloat)space;

-(void)setRightImageStr:(NSString *)imgStr rightSelImgStr:(NSString *)selImgStr bottomText:(NSString *)txt font:(UIFont *)font txtColor:(UIColor *)tc txtSelColor:(UIColor *)tsc space:(CGFloat)space;

-(void)showBadgeWithOffsetPoint:(CGPoint)point;
-(void)hiddenBadge;
-(void)showBadgeNumber:(NSInteger)number offsetPoint:(CGPoint)point;

@end
