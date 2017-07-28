//
//  UIView+UIViewHelper.m
//  lightup
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "UIView+UIViewHelper.h"

@implementation UIView (UIViewHelper)

-(CGFloat) top
{
    return self.frame.origin.y;
}

-(CGFloat) left
{
    return self.frame.origin.x;
}

-(CGFloat) right
{
    return self.left + self.width;
}


-(CGFloat) bottom
{
    return self.top + self.height;
}

-(CGFloat) width
{
    return self.frame.size.width;
}

-(CGFloat) height
{
    return self.frame.size.height;
}

-(CGFloat) radius
{
    return self.layer.cornerRadius;
}

-(void) setRadius:(CGFloat)radius
{
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.masksToBounds = YES;//离屏渲染，多时会降低帧数
    self.layer.cornerRadius = radius;
}

-(void)setBorderColor:(UIColor *)bc borderWidth:(CGFloat)bw
{
    self.layer.borderColor = [bc CGColor];
    self.layer.borderWidth = bw;
}

@end
