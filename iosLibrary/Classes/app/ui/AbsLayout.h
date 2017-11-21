//
//  AbsLayout.h
//  iosLibrary
//
//  Created by liu on 2017/11/17.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>
#import "ViewDataModel.h"

@interface AbsLayout : MyRelativeLayout

//布局的数据
@property(nonatomic, strong) ViewDataModel data;
//设置布局中各控件间隔
@property(nonatomic, strong) NSArray<NSValue *> * uiEdges;
//设置布局中各控件字体
@property(nonatomic, strong) NSArray<UIFont *> * uiFont;
//设置布局中各控件字体颜色， 前面是显示的颜色，后面跟占位颜色
@property(nonatomic, strong) NSArray<UIColor *> * uiTextColor;
//添加底部线
-(void)addBottomLineWithColor:(UIColor *)color height:(CGFloat)height lrSpace:(CGFloat)space;

@end
