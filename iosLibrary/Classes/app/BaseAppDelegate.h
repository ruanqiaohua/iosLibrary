//
//  BaseAppDelegate.h
//  iosLibrary
//
//  Created by liu on 2017/9/30.
//  Copyright © 2017年 liu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ILoader.h"

@interface BaseAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

-(NSArray<id<IAppDelegateLoader>> *)getLoader;

-(void)addLoader:(id<IAppDelegateLoader>)loader;
-(void)removeLoader:(id<IAppDelegateLoader>)loader;

@end
