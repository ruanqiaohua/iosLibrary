//
//  WebTitleViewPlugin.m
//  iosLibrary
//
//  Created by liu on 2018/1/9.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebTitleViewPlugin.h"
#import "LTitleView.h"
#import "WebShellVCBase.h"
#import "toolMacro.h"
#import <YYModel.h>

#define KEY_GEN(tvl,index)  (tvl << 3) | (index & 7)
#define KEY_TVL(val)        (val >> 3)
#define KEY_INX(val)        (val & 7)

@interface BtnExInfo : NSObject

@property(nonatomic, strong) NSString   * openUrl;
@property(nonatomic, strong) NSString   * title;
@property(nonatomic, assign) BOOL       closeReload;
@property(nonatomic, assign) NSInteger  btnType;
@property(nonatomic, strong) NSObject   * data;

@end

@implementation BtnExInfo
@end

@interface WebTitleViewPlugin()<LTitleViewDelegate>
{
    NSMutableDictionary<NSNumber *, BtnExInfo *>  * dictBtnInfo;
    NSInteger                                   titleLocation;
    NSInteger                                   titleIndex;
    NSInteger                                   returnBtnIndex;
}
@end

@implementation WebTitleViewPlugin

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        titleLocation = TVL_MIDDLE;
        titleIndex = -1;
        dictBtnInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)getParam:(NSDictionary *)param key:(NSInteger)key
{
    BtnExInfo * bi = [[BtnExInfo alloc] init];
    bi.btnType = [param[P_BTN_TYPE] integerValue];
    bi.closeReload = [param[P_CLOSE_RELOAD] boolValue];
    bi.openUrl = param[P_URL];
    bi.title = param[P_TITLE];
    bi.data = param[P_ALIAS];
    dictBtnInfo[@(key)] = bi;
}

#pragma ------------------
-(void)initPluginWithData:(NSDictionary *)data
{
    [self.shell getTitleView].delegate = self;
    if (data)
    {
        NSString * title = data[WS_TITLE];
        NSInteger tvl = [((NSNumber *)data[WS_TITLE_LOCATION]) integerValue];
        BOOL bShowReturn = [((NSNumber *)data[WS_SHOW_RETURN]) boolValue];
        if (title.length > 0)
        {
            [self execWithFunName:TV_SET_TITLE param:@{P_TB_TEXT:title,
                                                       P_TITLE_LOCATION:@(tvl)
                                                       } callback:nil];
        }
        NSString * retStr = bShowReturn ? [self.shell getTitleViewReturnBtn] : nil;
        if (retStr)
        {
            [[self.shell getTitleView] addImageAsset:retStr location:TVL_LEFT needClick:YES];
        }
    }
}

