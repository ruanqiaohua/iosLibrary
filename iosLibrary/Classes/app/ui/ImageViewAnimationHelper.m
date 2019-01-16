//
//  ImageViewAnimationHelper.m
//  UserApp
//
//  Created by liu on 2018/9/27.
//  Copyright © 2018年 ljh. All rights reserved.
//

#import "ImageViewAnimationHelper.h"
#import "objMacro.h"
#import "toolMacro.h"
#import <MyLayout.h>
@interface ImageViewAnimationHelper()

PropertyWeakObj(view, UIView);
PropertyFloat(lineWidth);
PropertyFloat(moveNum);
PropertyFloat(oldMoveNum);
PropertyFloat(distance);
PropertyFloat(fromXDelta);
PropertyFloat(toXDelta);
PropertyFloat(oldXDelta);
PropertyBOOL(isInit);

@end

@implementation ImageViewAnimationHelper

-(void)setView:(UIView *)view moveNum:(NSUInteger)mn lineWidth:(int)lw
{
    self.view = view;
    self.lineWidth = lw;
    self.moveNum = mn;
    //
    float surplus = SCREEN_WIDTH - (lw * mn);
    self.distance = surplus / (mn * 2);
    view.myWidth = lw;
    [self startMoveNum:0];
}

-(void)startMoveNum:(NSUInteger)mn
{
    if (mn > self.moveNum)return;
    if ((self.oldMoveNum < mn) | (self.oldMoveNum == 0 && self.isInit) | (self.moveNum == 0))
    {//右移、初始化
        self.isInit = false;
        self.fromXDelta = self.oldXDelta;
        self.toXDelta = self.distance * (2 * mn) + self.lineWidth * mn + self.distance;
        self.oldXDelta = self.toXDelta;
    }else//左移
    {
        self.fromXDelta = self.oldXDelta;
        self.toXDelta = self.distance * (2 * mn) + self.lineWidth * mn + self.distance;
        self.oldXDelta = self.toXDelta;
    }
    self.oldMoveNum = mn;
    self.view.myLeft = self.toXDelta;
    [((MyBaseLayout *)self.view.superview) layoutAnimationWithDuration:0.3];
}

@end
