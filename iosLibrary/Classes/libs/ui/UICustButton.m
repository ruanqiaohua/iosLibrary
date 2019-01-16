//
//  UICustButton.m
//  cjcr
//
//  Created by liu on 2017/1/23.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import "UICustButton.h"
#import "Utils.h"
#import "toolMacro.h"

@interface UICustButton()
{
    CGSize   contentSize;
    CGSize   titleSize;
    CGSize   imgSize;
    int      titleImageSpace;
}
@end

@implementation UICustButton

-(void)setImage:(UIImage *)image imgSize:(CGSize)is withTitle:(NSString *)title titleColor:(UIColor *)tc withFont:(UIFont *)font titleImageSpace:(int)tis
{
    titleImageSpace = tis;
    imgSize = is;

    titleSize = [Utils calSizeWithText:title font:font maxSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    titleSize = CGSizeMake(titleSize.width, titleSize.height);

    contentSize = CGSizeMake(MAX(imgSize.width, titleSize.width), imgSize.height + titleSize.height + tis);

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = font;
    self.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self setImage:image forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:tc forState:UIControlStateNormal];
}

-(void)setImage:(UIImage *)image withTitle:(NSString *)title titleColor:(UIColor *)tc withFont:(UIFont *)font titleImageSpace:(int)tis
{
    [self setImage:image imgSize:PTTO6SIZE(image.size) withTitle:title titleColor:tc withFont:font titleImageSpace:tis];
}

-(void)setImage:(UIImage *)image pixelSize:(BOOL)isPS withTitle:(NSString *)title titleColor:(UIColor *)tc withFont:(UIFont *)font titleImageSpace:(int)tis
{
    [self setImage:image imgSize:isPS ? PXTO6SIZE(image.size) : PTTO6SIZE(image.size) withTitle:title titleColor:tc withFont:font titleImageSpace:tis];
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    contentRect = CGRectMake((contentSize.width - titleSize.width) / 2, imgSize.height + titleImageSpace, titleSize.width, titleSize.height);
    return contentRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    contentRect = CGRectMake((contentSize.width - imgSize.width) / 2, 0, imgSize.width, imgSize.height);
    return contentRect;
}

- (CGRect)contentRectForBounds:(CGRect)bounds
{
    bounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
    return bounds;
}

@end
