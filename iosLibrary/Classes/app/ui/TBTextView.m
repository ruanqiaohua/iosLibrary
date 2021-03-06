//
//  RLTopBottomView.m
//  iosLibrary
//
//  Created by liu on 2017/12/15.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "TBTextView.h"

@implementation TBTextView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initView];
    }
    return self;
}

-(void)initView
{
    _labTop = [[UILabel alloc] init];
    _labTop.myCenterX = 0;
    _labTop.wrapContentSize = YES;
    _labTop.numberOfLines = 1;
    [self addSubview:_labTop];
    //
    _labBottom = [[UILabel alloc] init];
    _labBottom.myCenterX = 0;
    _labBottom.wrapContentSize = YES;
    _labBottom.numberOfLines = 1;
    [self addSubview:_labBottom];
}

-(instancetype)initTopFont:(UIFont *)tf topTextColor:(UIColor *)ttc bottomFont:(UIFont *)bf bottomTextColor:(UIColor *)btc space:(CGFloat)space
{
    self = [super init];
    if (self)
    {
        [self initView];
        [self setTopFont:tf textColor:ttc];
        [self setBottomFont:bf textColor:btc];
        [self setSpace:space];
    }
    return self;
}

-(void)setSpace:(CGFloat)space
{
    _labTop.centerYPos.equalTo(@[_labBottom.centerYPos.offset(space)]);
}

-(void)setTopFont:(UIFont *)font textColor:(UIColor *)tc
{
    _labTop.textColor = tc;
    _labTop.font = font;
}

-(void)setBottomFont:(UIFont *)font textColor:(UIColor *)tc
{
    _labBottom.textColor = tc;
    _labBottom.font = font;
}

-(void)setTopValue:(NSString *)tv bottomValue:(NSString *)bv
{
    if (tv.length > 0) _labTop.text = tv;
    if (bv.length > 0) _labBottom.text = bv;
}

@end
