//
//  MenuRow.m
//  yezhu
//
//  Created by liu on 2017/6/20.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "MenuRow.h"
#import "toolMacro.h"
#import "UILabel+Html.h"

@implementation MenuRow

- (instancetype)initImage:(UIImage *)img imgLeftSpace:(CGFloat)ils
                    imgTitleRight:(UIImage *)itrImage itrLeftSpace:(CGFloat)itrLS
                    title:(NSString *)title titleLeftSpace:(CGFloat)tls titleFont:(UIFont *)tf titleColor:(UIColor *)tc
                    value:(NSString *)value valueRightSpace:(CGFloat)vrs valueFont:(UIFont *)vf valueColor:(UIColor *)vc
               rightImage:(UIImage *)ri rightSpace:(CGFloat)rs
{
    self = [super initWithOrientation:MyOrientation_Horz];
    if (self)
    {
        if (img)
        {
            _ivImage = OIV_IMG(img);
            _ivImage.mySize = PTTO6SIZE(img.size);
        }else
        {
            _ivImage = ONEW(UIImageView);
            _ivImage.mySize = CGSizeMake(0, 0);
        }
        _ivImage.myLeft = ils;
        _ivImage.myCenterY = 0;
        [self addSubview:_ivImage];
        //
        _labTitle = [UILabel createWithFont:tf textColor:tc];
        _labTitle.wrapContentSize = YES;
        _labTitle.myCenterY = 0;
        _labTitle.myLeft = tls;
        _labTitle.text = title;
        [self addSubview:_labTitle];
        //
        if (itrImage)
        {
            _ivTitleRightImage = OIV_IMG(itrImage);
            _ivTitleRightImage.mySize = PTTO6SIZE(itrImage.size);
        }else
        {
            _ivTitleRightImage = ONEW(UIImageView);
            _ivTitleRightImage.mySize = CGSizeMake(0, 0);
        }
        _ivTitleRightImage.myLeft = itrLS;
        _ivTitleRightImage.myCenterY = 0;
        [self addSubview:_ivTitleRightImage];
        //
        if (value)
        {
            _labValue = [UILabel createWithFont:vf textColor:vc];
            _labValue.text = value;
        }else
        {
            _labValue = ONEW(UILabel);
        }
        _labValue.wrapContentSize = YES;
        _labValue.myCenterY = 0;
        _labValue.myLeft = 0.5;
        _labValue.myRight = vrs;
        [self addSubview:_labValue];
        //
        if (ri)
        {
            _rightArrow = OIV_IMG(ri);
            _rightArrow.mySize = PTTO6SIZE(ri.size);
        }else
        {
            _rightArrow = ONEW(UIImageView);
        }
        _rightArrow.myCenterY = 0;
        _rightArrow.myLeft = value ? 0 : 0.5;
        _rightArrow.myRight = rs;
        [self addSubview:_rightArrow];
    }
    return self;
}

- (instancetype)initImage:(UIImage *)img imgLeftSpace:(CGFloat)ils title:(NSString *)title titleLeftSpace:(CGFloat)tls titleFont:(UIFont *)font titleTextColor:(UIColor *)ttc
               rightImage:(UIImage *)ri rightSpace:(CGFloat)rs
{
    return [self initImage:img imgLeftSpace:ils imgTitleRight:nil itrLeftSpace:0  title:title titleLeftSpace:tls titleFont:font titleColor:ttc value:nil valueRightSpace:0 valueFont:nil valueColor:nil rightImage:ri rightSpace:rs];
}

- (instancetype)initImage:(UIImage *)img imgLeftSpace:(CGFloat)ils title:(NSString *)title titleLeftSpace:(CGFloat)tls titleTextSize:(CGFloat)tts titleTextColor:(UIColor *)ttc rightImage:(UIImage *)ri rightSpace:(CGFloat)rs
{
    return [self initImage:img imgLeftSpace:ils imgTitleRight:nil itrLeftSpace:0 title:title titleLeftSpace:tls titleFont:[UIFont systemFontOfSize:tts] titleColor:ttc value:nil valueRightSpace:0 valueFont:nil valueColor:nil rightImage:ri rightSpace:rs];
}

-(void)addTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}

-(void)setRightArrowImage:(UIImage *)img
{
    _rightArrow.image = img;
    _rightArrow.mySize = PTTO6SIZE(img.size);
}

@end
