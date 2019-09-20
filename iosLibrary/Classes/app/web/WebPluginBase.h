//
//  WebPluginBase.h
//  iosLibrary
//
//  Created by liu on 2018/1/2.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define EXEC_OTHER_NO_PROC      0//不需要处理
#define EXEC_OTHER_BASE_PROC    1//由父类处理回调
#define EXEC_OTHER_SELF_PROC    2//继承类自己处理回调

#define EVENT_INIT              0
#define EVENT_DEINIT            1
#define EVENT_RESULT_DATA       2
#define EVENT_EXEC              3

#pragma --------------------------------------

#define TITLE_MAX_LEN       12
#define P_URL               @"url"
#define P_TITLE             @"title"
#define P_CLOSE_RELOAD      @"clsReload"//关闭刷新
#define P_BTN_TYPE          @"btnType"
#define P_INDEX             @"index"
#define P_TITLE_LOCATION    @"titleLoc"
#define P_ALIAS             @"alias"
#define METHOD              @"method"
#define SUCCESS             @"success"

#pragma ---------------------------------------

@protocol IWebShell;

@protocol IWebPlugin

-(void)initPluginWithData:(NSDictionary *)data;
-(NSString *)getName;
-(void)deInitPlugin;
-(NSInteger)execOtherWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb;
-(BOOL)execWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb;
-(BOOL)vcResultData:(NSDictionary *)data;

@end

@interface WebPluginBase : NSObject<IWebPlugin>

@property(nonatomic, weak) id<IWebShell> shell;

-(BOOL)procCallback:(NSString *)cb param:(NSDictionary *)param isSuccess:(BOOL)isSuccess values:(NSDictionary *)values;

@end
