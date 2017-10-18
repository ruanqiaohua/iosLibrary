//
//  UIViewController+ViewControllerHelper.m
//  lightup
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "UIViewController+ViewControllerHelper.h"

@implementation UIViewController (ViewControllerHelper)

-(CGFloat) top
{
    return self.view.frame.origin.y;
}

-(CGFloat) left
{
    return self.view.frame.origin.x;
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
    return self.view.frame.size.width;
}

-(CGFloat) height
{
    return self.view.frame.size.height;
}

-(UIViewController *)getUIViewByStoryId:(NSString *)sid
{
    return (UIViewController *)[self.storyboard instantiateViewControllerWithIdentifier:sid];
}

@end
