//
//  BaseAppDelegate.m
//  iosLibrary
//
//  Created by liu on 2017/9/30.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "BaseAppDelegate.h"
#import "toolMacro.h"
#import "BaseViewController.h"

@interface BaseAppDelegate()
{
    NSMutableArray<id<IAppDelegateLoader>> * loaderArray;
}
@end

@implementation BaseAppDelegate

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        loaderArray = ONEW(NSMutableArray);
        NSArray<id<IAppDelegateLoader>> * loaders = [self getLoader];
        if (loaders)
        {
            [loaderArray addObjectsFromArray:loaders];
        }
    }
    return self;
}

-(void)addLoader:(id<IAppDelegateLoader>)loader
{
    [loaderArray addObject:loader];
}

-(void)removeLoader:(id<IAppDelegateLoader>)loader
{
    [loaderArray removeObject:loader];
}

-(NSArray<id<IAppDelegateLoader>> *)getLoader
{
    return nil;
}

-(void)appDidFinishLaunching
{

}

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (loaderArray.count > 0)
    {
        for (id<IAppDelegateLoader> loader in loaderArray)
        {
            if ([loader respondsToSelector:@selector(application:didFinishLaunchingWithOptions:)])
            {
                [loader application:application didFinishLaunchingWithOptions:launchOptions];
            }
            [loader initLoaderWithDict:nil];
        }
    }
    [self appDidFinishLaunching];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (loaderArray.count > 0)
    {
        for (id<IAppDelegateLoader> loader in loaderArray)
        {
            if ([loader respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)])
            {
                [loader application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
            }
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    if (loaderArray.count > 0)
    {
        for (id<IAppDelegateLoader> loader in loaderArray)
        {
            if ([loader respondsToSelector:@selector(applicationWillResignActive:)])
            {
                [loader applicationWillResignActive:application];
            }
        }
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[BaseViewController getCurrVC] viewWillDisappear:NO];
    [[BaseViewController getCurrVC] viewDidDisappear:NO];
    if (loaderArray.count > 0)
    {
        for (id<IAppDelegateLoader> loader in loaderArray)
        {
            if ([loader respondsToSelector:@selector(applicationDidEnterBackground:)])
            {
                [loader applicationDidEnterBackground:application];
            }
        }
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[BaseViewController getCurrVC] viewWillAppear:NO];
    [[BaseViewController getCurrVC] viewDidAppear:NO];
    if (loaderArray.count > 0)
    {
        for (id<IAppDelegateLoader> loader in loaderArray)
        {
            if ([loader respondsToSelector:@selector(applicationWillEnterForeground:)])
            {
                [loader applicationWillEnterForeground:application];
            }
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (loaderArray.count > 0)
    {
        for (id<IAppDelegateLoader> loader in loaderArray)
        {
            if ([loader respondsToSelector:@selector(applicationDidBecomeActive:)])
            {
                [loader applicationDidBecomeActive:application];
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if (loaderArray.count > 0)
    {
        for (id<IAppDelegateLoader> loader in loaderArray)
        {
            if ([loader respondsToSelector:@selector(applicationWillTerminate:)])
            {
                [loader applicationWillTerminate:application];
            }
            [loader deInitLoader];
        }
    }
}

@end
