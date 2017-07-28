//
//  LViewPager.h
//  cjcr
//
//  Created by liu on 2017/2/23.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAB_LOC_TOP        0x0
#define TAB_LOC_BOTTOM     0x01

@interface LViewPager : UIView

@property(assign, nonatomic) NSUInteger tabLocation;
@property(assign, nonatomic) BOOL enabledScroll; //设置viewPager是否允许滚动 默认支持
@property(assign, nonatomic) NSUInteger selectIndex;//当前选择的页面的索引
//tab按钮背景属性
@property(nonatomic, strong) UIColor * tabBgColor;
@property(nonatomic, strong) UIColor * tabSelectedBgColor;
//tab上水平线的颜色
@property(nonatomic, strong) UIColor * horLineColor;
//tab间垂直线的颜色
@property(nonatomic, strong) UIColor * vertLineColor;
//菜单按钮的标题颜色属性
@property(nonatomic, strong) UIColor * tabTextColor;
@property(nonatomic, strong) UIColor * tabSelectedTextColor;
@property(nonatomic, strong) UIFont * tabTextFont;
@property(nonatomic, assign) CGFloat tabHeight;
//是否显示垂直分割线  默认显示
@property (nonatomic, assign) BOOL showVLine;
//是否显示水平横线，如果titleInTop显示在下面，否则显示在上面  默认显示
@property (nonatomic, assign) BOOL showHLine;
//选中状态是否显示底部横线  默认显示
@property(nonatomic, strong) UIColor * tabSelectedArrowColor;
@property (nonatomic, assign) BOOL showTabSelectedArrowLine; //选择下划线的颜色
@property (nonatomic, assign) BOOL showAnimationMoveArrowLine; //移动TabSelectedArrow是否使用动画

-(instancetype)initHostVC:(UIViewController *)vc tabs:(NSArray *)tabs subVC:(NSArray *)svc;
-(void)setTitleIcons:(NSArray *)icons selectIcons:(NSArray *)selIcons;
//显示右上角红点数量，-1 为红点， 0 为去掉红点， 大于0 为红点中数字
-(void)setTipsNumber:(NSUInteger)number titleIndex:(NSUInteger)ti;
-(void)enterViewController;
@end
