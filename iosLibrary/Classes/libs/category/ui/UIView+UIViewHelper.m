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

-(void)addTapGestureSelector:(SEL)action target:(id)target
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

-(void)addShadowWithOpacity:(float)shadowOpacity
               shadowRadius:(CGFloat)shadowRadius
               cornerRadius:(CGFloat)cornerRadius
                      color:(UIColor *)color
{
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.frame = self.layer.frame;

    shadowLayer.shadowColor = color.CGColor;//shadowColor阴影颜色
    shadowLayer.shadowOffset = CGSizeMake(1, 1);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    shadowLayer.shadowOpacity = shadowOpacity;//0.8;//阴影透明度，默认0
    shadowLayer.shadowRadius = shadowRadius;//8;//阴影半径，默认3

        //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];

    float width = shadowLayer.bounds.size.width;
    float height = shadowLayer.bounds.size.height;
    float x = shadowLayer.bounds.origin.x;
    float y = shadowLayer.bounds.origin.y;

    CGPoint topLeft      = shadowLayer.bounds.origin;
    CGPoint topRight     = CGPointMake(x + width, y);
    CGPoint bottomRight  = CGPointMake(x + width, y + height);
    CGPoint bottomLeft   = CGPointMake(x, y + height);

    CGFloat offset = -1.f;
    [path moveToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];
    [path addArcWithCenter:CGPointMake(topLeft.x + cornerRadius, topLeft.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI endAngle:M_PI_2 * 3 clockwise:YES];
    [path addLineToPoint:CGPointMake(topRight.x - cornerRadius, topRight.y - offset)];
    [path addArcWithCenter:CGPointMake(topRight.x - cornerRadius, topRight.y + cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 * 3 endAngle:M_PI * 2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomRight.x + offset, bottomRight.y - cornerRadius)];
    [path addArcWithCenter:CGPointMake(bottomRight.x - cornerRadius, bottomRight.y - cornerRadius) radius:(cornerRadius + offset) startAngle:0 endAngle:M_PI_2 clockwise:YES];
    [path addLineToPoint:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y + offset)];
    [path addArcWithCenter:CGPointMake(bottomLeft.x + cornerRadius, bottomLeft.y - cornerRadius) radius:(cornerRadius + offset) startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(topLeft.x - offset, topLeft.y + cornerRadius)];

        //设置阴影路径
    shadowLayer.shadowPath = path.CGPath;

        //////// cornerRadius /////////
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;

    [self.superview.layer insertSublayer:shadowLayer below:self.layer];
}

@end
