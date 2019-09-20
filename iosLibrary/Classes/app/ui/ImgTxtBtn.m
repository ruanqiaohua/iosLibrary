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
#import <WZLBadgeImport.h>
#import <UIImageView+WebCache.h>

@interface ImgTxtBtn()
{
    NSString    * icon;
    NSString    * selIcon;
    //
    UIColor     * txtColor;
    UIColor     * txtSelColor;
    //
    UIView      * badgeView;
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
        _text.wrapContentHeight = YES;
        _text.numberOfLines = 1;
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
        if ([imgStr hasPrefix:@"http"])
        {
            [_img sd_setImageWithURL:[NSURL URLWithString:imgStr]];
            WEAKOBJ(_img);
            [_img sd_setImageWithURL:[NSURL URLWithString:imgStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image)
                {
                    weak__img.image = image;
                    weak__img.mySize = PXTO6SIZE(image.size);
                }
            }];
            return;
        }
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
    _text.widthSize.equalTo(self);
    _text.textAlignment = NSTextAlignmentCenter;
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

-(void)showBadgeWithOffsetPoint:(CGPoint)point
{
    if (badgeView == nil)
    {
        badgeView = ONEW(UIView);
        badgeView.rightPos.equalTo(self).offset(point.x);
        badgeView.topPos.equalTo(self).offset(point.y);
        badgeView.mySize = CGSizeMake(10, 10);
        [self addSubview:badgeView];
    }
    [badgeView showBadge];
}

-(void)hiddenBadge
{
    [badgeView clearBadge];
}

-(void)showBadgeNumber:(NSInteger)number offsetPoint:(CGPoint)point
{
    
}

@end
