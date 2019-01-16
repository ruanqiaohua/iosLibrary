//
//  UIView+Toast.m
//  iosLibrary
//
//  Created by liu on 2017/10/26.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "UIView+Toast.h"
#import "UIView+UIViewHelper.h"
#import "NSObject+NSObjectHelper.h"
#import "toolMacro.h"
#import <MyLayout.h>

const double TOAST_DURATION = 1.5;
const CGFloat YPOS_PER = 0.75;

@implementation UIView (Toast)

-(void) toast:(NSString *)toast
{
    [self toast:toast duration:TOAST_DURATION];
}

-(void) toast:(NSString *)toast duration:(NSTimeInterval)duration
{
    [self toast:toast duration:TOAST_DURATION yPosPer:YPOS_PER];
}

-(void) toast:(NSString *)toast duration:(NSTimeInterval)duration yPosPer:(CGFloat)per
{
    MyRelativeLayout * rl = [[MyRelativeLayout alloc] init];
    rl.layer.cornerRadius = 10;
    rl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];

    UILabel * lab = [[UILabel alloc] init];
    lab.text = toast;
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [lab sizeToFit];
    [rl addSubview:lab];
    lab.myCenterX = 0;
    lab.myCenterY = 0;

    rl.myTop = self.height * per - lab.height - 10;
    rl.myWidth = lab.width + 20;
    rl.myHeight = lab.height + 10;
    rl.myCenterX = 0;
    [self addSubview:rl];
    //
    rl.alpha = 0.0;

    WEAKOBJ(rl);
    [UIView animateWithDuration:0.5 animations:^{
        weak_rl.alpha = 1;
    } completion:^(BOOL finished)
    {
        [self performUIAsync:^{

            [UIView animateWithDuration:0.5 animations:^{
                weak_rl.alpha = 0;
            } completion:^(BOOL finished) {
                [weak_rl removeFromSuperview];
            }];
        } sec:duration];
    }];
}

@end
