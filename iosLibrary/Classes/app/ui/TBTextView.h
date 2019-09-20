//
//  RLTopBottomView.h
//  iosLibrary
//
//  Created by liu on 2017/12/15.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>

@interface TBTextView : MyRelativeLayout

@property(strong, nonatomic, readonly) UILabel * labTop;
@property(strong, nonatomic, readonly) UILabel * labBottom;

-(instancetype)initTopFont:(UIFont *)tf topTextColor:(UIColor *)ttc bottomFont:(UIFont *)bf bottomTextColor:(UIColor *)btc space:(CGFloat)space;
-(void)setSpace:(CGFloat)space;
-(void)setTopFont:(UIFont *)font textColor:(UIColor *)tc;
-(void)setBottomFont:(UIFont *)font textColor:(UIColor *)tc;
-(void)setTopValue:(NSString *)tv bottomValue:(NSString *)bv;

@end
