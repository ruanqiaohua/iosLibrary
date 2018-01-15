//
//  KVDetailLayout.h
//  iosLibrary
//
//  Created by liu on 2017/11/17.
//  Copyright © 2017年 liu. All rights reserved.
//
#import "AbsLayout.h"

//单行布局
@interface SngRowLayout : AbsLayout

@property(nonatomic, readonly) UIImageView * ivTitleLeft;
@property(nonatomic, readonly) UILabel * labTitle;
@property(nonatomic, readonly) UIImageView * ivTitleRight;
//
@property(nonatomic, readonly) UIImageView * ivValueLeft;
@property(nonatomic, readonly) UILabel * labValue;
@property(nonatomic, readonly) UIImageView * ivValueRight;

//设置左边内容， 排列：图片-文本-图片
-(void)setTitle:(NSString *)text leftImage:(UIImage *)lImg rightImage:(UIImage *)rImg;
//设置右边内容(靠右)，排列：图片-文本-图片
-(void)setValue:(NSString *)text leftImage:(UIImage *)lImg rightImage:(UIImage *)rImg;

-(void)setTitle:(NSString *)text;
-(void)setValue:(NSString *)text;

-(void)addTopLineColor:(UIColor *)color height:(CGFloat)height;
-(void)addBottomLineColor:(UIColor *)color height:(CGFloat)height;

@end
