//
//  UISkinConfig.m
//  iosLibrary
//
//  Created by liu on 2018/1/11.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "UISkinConfig.h"
#import "toolMacro.h"
@implementation UISkinConfig

+(instancetype) createDefault
{
    UISkinConfig * cfg = [[UISkinConfig alloc] init];
    cfg.rootBgColor = UIColorFromRGBA(0xffeef1f6);
    cfg.contentBgColor = cfg.rootBgColor;
    return cfg;
}

@end
