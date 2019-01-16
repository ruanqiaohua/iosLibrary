//
//  UISkinConfig.h
//  iosLibrary
//
//  Created by liu on 2018/1/11.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UISkinConfig : NSObject
//titleView
@property(strong, nonatomic) UIColor        * titleViewBgColor;
@property(strong, nonatomic) UIColor        * titleViewFontColor;
@property(strong, nonatomic) UIFont         * titleViewTitleFont;
@property(strong, nonatomic) UIFont         * titleViewBtnFont;
@property(assign, nonatomic) CGFloat        titleViewLRSpace;//左右容器边间隔
@property(assign, nonatomic) CGFloat        titleViewSpace;//各内容间隔
//vc
@property(strong, nonatomic) UIColor        * rootBgColor;
@property(strong, nonatomic) UIColor        * contentBgColor;


+(instancetype) createDefault;

@end
