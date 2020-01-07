//
//  WXSDK.m
//  iosLibrary
//
//  Created by liu on 2017/9/20.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "WXSDK.h"
#import <WXApi.h>
#import "SDWebImageManager.h"
#import "WHActivityView.h"
#import "NSString+NSStringHelper.h"
#import "BaseAppVC.h"

@interface WxAppInfo : NSObject
@property(copy, nonatomic) NSString * appId;
@property(copy, nonatomic) NSString * secret;
@property(copy, nonatomic) NSString * universalLink;
@end
@implementation WxAppInfo
@end

/*********************************************/

@interface WXSDK()<WXApiDelegate>
{
    NSMutableDictionary<NSString *, WxAppInfo *> * dictAppInfo;
    WXIdType curType;
    WxAppInfo * curWxInfo;
    WHActivityView * activityView;
}
@end

@implementation WXSDK

singleton_implementation(WXSDK)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        curType = WxIdType_None;
        dictAppInfo = ONEW(NSMutableDictionary);
    }
    return self;
}

+(BOOL)isInstall
{
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

-(void)addAppId:(NSString *)appId secret:(NSString *)secret universalLink:(NSString *)ul type:(WXIdType)type
{
    WxAppInfo * info = ONEW(WxAppInfo);
    info.appId = appId;
    info.secret = secret;
    info.universalLink = ul;
    dictAppInfo[FRMSTR(@"%lu",(unsigned long)type)] = info;
    if (curType == WxIdType_None)
    {
        [WXApi registerApp:appId universalLink:ul];
        curType = type;
        curWxInfo = info;
    }
}

-(BOOL)handleOpenURL:url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)handleOpenUniversalLink:ul
{
    return [WXApi handleOpenUniversalLink:ul delegate:self];
}

-(void)loginWX
{
    if (![self switchType:WxIdType_Login])return;
    SendAuthReq * req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"wx";
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

-(void)menuShareUrl:(NSString *)url title:(NSString *)title desc:(NSString *)desc imgUrl:(NSString *)imgUrl shareType:(int)st
{
    if (![self switchType:WxIdType_Login])return;
    NSMutableArray * shareItemsArray = ONEW(NSMutableArray);
    @synchronized (self)
    {
        if (activityView)
        {
            [activityView removeFromSuperview];
            activityView = nil;
        }
        
        UIWindow * window = [[BaseAppVC getCurrVC].view window];
        activityView = [[WHActivityView alloc]initWithTitle:nil referView:window isNeed:NO];
        activityView.numberOfButtonPerLine = 3;//6
    }
    
    if (st & WX_SHARE_TYPE_FIREND)
    {
        WEAKOBJ(self);
        ButtonView * bv = [[ButtonView alloc]initWithText:@"发送给朋友" image:[UIImage imageNamed:@"ico_wx"] handler:^(ButtonView *buttonView){
            [weak_self shareLinkUrl:url title:title desc:desc imgUrl:imgUrl scene:WXSceneSession];
        }];
        [activityView addButtonView:bv];
    }
    if (st & WX_SHARE_TYPE_TIMELINE)
    {
        WEAKOBJ(self);
        ButtonView * bv = [[ButtonView alloc]initWithText:@"分享朋友圈" image:[UIImage imageNamed:@"ico_timeline"] handler:^(ButtonView *buttonView){
            [weak_self shareLinkUrl:url title:title desc:desc imgUrl:imgUrl scene:WXSceneTimeline];
        }];
        [activityView addButtonView:bv];
    }
    [activityView show];
}

-(void)payWithPartnerId:(NSString *)partenerId prepayId:(NSString *)prepayId package:(NSString *)package nonceStr:(NSString *)nonceStr timeStamp:(UInt32)timeStamp sign:(NSString *)sign
{
    if (![self switchType:WxIdType_Pay])return;
    PayReq *request = [[PayReq alloc] init];
    //request.openID = curWxInfo.appId;
    request.partnerId = partenerId;
    request.prepayId= prepayId;
    request.package = package;
    request.nonceStr = nonceStr;
    request.timeStamp = timeStamp;
    request.sign= sign;
    [WXApi sendReq:request completion:^(BOOL success) {
    }];
}

/************** private fun *********************/
-(BOOL)switchType:(WXIdType)type
{
    if (curType == WxIdType_None)
    {
        NSLog(@"switchType is err (appId is empty)");
        return NO;
    }
    if (curType != type)
    {
        WxAppInfo * info = dictAppInfo[FRMSTR(@"%lu",(unsigned long)type)];
        if (info)
        {
            [WXApi registerApp:info.appId universalLink:info.universalLink];
            curWxInfo = info;
        }
    }
    return YES;
}

-(void)shareLinkUrl:(NSString *)url title:(NSString *)title desc:(NSString *)desc imgUrl:(NSString *)imgUrl scene:(int)scene
{
    if (imgUrl.length == 0)return;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager.imageDownloader downloadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL)
     {
     } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished)
     {
         
         WXMediaMessage *message = [WXMediaMessage message];
         message.title = title;
         message.description = desc;
         
         if (image)
         {
             [message setThumbImage:image];
         }
         
         WXWebpageObject *ext = [WXWebpageObject object];
         ext.webpageUrl = url;
         
         message.mediaObject = ext;
         
         SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
         req.bText = NO;
         req.message = message;
         req.scene = scene;
         [WXApi sendReq:req completion:^(BOOL success) {
            NSLog(@"%d",success);
         }];
     }];
}

