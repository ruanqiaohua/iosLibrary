//
//  JMessageLoader.m
//  iosLibrary
//
//  Created by liu on 2018/11/1.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "JMessageLoader.h"
#import "toolMacro.h"
#import "objMacro.h"

@interface JMessageLoader()

PropertyCString(appKey);
PropertyCString(channel);
PropertyBOOL(isProduction);
PropertyDelegate(JMessageDelegate);

@end

@implementation JMessageLoader

-(instancetype)initAppKey:(NSString *)key channel:(NSString *)channel isProduction:(BOOL)isProduction msgDelegate:(id<JMessageDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        [JMessage addDelegate:delegate withConversation:nil];
        self.appKey = key;
        self.channel = channel;
        self.isProduction = isProduction;
    }
    return self;
}

-(void)initLoaderWithDict:(id)dict
{

}

-(void)deInitLoader
{
    [JMessage removeDelegate:self.delegate withConversation:nil];
}
//---------------  IAppDelegateLoader  -----------------//
-(void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [JMessage setupJMessage:launchOptions appKey:self.appKey channel:self.channel apsForProduction:self.isProduction category:nil messageRoaming:YES];
    if (@available(iOS 8.0, *)) {
        [JMessage registerForRemoteNotificationTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    } else {
            // Fallback on earlier versions
    }
    [JMessage resetBadge];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JMessage registerDeviceToken:deviceToken];
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
    [JMessage resetBadge];
}

@end
