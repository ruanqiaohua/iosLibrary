//
//  SerollTabbar.h
//  iosLibrary
//
//  Created by liu on 2019/5/24.
//  Copyright © 2019年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ST_IMG_TOP 0
#define ST_IMG_LEFT 1
#define ST_IMG_RIGHT 2

@class ScrollTabbar;

@protocol ScrollTabbarDelegate <NSObject>

-(void)scrollTabbar:(ScrollTabbar *)stb tabSelectIndex:(NSInteger)index;

@end

@interface ScrollTabbar : UIScrollView

@property(strong, nonatomic) NSArray<NSString *> * titles;
@property(assign, nonatomic) CGFloat textPXSize;
@property(strong, nonatomic) UIColor * textColor;
@property(strong, nonatomic) UIColor * textSelectColor;
@property(assign, nonatomic) NSInteger iconTxtLocation;
@property(strong, nonatomic) NSArray<NSString *> * icons;
@property(strong, nonatomic) NSArray<NSString *> * selectIcons;
@property(assign, nonatomic) CGFloat iconTxtSpace;
//////////////
@property(assign, nonatomic) NSInteger lineSkipIndex;//点击后line不移动到该位置
@property(assign, nonatomic) CGFloat lineHeight;
@property(assign, nonatomic) CGFloat lineWidth;
@property(strong, nonatomic) UIColor * lineSelectColor;
@property(strong, nonatomic) UIColor * lineColor;
@property(assign, nonatomic) BOOL isLineWidthEqualText;
@property(assign, nonatomic) NSInteger selectedIndex;
@property(weak, nonatomic) id<ScrollTabbarDelegate> stbDelegate;
@end

NS_ASSUME_NONNULL_END