-(void)getAccessTokenWithRefreshToken:(NSString *)refreshToken
{
    NSString *urlString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",curWxInfo.appId,refreshToken];
    NSURL * url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString * dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //授权过期
                    [self loginWX];
                }else
                {
                    //重新使用AccessToken获取信息
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"] andOpenId:[dict objectForKey:@"openid"] refreshToken:[dict objectForKey:@"refresh_token"]];
                }
            }
        });
    });
}

-(void)getUserInfoWithAccessToken:(NSString *)accessToken andOpenId:(NSString *)openId
                     refreshToken:(NSString *)refreshToken
{
    NSString * urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",accessToken,openId];
    NSURL * url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString * dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if ([dict objectForKey:@"errcode"])
                {
                    //AccessToken失效,用RefreshToken重新获取AccessToken
                    [self getAccessTokenWithRefreshToken:refreshToken];
                }else if (self.delegate && [self.delegate respondsToSelector:@selector(onWXResult:type:)])
                {
                    //获取需要的数据
                    [self.delegate onWXResult:@{WX_RV_IS_SUCCESS:@"1",
                                                WX_RV_DATA:dict
                                                } type:TYPE_LOGIN_RESULT];
                }
            }
        });
    });
}

//使用code获取access token
-(void)getAccessTokenWithCode:(NSString *)code
{
    NSString *urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code", curWxInfo.appId, curWxInfo.secret, code];
    NSURL * url = [NSURL URLWithString:urlString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString * dataStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSData * data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (data)
            {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                if (!self.delegate)return;
                if ([dict objectForKey:@"errcode"])
                {
                    //获取token错误
                    if ([self.delegate respondsToSelector:@selector(onWXResult:type:)])
                    {
                        [self.delegate onWXResult:
                         @{WX_RV_ERRCODE:@([[dict objectForKey:@"errcode"] intValue]),
                           WX_RV_ERRSTR:[dict objectForKey:@"errmsg"]
                           } type:TYPE_AUTH_ERROR];
                    }
                }else
                {
                    //存储AccessToken OpenId RefreshToken以便下次直接登陆
                    //AccessToken有效期两小时，RefreshToken有效期三十天
                    [self getUserInfoWithAccessToken:[dict objectForKey:@"access_token"]
                                           andOpenId:[dict objectForKey:@"openid"]
                                        refreshToken:[dict objectForKey:@"refresh_token"]];
                }
            }
        });
    });
}

/************** WXApiDelegate *********************/
-(void) onResp:(BaseResp*)resp
{
    if (!self.delegate)return;
    if ([self.delegate respondsToSelector:@selector(onWXResult:type:)])
    {
        if ([resp isKindOfClass:[SendAuthResp class]])
        {
            SendAuthResp * sr = (SendAuthResp *)resp;
            if (sr.errCode == 0)
            {
                [self getAccessTokenWithCode:sr.code];
                return;
            }else if (sr.errCode == -4)
            {
                [self.delegate onWXResult:nil type:TYPE_USER_REJECT_AUTH];
                return;
            }else if (sr.errCode == -2)
            {
                [self.delegate onWXResult:nil type:TYPE_USER_CANCEL_AUTH];
                return;
            }
            [self.delegate onWXResult:@{WX_RV_ERRCODE:@(sr.errCode),
                                        WX_RV_ERRSTR:SAFESTR(sr.errStr)} type:TYPE_AUTH_ERROR];
        }else if ([resp isKindOfClass:[SendMessageToWXResp class]])
        {
            [self.delegate onWXResult:@{WX_RV_IS_SUCCESS:(resp.errCode == 0 ? @"1" : @"0")} type:TYPE_MESSAGE_RESP];
        }else if ([resp isKindOfClass:[PayResp class]])
        {
            PayResp * response = (PayResp*)resp;
            [self.delegate onWXResult:@{WX_RV_IS_SUCCESS:(resp.errCode == 0 ? @"1" : @"0"),
                                        WX_RV_ERRCODE:@(response.errCode),
                                        WX_RV_ERRSTR:SAFESTR(response.errStr)} type:TYPE_PAY_RESULT];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(onWXResp:)])
    {
        [self.delegate onWXResp:resp];
    }
}

@end
