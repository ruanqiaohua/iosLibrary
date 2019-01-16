//
//  WebSystemPlugin.h
//  iosLibrary
//
//  Created by liu on 2018/1/16.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebPluginBase.h"

#define SEND_SMS        @"sendsms"//发送短信
#define P_SS_TOS        @"tos"//发给谁
#define P_SS_TXT        @"txt"//发的内容
//------------------------------------------------
#define VERSION         @"version"//获取版本号
#define P_VER           @"ver"//返回值key
//------------------------------------------------
#define CALL_PHONE      @"callphone"//拨打电话
#define P_CP_PHONE      @"phone"//电话号码
//------------------------------------------------
#define UPDAGE          @"update"//更新程序
#define P_U_URL         @"url"//app appstore的url

@interface WebSystemPlugin : WebPluginBase

@end
