//
//  AbsLayout.m
//  iosLibrary
//
//  Created by liu on 2017/11/17.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "AbsLayout.h"
#import "toolMacro.h"

@implementation AbsLayout

-(void)addBottomLineWithColor:(UIColor *)color height:(CGFloat)height lrSpace:(CGFloat)space
{
    UIView * line = ONEW(UIView);
    line.backgroundColor = color;

    line.myHeight = height;
    line.myLeft = line.myRight = space;
    [self addSubview:line];
}

-(void)setUiLeftSpace:(NSArray<NSNumber *> *)uiLeftSpace
{
    _uiLeftSpace = uiLeftSpace;
    _uiSpace = nil;
    [self reqLayout];
}

-(void)setUiRightSpace:(NSArray<NSNumber *> *)uiRightSpace
{
    _uiRightSpace = uiRightSpace;
    _uiSpace = nil;
    [self reqLayout];
}

-(void)setUiSpace:(NSArray<NSNumber *> *)uiSpace
{
    _uiSpace = uiSpace;
    _uiLeftSpace = @[uiSpace[0],uiSpace[1],uiSpace[2]];
    _uiRightSpace = @[uiSpace[3],uiSpace[4],uiSpace[5]];
    [self reqLayout];
}

-(void)setUiFont:(NSArray<UIFont *> *)uiFont
{
    _uiFont = uiFont;
    [self reqFontChange];
}

-(void)setUiTextColor:(NSArray<UIColor *> *)uiTextColor
{
    _uiTextColor = uiTextColor;
    [self reqTextColorChange];
}

-(void)reqLayout{}
-(void)reqFontChange{}
-(void)reqTextColorChange{}

@end
