//
//  KVDetailLayout.m
//  iosLibrary
//
//  Created by liu on 2017/11/17.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "SngRowLayout.h"
#import "toolMacro.h"

@interface SngRowLayout()
{

}
@end

@implementation SngRowLayout

-(void)initView
{
    _ivTitleLeft = ONEW(UIImageView);
    _ivTitleLeft.myCenterY = 0;
    [self addSubview:_ivTitleLeft];

    _labTitle = ONEW(UILabel);
    _labTitle.myCenterY = 0;
    _labTitle.wrapContentSize = YES;
    [self addSubview:_labTitle];

    _ivTitleRight = ONEW(UIImageView);
    _ivTitleRight.myCenterY = 0;
    [self addSubview:_ivTitleRight];
    //
    _ivValueLeft = ONEW(UIImageView);
    _ivValueLeft.myCenterY = 0;
    [self addSubview:_ivValueLeft];

    _labValue = ONEW(UILabel);
    _labValue.myCenterY = 0;
    _labValue.wrapContentSize = YES;
    [self addSubview:_labValue];

    _ivValueRight = ONEW(UIImageView);
    _ivValueRight.myCenterY = 0;
    [self addSubview:_ivValueRight];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initView];
        self.uiSpace = @[@0,@0,@0,@0,@0,@0];
    }
    return self;
}

-(void)reqLayout
{
    _ivTitleLeft.myLeft = [self.uiLeftSpace[0] floatValue];
    _labTitle.leftPos.equalTo(_ivTitleLeft.rightPos).offset([self.uiLeftSpace[1] floatValue]);
    _ivTitleRight.leftPos.equalTo(_labTitle.rightPos).offset([self.uiLeftSpace[2] floatValue]);
    //
    _ivValueRight.rightPos.equalTo(self).offset([self.uiRightSpace[2] floatValue]);
    _labValue.rightPos.equalTo(_ivValueRight.leftPos).offset([self.uiRightSpace[1] floatValue]);
    _ivValueLeft.rightPos.equalTo(_labValue.leftPos).offset([self.uiRightSpace[0] floatValue]);
}

-(void)reqFontChange
{
    self.labTitle.font = self.uiFont[0];
    if (self.uiFont.count > 1)
    {
        self.labValue.font = self.uiFont[1];
    }
}

-(void)reqTextColorChange
{
    self.labTitle.textColor = self.uiTextColor[0];
    self.labValue.textColor = self.uiTextColor[1];
}

-(void)setTitle:(NSString *)text leftImage:(UIImage *)lImg rightImage:(UIImage *)rImg
{
    if (lImg)
    {
        self.ivTitleLeft.image = lImg;
        self.ivTitleLeft.mySize = PTTO6SIZE(lImg.size);
    }else
    {
        self.ivTitleLeft.mySize = CGSizeZero;
    }

    self.labTitle.text = text;

    if (rImg)
    {
        self.ivTitleRight.image = rImg;
        self.ivTitleRight.mySize = PTTO6SIZE(rImg.size);
    }else
    {
        self.ivTitleRight.mySize = CGSizeZero;
    }
}

-(void)setValue:(NSString *)text leftImage:(UIImage *)lImg rightImage:(UIImage *)rImg
{
    if (lImg)
    {
        self.ivValueLeft.image = lImg;
        self.ivValueLeft.mySize = PTTO6SIZE(lImg.size);
    }else
    {
        self.ivValueLeft.mySize = CGSizeZero;
    }
    if (text.length > 0)
    {
        self.labValue.text = text;
    }
    if (rImg)
    {
        self.ivValueRight.image = rImg;
        self.ivValueRight.mySize = PTTO6SIZE(rImg.size);
    }else
    {
        self.ivValueRight.mySize = CGSizeZero;
    }
}

-(void)setTitle:(NSString *)text;
{
    self.labTitle.text = text;
    //[self.labTitle sizeToFit];
}

-(void)setValue:(NSString *)text
{
    self.labValue.text = text;
    //[self.labValue sizeToFit];
}

-(void)setValueLeftImage:(UIImage *)li rightImage:(UIImage *)ri
{
    if (li)
    {
        self.ivValueLeft.image = li;
        self.ivValueLeft.mySize = PTTO6SIZE(li.size);
    }
    if (ri)
    {
        self.ivValueRight.image = ri;
        self.ivValueRight.mySize = PTTO6SIZE(ri.size);
    }
}

-(void)addTopLineColor:(UIColor *)color height:(CGFloat)height
{
    UIView * line = ONEW(UIView);
    line.backgroundColor = color;
    line.myHeight = height;
    line.myHorzMargin = 0;
    [self addSubview:line];
}

-(void)addBottomLineColor:(UIColor *)color height:(CGFloat)height
{
    UIView * line = ONEW(UIView);
    line.backgroundColor = color;
    line.myHeight = height;
    line.myHorzMargin = 0;
    [self addSubview:line];
    line.bottomPos.equalTo(self);
}

@end
