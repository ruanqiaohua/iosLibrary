//
//  WebWXPlugin.m
//  iosLibrary
//
//  Created by liu on 2018/1/19.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebWXPlugin.h"
#import "LTitleView.h"
#import "WebShellVCBase.h"
#import "NSString+NSStringHelper.h"
#import "UIWebViewEx.h"
#import <YYModel.h>
#import "toolMacro.h"
#import "WXSDK.h"

@interface WebWXPlugin()<WXSDKDelegate>

@end

@implementation WebWXPlugin

-(BOOL)execWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    BOOL isProc = NO;
    if ([name isEqualToString:SHARE])
    {
        WX.delegate = self;
        NSInteger st = SAFE_DICT_INT(param, P_SHARE_TYPE, WX_SHARE_TYPE_FIREND);
        [WX menuShareUrl:param[P_URL] title:SAFESTR(param[P_TITLE]) desc:SAFESTR(param[P_DESC]) imgUrl:SAFESTR(param[P_IMG_URL]) shareType:(int)st];
        isProc = YES;
    }else if ([name isEqualToString:WEIOAUTH])
    {
        WX.delegate = self;
        [WX loginWX];
        isProc = YES;
    }else if ([name isEqualToString:PAY])
    {
        WX.delegate = self;
        NSInteger tm = SAFE_DICT_INT(param, P_TIME_STAMP, 0);
        [WX payWithPartnerId:SAFESTR(param[P_PARTENER_ID]) prepayId:SAFESTR(param[P_PREPAY_ID]) package:SAFESTR(param[P_PACKAGE_NAME]) nonceStr:SAFESTR(param[P_NONCE_STR]) timeStamp:(UInt32)tm sign:SAFESTR(param[P_SIGN])];
        isProc = YES;
    }
    isProc = isProc || !([self execOtherWithFunName:name param:param callback:cb] == EXEC_OTHER_NO_PROC);
    return [self procCallback:cb isProc:isProc alias:param[P_ALIAS]];
}

@end
