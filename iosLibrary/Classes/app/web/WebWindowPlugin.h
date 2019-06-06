//
//  WebWindowPlugin.h
//  iosLibrary
//
//  Created by liu on 2018/1/18.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebPluginBase.h"

#define WND_TO_URL                  @"tourl"//跳转web
#define P_WND_IS_NEXT_SELF_CLOSE    @"isNextSelfClose"//上层窗体关闭时同时关闭自己
#define WND_CLOSE_WINDOW            @"closewindow"//关闭web窗体
//---------------------------------------------------
#define WND_EXIT_TO                 @"exitto"//关闭到父级web窗体
#define P_EXIT_NUM                  @"num"//关闭几层
#define P_CLOSE_EXEC_JS             @"execJs"//关闭执行js
//---------------------------------------------------
#define WND_MASK_BACK               @"maskback"//屏蔽返回按钮
//
#define WND_RELOAD                  @"reload"//重载

@interface WebWindowPlugin : WebPluginBase

@end
