//
//  WebWXPlugin.h
//  iosLibrary
//
//  Created by liu on 2018/1/19.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebPluginBase.h"

//---------------------------------------------
#define SHARE               @"sharewx"//发送微信分享
#define P_URL               @"url"
#define P_TITLE             @"title"
#define P_DESC              @"desc"
#define P_IMG_URL           @"imgurl"
#define P_SHARE_TYPE        @"sharetype"
//---------------------------------------------
#define WEIOAUTH            @"weioauth"//微信认证
//---------------------------------------------
#define PAY                 @"wxpay"//微信付款
#define P_PARTENER_ID       @"partenerId"
#define P_PREPAY_ID         @"prepayId"
#define P_PACKAGE_NAME      @"packageName"
#define P_NONCE_STR         @"nonceStr"
#define P_TIME_STAMP        @"timeStamp"
#define P_SIGN              @"sign"

@interface WebWXPlugin : WebPluginBase

@end
