//
//  TagLayout.h
//  iosLibrary
//
//  Created by liu on 2017/11/7.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>

#pragma -------- 标签的信息类
@interface TagInfo : NSObject

@property(nonatomic, copy) NSString * name;
@property(nonatomic, strong) id value;

@end

#pragma -------- 标签的样式类
@interface TagStyle : NSObject
//普通模式下标签按钮的背景色
@property(nonatomic, strong) UIColor * nlBgColor;
@property(nonatomic, strong) UIColor * nlBorderColor;
@property(nonatomic, strong) UIColor * nlTextColor;
@property(nonatomic, strong) UIFont * nlTextFont;
//选中模式
@property(nonatomic, strong) UIColor * selBgColor;
@property(nonatomic, strong) UIColor * selBorderColor;
@property(nonatomic, strong) UIColor * selTextColor;
//
@property(nonatomic, assign) CGFloat borderWidth;
@property(nonatomic, assign) CGFloat flagMinWidth;
@property(nonatomic, assign) CGFloat borderRadius;

+(instancetype)initNlBgColor:(UIColor *)nlBg nlBorderColor:(UIColor *)nlBc nlTextColor:(UIColor *)nlTc nlTextFont:(UIFont *)nlTf
                  selBgColor:(UIColor *)selBg selBorderColor:(UIColor *)selBc selTextColor:(UIColor *)selTc
                 borderWidth:(CGFloat)bw flagMinWidth:(CGFloat)flagMinWidth borderRadius:(CGFloat)br;
@end

#pragma -------- 标签的事件
@protocol TagDelegate <NSObject>
-(void)clickTagInfo:(TagInfo *)ti;
@end

@interface TagLayout : MyRelativeLayout

@property(nonatomic, weak) id<TagDelegate> delegate;
@property(nonatomic, readonly) MyFlowLayout * flowLayout;
@property(nonatomic, assign) NSInteger curSelIndex;

-(void)addTags:(NSArray<TagInfo *> *)tags tagStyle:(TagStyle *)ts;
-(void)removeAllTag;

@end
