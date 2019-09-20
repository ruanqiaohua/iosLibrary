//
//  WebTitleViewPlugin.h
//  iosLibrary
//
//  Created by liu on 2018/1/9.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebPluginBase.h"

//--------------------------------------------
#define TV_ADD_IMG_BTN      @"addimgbtn"//添加右边图片按钮
#define P_IB_IMG_URL        @"imgurl"//图片地址
#define P_IB_RES_ID         @"resid"//
//--------------------------------------------
#define TV_ADD_TXT_BTN      @"addtxtbtn"//添加右边文本按钮
#define P_TB_TEXT           @"text"//按钮文本
#define P_TB_TEXT_COLOR     @"tcolor"//按钮文本颜色
#define P_TB_TEXT_SIZE      @"tsize"//按钮文本大小
//--------------------------------------------
#define TV_MD_IMG_BTN_ICO   @"mdimgbtnico"//修改右边图片按钮图片
#define TV_MD_TXT_BTN_TITLE @"mdtxtbtntitle"//修改右边文本按钮文本
#define TV_CLEAR_ALL_BTN    @"clsallbtn"//清除所有右边按钮
#define TV_LEFT_IMG_BTN     @"addleftimgbtn"//添加左边按钮
//--------------------------------------------
#define TV_ADD_TAG          @"addtag"//添加标签
#define P_TAP_DATA          @"tapdata"//标签数据
//
#define TV_SET_TITLE        @"settitle"
#define TV_SET_RETURN       @"setreturn"
#define TV_SHOW_RETURN      @"isShowReturn"
#define P_IS_SHOW           @"isShow"
//
#define BTN_TYPE_NORMAL     0
#define BTN_TYPE_PK         1//不使用
#define BTN_TYPE_JS         2
#define BTN_TYPE_UI         3


@interface WebTitleViewPlugin : WebPluginBase

-(void)setReturnShow:(BOOL)isShow;

@end
