//
//  JPushLoader.h
//  iosLibrary
//
//  Created by liu on 2017/10/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILoader.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#import "JPUSHService.h"

@protocol JPushMsgDelegate <NSObject>

-(void)onJPushMsgContent:(NSString *)content extends:(NSDictionary *)exts info:(NSDictionary *)info;

@end

@interface JPushLoader : NSObject<IAppDelegateLoader>

@property(weak, nonatomic) id<JPushMsgDelegate> delegate;

-(instancetype)initAppKey:(NSString *)key channel:(NSString *)channel isProduction:(BOOL)isProduction;

-(instancetype)initAppKey:(NSString *)key channel:(NSString *)channel isProduction:(BOOL)isProduction msgDelegate:(id<JPushMsgDelegate>)delegate;

@end
