//
//  WXSDK.h
//  iosLibrary
//
//  Created by liu on 2017/9/20.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApiObject.h>
#import "toolMacro.h"

#define WX_SHARE_TYPE_FIREND    0x1
#define WX_SHARE_TYPE_TIMELINE  0x10
//result type
#define TYPE_LOGIN_RESULT       1
#define TYPE_USER_REJECT_AUTH   2
#define TYPE_USER_CANCEL_AUTH   3
#define TYPE_AUTH_ERROR         4
#define TYPE_PAY_RESULT         5
#define TYPE_MESSAGE_RESP       6
//
#define WX_RV_ERRCODE           @"errCode"
#define WX_RV_ERRSTR            @"errStr"
#define WX_RV_DATA              @"data"
#define WX_RV_IS_SUCCESS        @"isSuccess"
//
#define WX_FIELD_OPENID         @"openid"
#define WX_FIELD_UNIONID        @"unionid"
#define WX_FIELD_NICKNAME       @"nickname"
#define WX_FIELD_HEADIMGURL     @"headimgurl"
//
#define WX                      [WXSDK sharedInst]

typedef enum : NSUInteger {
    WxIdType_None = 0,
    WxIdType_Login = 1,
    WxIdType_Pay = 2,
} WXIdType;

@protocol WXSDKDelegate <NSObject>
@optional
-(void)onWXResp:(BaseResp *)resp;
-(void)onWXResult:(NSDictionary *)result type:(int)type;

@end

@interface WXSDK : NSObject

singleton_interface

@property(weak, nonatomic) id<WXSDKDelegate> delegate;

+(BOOL)isInstall;
-(void)addAppId:(NSString *)appId secret:(NSString *)secret universalLink:(NSString *)ul type:(WXIdType)type;
-(BOOL)handleOpenURL:url;
-(BOOL)handleOpenUniversalLink:ul;
-(void)loginWX;
-(void)menuShareUrl:(NSString *)url title:(NSString *)title desc:(NSString *)desc imgUrl:(NSString *)imgUrl shareType:(int)st;
-(void)payWithPartnerId:(NSString *)partenerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(UInt32)timeStamp sign:(NSString *)sign;

@end
