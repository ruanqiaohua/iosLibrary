//
//  MenuRow.h
//  yezhu
//
//  Created by liu on 2017/6/20.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>

@interface MenuRow : MyLinearLayout

@property(readonly, nonatomic) UIImageView * ivImage;
@property(readonly, nonatomic) UIImageView * ivTitleRightImage;
@property(readonly, nonatomic) UILabel * labTitle;
@property(readonly, nonatomic) UILabel * labValue;
@property(readonly, nonatomic) UIImageView * rightArrow;

- (instancetype)initImage:(UIImage *)img imgLeftSpace:(CGFloat)ils title:(NSString *)title titleLeftSpace:(CGFloat)tls titleTextSize:(CGFloat)tts titleTextColor:(UIColor *)ttc
               rightImage:(UIImage *)ri rightSpace:(CGFloat)rs;

- (instancetype)initImage:(UIImage *)img imgLeftSpace:(CGFloat)ils title:(NSString *)title titleLeftSpace:(CGFloat)tls titleFont:(UIFont *)font titleTextColor:(UIColor *)ttc
               rightImage:(UIImage *)ri rightSpace:(CGFloat)rs;

- (instancetype)initImage:(UIImage *)img imgLeftSpace:(CGFloat)ils
                    imgTitleRight:(UIImage *)img itrLeftSpace:(CGFloat)itrLS
                    title:(NSString *)title titleLeftSpace:(CGFloat)tls titleFont:(UIFont *)tf titleColor:(UIColor *)tc
                    value:(NSString *)value valueRightSpace:(CGFloat)vrs valueFont:(UIFont *)vf valueColor:(UIColor *)vc
               rightImage:(UIImage *)ri rightSpace:(CGFloat)rs;

-(void)addTarget:(id)target action:(SEL)action;
-(void)setRightArrowImage:(UIImage *)img;

@end
