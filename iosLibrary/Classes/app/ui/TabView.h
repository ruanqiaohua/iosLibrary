//
//  TabView.h
//  UserApp
//
//  Created by liu on 2018/9/28.
//  Copyright © 2018年 ljh. All rights reserved.
//

#import "MyLinearLayout.h"

#define LINE_WIDTH_TAB_WIDTH 0
#define LINE_WIDTH_TEXT_WIDTH 1
//
#define TV_IMG_TOP 0
#define TV_IMG_LEFT 1
#define TV_IMG_RIGHT 2

@class TabView;
@protocol TabViewDelegate <NSObject>
-(void)tabView:(TabView *)view tabIndex:(NSInteger)index;
@end

@interface TabView : MyLinearLayout

@property(nonatomic,weak) id<TabViewDelegate> delegate;
@property(nonatomic,assign) NSUInteger maskIndex;
-(instancetype)initTitles:(NSArray<NSString *> *)titles textSize:(CGFloat)ts textColor:(UIColor *)tc textSelColor:(UIColor *)tsc imgTxtLoc:(NSInteger)itl icons:(NSArray<NSString *> *)icons selIcons:(NSArray<NSString *> *)selIcons lineHeight:(CGFloat)lh lineSelColor:(UIColor *)lsc lineColor:(UIColor *)lc lineWdithType:(NSInteger)lwt;

@end
