//
//  JPushLoader.m
//  iosLibrary
//
//  Created by liu on 2017/10/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "JPushLoader.h"
#import "toolMacro.h"
#import "objMacro.h"
#import <UIKit/UIKit.h>

@interface JPushLoader()<JPUSHRegisterDelegate>

PropertyCString(appKey);
PropertyCString(channel);
PropertyBOOL(isProduction);

@end

@implementation JPushLoader

-(instancetype)initAppKey:(NSString *)key channel:(NSString *)channel isProduction:(BOOL)isProduction
{
    return [self initAppKey:key channel:channel isProduction:isProduction msgDelegate:nil];
}

-(instancetype)initAppKey:(NSString *)key channel:(NSString *)channel isProduction:(BOOL)isProduction msgDelegate:(id<JPushMsgDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.appKey = key;
        self.channel = channel;
        self.isProduction = isProduction;
        _delegate = delegate;
    }
    return self;
}

-(void)initJPushOpt:(NSDictionary *)launchOptions
{
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if (IOS_VERSION >= 8.0)
    {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:self.appKey
                          channel:self.channel
                 apsForProduction:self.isProduction
            advertisingIdentifier:nil];
    
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

-(void)initLoaderWithDict:(id)dict
{
    
}

-(void)deInitLoader
{
    
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    if (self.delegate)
    {
        NSDictionary * userInfo = [notification userInfo];
        NSString * content = [userInfo valueForKey:@"content"];
        NSDictionary * extras = [userInfo valueForKey:@"extras"];
        
        [self.delegate onJPushMsgContent:content extends:extras info:userInfo];
    }
}

//---------------  IAppDelegateLoader  -----------------//
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initJPushOpt:launchOptions];
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}

//---------------- JPUSHRegisterDelegate ----------------//
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler
API_AVAILABLE(ios(10.0))API_AVAILABLE(ios(10.0))API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    if (@available(iOS 10.0, *))
    {
        completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge);
    } else
    {
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
API_AVAILABLE(ios(10.0))API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    completionHandler();
}

@end
