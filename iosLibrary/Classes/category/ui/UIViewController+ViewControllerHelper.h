//
//  UIViewController+ViewControllerHelper.h
//  lightup
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ViewControllerHelper)

@property(assign,readonly,nonatomic) CGFloat top;
@property(assign,readonly,nonatomic) CGFloat left;
@property(assign,readonly,nonatomic) CGFloat right;
@property(assign,readonly,nonatomic) CGFloat bottom;
@property(assign,readonly,nonatomic) CGFloat width;
@property(assign,readonly,nonatomic) CGFloat height;

-(UIViewController *)getUIViewByStoryId:(NSString *)sid;

@end
