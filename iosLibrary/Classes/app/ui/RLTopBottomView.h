//
//  RLTopBottomView.h
//  iosLibrary
//
//  Created by liu on 2017/12/15.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>

@interface RLTopBottomView : MyRelativeLayout

@property(strong, nonatomic, readonly) UILabel * labTop;
@property(strong, nonatomic, readonly) UILabel * labBottom;

-(void)setSpace:(CGFloat)space;
-(void)setTopFont:(UIFont *)font textColor:(UIColor *)tc;
-(void)setBottomFont:(UIFont *)font textColor:(UIColor *)tc;
-(void)setTopValue:(NSString *)tv bottomValue:(NSString *)bv;

@end
