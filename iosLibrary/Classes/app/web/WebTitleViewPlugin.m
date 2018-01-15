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

#define P_URL = "url";
#define P_TITLE = "title";
#define P_CLOSE_RELOAD = "closeReload";
#define P_BTN_TYPE = "btnType";
#define P_INDEX = "index";
#define P_TITLE_LOCATION = "titleLoc";
//--------------------------------------------
#define TV_ADD_IMG_BTN = "addimgbtn";
#define P_IB_IMG_URL = "imgurl";
#define P_IB_RES_ID = "resid";
//--------------------------------------------
#define TV_ADD_TXT_BTN = "addtxtbtn";
#define P_TB_TEXT = "text";
#define P_TB_TEXT_COLOR = "tcolor";
#define P_TB_TEXT_SIZE = "tsize";
//--------------------------------------------
#define TV_MD_IMG_BTN_ICO = "mdimgbtnico";
#define TV_MD_TXT_BTN_TITLE = "mdtxtbtntitle";
#define TV_CLEAR_ALL_BTN = "clsallbtn";
#define TV_LEFT_IMG_BTN = "addleftimgbtn";
//--------------------------------------------
#define TV_ADD_TAG = "addtag";
#define P_TAP_DATA = "tapdata";
//
#define TV_SET_TITLE = "settitle";
#define TV_SET_RETURN = "setreturn";

@interface WebTitleViewPlugin()<LTitleViewDelegate>

@end

@implementation WebTitleViewPlugin

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
            UIFont * font = ((BaseAppVC *)self.shell).skinCfg.titleViewFont;
            UIColor * tc = ((BaseAppVC *)self.shell).skinCfg.titleViewFontColor;
            [[self.shell getTitleView] addText:title font:font textColor:tc location:tvl needClick:NO];
        }
        NSString * sr = bShowReturn ? [self.shell getTitleViewReturnBtn] : nil;
        if (bShowReturn)
        {
            [[self.shell getTitleView] addImageAsset:sr location:TVL_LEFT needClick:NO];
        }
    }
}

-(BOOL)execWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    BOOL isProc = NO;
    if ([name isEqualToString:@""])
    {

    }
    return NO;
}

-(BOOL)vcResultData:(NSDictionary *)data
{
    return NO;
}

#pragma ------------- 标题栏委托 ----------------
-(void)clickView:(UIView *)view location:(NSInteger)tvl index:(NSInteger)index
{

}

@end
