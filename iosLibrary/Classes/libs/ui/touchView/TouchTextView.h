//
//  TestTouchTextView.h
//  cjcr
//
//  Created by liu on 16/8/2.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TouchTextView;

@protocol TouchTextViewDelegate <NSObject>

-(void)removeTouchTextView:(TouchTextView *)ttv;

@end

@interface TouchTextView : UIView

@property(assign,nonatomic) CGPoint                             frameLT;
@property(assign,nonatomic) CGPoint                             frameRT;
@property(assign,nonatomic) CGPoint                             frameLB;
@property(assign,nonatomic) CGPoint                             frameRB;
@property(assign,nonatomic) BOOL                                isEditable;
@property(assign,nonatomic) CGFloat                             degree;
@property(weak,nonatomic) id<TouchTextViewDelegate>             delegate;

-(void)caleRectWithScale:(CGFloat)scale radian:(CGFloat)radian;
-(void)setText:(NSString *)text textColor:(UIColor *)color isVertical:(BOOL)isVer font:(UIFont *)font;
-(void)setText:(NSString *)text;
-(void)setFrameColor:(NSUInteger)color frameWidth:(CGFloat)fw;
-(void)setFont:(UIFont *)font;
-(void)setTextColor:(UIColor *)color;
-(void)setTextAlpha:(int)alpha;
-(void)addTextAlpha:(int)alpha;
-(void)setVertical;
-(void)setHorizontal;
-(CGFloat)getFontSize;
-(UIImage *)saveImageWithScale:(CGFloat)scale;

@end
