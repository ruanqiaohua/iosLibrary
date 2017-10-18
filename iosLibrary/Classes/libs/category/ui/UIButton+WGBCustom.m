//
//  UIButton+WGBCustom.m
//  自定义Button
//
//  Created by Wangguibin on 16/4/11.
//  Copyright © 2016年 王贵彬. All rights reserved.
//
#import "UIButton+WGBCustom.h"

@implementation UIButton (WGBCustom)

-(void)setImage:(nullable UIImage *)image withTitle:(NSString *)title forState:(UIControlState)state
{
//    image = [ImageLoader scaleImage:image imgWidth:CAL_POINT_6SW(image.size.width) imgHeight:CAL_POINT_6SW(image.size.height)];
    [self setImage:image forState:state];
    [self setTitle:title forState:state];
}

-(void)setTitleColor:(UIColor *)tc titleFont:(UIFont *)font forState:(UIControlState)state
{
    [self setTitleColor:tc forState:state];
    self.titleLabel.font = font;
}

/**  标题在上  */
- (void)titleOverTheImageTopWithSpace:(CGFloat)space
{
    [self judgeTheTitleInImageTop:YES space:space];
}

/**  标题在下  */
-(void)titleBelowTheImageWithSpace:(CGFloat)space
{
    [self judgeTheTitleInImageTop:NO space:space];
}

/**  判断标题是不是在上   */
- (void)judgeTheTitleInImageTop:(BOOL)isTop space:(float)space
{
    [self resetEdgeInsets];
    [self setNeedsLayout];
    [self layoutIfNeeded];
//    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    if (self.currentImage)
//    {
//        CGSize imageSize = CGSizeMake(CAL_POINT_6SW(self.currentImage.size.width), CAL_POINT_6SW(self.currentImage.size.height));
//        self.imageView.frame = CGRectMake(self.imageView.left, self.imageView.tag, imageSize.width, imageSize.height);
//    }
    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGSize titleSize = [self titleRectForContentRect:contentRect].size;
    CGSize imageSize = self.currentImage.size;
    
    float halfWidth = (titleSize.width + imageSize.width)/2;
    float halfHeight = (titleSize.height + imageSize.height)/2;

    float topInset = MIN(halfHeight, titleSize.height);
    float leftInset = (titleSize.width - imageSize.width)>0?(titleSize.width - imageSize.width)/2:0;
    float bottomInset = (titleSize.height - imageSize.height)>0?(titleSize.height - imageSize.height)/2:0;
    float rightInset = MIN(halfWidth, titleSize.width);

    if (isTop) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(-titleSize.height-space, - halfWidth, imageSize.height+space, halfWidth)];
        [self setContentEdgeInsets:UIEdgeInsetsMake(topInset+space, leftInset, -bottomInset, -rightInset)];
    } else {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height+space, - halfWidth, -titleSize.height-space, halfWidth)];
        [self setContentEdgeInsets:UIEdgeInsetsMake(-bottomInset, leftInset, topInset+space, -rightInset)];
    }
}

/**  图片在左  系统默认的样式  只需提供修改内边距的接口*/
-(void)imageOnTheTitleLeftWithSpace:(CGFloat)space{
    [self resetEdgeInsets];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, -space)];
    [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
}

/**  图片再右  */
- (void)imageOnTheTitleRightWithSpace:(CGFloat)space
{
    [self resetEdgeInsets];
    [self setNeedsLayout];
    [self layoutIfNeeded];

    CGRect contentRect = [self contentRectForBounds:self.bounds];
    CGSize titleSize = [self titleRectForContentRect:contentRect].size;
    CGSize imageSize = [self imageRectForContentRect:contentRect].size;

    [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, space)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleSize.width+space, 0, -titleSize.width - space)];
}

//重置内边距
- (void)resetEdgeInsets
{
    [self setContentEdgeInsets:UIEdgeInsetsZero];
    [self setImageEdgeInsets:UIEdgeInsetsZero];
    [self setTitleEdgeInsets:UIEdgeInsetsZero];
}

-(void)setNormalTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

-(void)setNormalTitle:(NSString *)title textColor:(UIColor *)tc
{
    [self setTitle:title forState:UIControlStateNormal];
    if (tc)
    {
        [self setTitleColor:tc forState:UIControlStateNormal];
    }
}

-(void)setSelectTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateSelected];
}

-(void)setSelectTitle:(NSString *)title textColor:(UIColor *)tc
{
    [self setTitle:title forState:UIControlStateSelected];
    if (tc)
    {
        [self setTitleColor:tc forState:UIControlStateSelected];
    }
}

-(void)setTextSize:(CGFloat)textSize
{
    self.titleLabel.font = [UIFont systemFontOfSize:textSize];
}

-(CGFloat) textSize
{
    return self.titleLabel.font.pointSize;
}

-(void)setNormalBackImage:(UIImage *)img
{
    [self setBackgroundImage:img forState:UIControlStateNormal];
}

-(void)setSelectBackImge:(UIImage *)img
{
    [self setBackgroundImage:img forState:UIControlStateSelected];
}

-(void)setNormalImage:(UIImage *)img
{
    [self setImage:img forState:UIControlStateNormal];
}

-(void)setSelectImge:(UIImage *)img
{
    [self setImage:img forState:UIControlStateSelected];
}

@end
