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

@end