-(BOOL)execWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    BOOL isProc = NO;
    UIFont * font = ((BaseAppVC *)self.shell).skinCfg.titleViewBtnFont;
    id<ITitleView> tv = [self.shell getTitleView];
    NSInteger index;
    if ([name isEqualToString:TV_ADD_IMG_BTN])
    {
        index = [tv addImageUrl:SAFESTR(param[P_IB_IMG_URL]) location:TVL_RIGHT needClick:YES];
        [self getParam:param key:KEY_GEN(TVL_RIGHT, index)];
        isProc = true;
    }else if ([name isEqualToString:TV_ADD_TXT_BTN])
    {
        if (param[P_TB_TEXT_SIZE])
        {
            font = [font fontWithSize: SAFE_DICT_INT(param, P_TB_TEXT_SIZE, PXTO6SW(58))];
        }
        UIColor * tc;
        if (param[P_TB_TEXT_COLOR])
        {
            tc = UIColorFromRGBA(SAFE_DICT_INT(param, P_TB_TEXT_COLOR, 0));
        }else
        {
            tc = ((BaseAppVC *)self.shell).skinCfg.titleViewFontColor;
        }
        index = [tv addText:param[P_TB_TEXT] font:font textColor:tc location:TVL_RIGHT needClick:YES];
        [self getParam:param key:KEY_GEN(TVL_RIGHT, index)];
        isProc = true;
    }else if ([name isEqualToString:TV_MD_IMG_BTN_ICO])
    {
        [tv mdImageUrl:SAFESTR(param[P_IB_IMG_URL]) location:TVL_RIGHT index:SAFE_DICT_INT(param, P_INDEX, 0)];
        isProc = true;
    }else if ([name isEqualToString:TV_MD_TXT_BTN_TITLE])
    {
        [tv mdText:SAFESTR(param[P_TB_TEXT]) location:TVL_RIGHT index:SAFE_DICT_INT(param, P_INDEX, 0)];
        isProc = true;
    } else if ([name isEqualToString:TV_CLEAR_ALL_BTN])
    {
        [tv removeAllByLocation:TVL_RIGHT];
        isProc = true;
    } else if ([name isEqualToString:TV_LEFT_IMG_BTN])
    {
        index = [tv addImageUrl:SAFESTR(param[P_IB_IMG_URL]) location:TVL_LEFT needClick:YES];
        [self getParam:param key:KEY_GEN(TVL_LEFT, index)];
        isProc = true;
    }else if ([name isEqualToString:TV_SET_TITLE])
    {
        NSInteger tvl = SAFE_DICT_INT(param, P_TITLE_LOCATION, TVL_MIDDLE);
        NSString * title = SAFESTR(param[P_TB_TEXT]);
        UIFont * font;
        if (param[P_TB_TEXT_SIZE])
        {
            font = [font fontWithSize:SAFE_DICT_INT(param, P_TB_TEXT_SIZE, 0)];
        }else
        {
            font = ((BaseAppVC *)self.shell).skinCfg.titleViewTitleFont;
        }
        UIColor * tc;
        if (param[P_TB_TEXT_COLOR])
        {
            tc = UIColorFromRGBA(SAFE_DICT_INT(param, P_TB_TEXT_COLOR, 0));
        }else
        {
            tc = ((BaseAppVC *)self.shell).skinCfg.titleViewFontColor;
        }
        //
        if (title.length > TITLE_MAX_LEN)
        {
            title = [[title substringToIndex:TITLE_MAX_LEN] stringByAppendingString:@"..."];
        }
        if (titleIndex == -1)
        {
            titleIndex = [tv addText:title font:font textColor:tc location:tvl needClick:NO];
            titleLocation = tvl;
        }else
        {
            [tv mdText:title location:tvl index:titleIndex];
        }
        isProc = true;
    } else if ([name isEqualToString:TV_SET_RETURN])
    {
        returnBtnIndex = [tv addImageAsset:param[P_IB_RES_ID] location:TVL_LEFT needClick:YES];
        isProc = true;
    } else if ([name isEqualToString:TV_ADD_TAG])
    {
        index = [tv addImageUrl:SAFESTR(param[P_IB_IMG_URL]) location:TVL_MIDDLE needClick:YES];
        [self getParam:param key:KEY_GEN(TVL_MIDDLE, index)];
        [self.shell jsCallWithFunName:name param:SAFESTR(param[P_TAP_DATA])];
        isProc = true;
    }
    isProc = isProc || !([self execOtherWithFunName:name param:param callback:cb] == EXEC_OTHER_NO_PROC);
    if (!cb)return isProc;
    return [self procCallback:cb isProc:isProc alias:param[P_ALIAS]];
}

-(BOOL)vcResultData:(NSDictionary *)data
{
    return NO;
}

#pragma ------------- 标题栏委托 ----------------
-(void)clickView:(UIView *)view location:(NSInteger)tvl index:(NSInteger)index
{
    switch (tvl)
    {
        case TVL_LEFT:
            if (index == returnBtnIndex)
            {
                [self.shell closeWindowWithLevel:0 bCloseReload:NO closeExecJs:@""];
            }else
            {
                [self clickBtnInfo:dictBtnInfo[@(KEY_GEN(tvl, index))]];
            }
            break;
        case TVL_MIDDLE:
        case TVL_RIGHT:
            [self clickBtnInfo:dictBtnInfo[@(KEY_GEN(tvl, index))]];
            break;
    }
}

-(void)clickBtnInfo:(BtnExInfo *)bi
{
    switch (bi.btnType)
    {
        case BTN_TYPE_NORMAL:
            [self.shell openUrl:bi.openUrl title:bi.title bShowReturn:YES titleLocation:TVL_MIDDLE bNextSelfClose:NO];
            break;
        case BTN_TYPE_JS:
            [self.shell execJScript:FRMSTR(@"event_callback(%@)", [@{METHOD:bi.data} yy_modelToJSONString])];
            break;
        case BTN_TYPE_UI:
            [self.shell pluginCallbackWithFunName:SAFESTR((NSString *)bi.data) param:nil];
            break;
    }
}

@end
