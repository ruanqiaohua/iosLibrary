//
//  ImgTxtBtn.m
//  iosLibrary
//
//  Created by liu on 2018/9/26.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "ImgTxtBtn.h"
#import "toolMacro.h"
#import "category_inc.h"

@interface ImgTxtBtn()
{
    NSString    * icon;
    NSString    * selIcon;
    //
    UIColor     * txtColor;
    UIColor     * txtSelColor;
}
@end

@implementation ImgTxtBtn

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _img = ONEW(UIImageView);
        _text = ONEW(UILabel);
        _text.wrapContentSize = YES;
        [self addSubview:_img];
        [self addSubview:_text];
    }
    return self;
}

-(void)setImgStr:(NSString *)imgStr selImgStr:(NSString *)selImgStr text:(NSString *)txt font:(UIFont *)font txtColor:(UIColor *)tc txtSelColor:(UIColor *)tsc
{
    icon = imgStr;
    selIcon = selImgStr;
    txtColor = tc;
    txtSelColor = tsc;
    if (imgStr.length > 0)
    {
        _img.image = OIMG_STR(imgStr);
        _img.mySize = PTTO6SIZE(_img.image.size);
    }else _img.mySize = CGSizeZero;

    _text.text = txt;
    _text.textColor = tc;
    _text.font = font;
}

-(void)setTopImageStr:(NSString *)imgStr topSelImgStr:(NSString *)selImgStr bottomText:(NSString *)txt font:(UIFont *)font txtColor:(UIColor *)tc txtSelColor:(UIColor *)tsc space:(CGFloat)space
{
    [self setImgStr:imgStr selImgStr:selImgStr text:txt font:font txtColor:tc txtSelColor:tsc];
    //
    _img.myCenterX = 0;
    _text.myCenterX = 0;
    _img.centerYPos.equalTo(@[_text.centerYPos.offset(space)]);
}

-(void)setLeftImageStr:(NSString *)imgStr leftSelImgStr:(NSString *)selImgStr bottomText:(NSString *)txt font:(UIFont *)font txtColor:(UIColor *)tc txtSelColor:(UIColor *)tsc space:(CGFloat)space
{
    [self setImgStr:imgStr selImgStr:selImgStr text:txt font:font txtColor:tc txtSelColor:tsc];
    //
    _img.myCenterY = 0;
    _text.myCenterY = 0;
    _img.centerXPos.equalTo(@[_text.centerXPos.offset(space)]);
}

-(void)setRightImageStr:(NSString *)imgStr rightSelImgStr:(NSString *)selImgStr bottomText:(NSString *)txt font:(UIFont *)font txtColor:(UIColor *)tc txtSelColor:(UIColor *)tsc space:(CGFloat)space
{
    [self setImgStr:imgStr selImgStr:selImgStr text:txt font:font txtColor:tc txtSelColor:tsc];
    _img.myCenterY = 0;
    _text.myCenterY = 0;
    _text.centerXPos.equalTo(@[_img.centerXPos.offset(space)]);
}

-(void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (_isSelect)
    {
        if (selIcon.length > 0)
        {
            _img.image = OIMG_STR(selIcon);
        }
        if (txtSelColor)
        {
            _text.textColor = txtSelColor;
        }
    }else
    {
        if (icon.length > 0)
        {
            _img.image = OIMG_STR(icon);
        }
        if (txtColor)
        {
            _text.textColor = txtColor;
        }
    }
}

@end
