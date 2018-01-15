//
//  LTitleView.h
//  iosLibrary
//
//  Created by liu on 2018/1/3.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>

#define NON_INDEX   -1
#define TVL_LEFT    0
#define TVL_MIDDLE  1
#define TVL_RIGHT   2

@protocol LTitleViewDelegate

-(void)clickView:(UIView *)view location:(NSInteger)tvl index:(NSInteger)index;

@end

@protocol ITitleView

@property(weak, nonatomic) id<LTitleViewDelegate> delegate;

-(NSInteger)addImageAsset:(NSString *)asset location:(NSInteger)tvl needClick:(BOOL)nc;
-(NSInteger)addImageUrl:(NSString *)url location:(NSInteger)tvl needClick:(BOOL)nc;
-(NSInteger)addText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)tc location:(NSInteger)tvl needClick:(BOOL)nc;
-(UIView *)getViewWithIndex:(NSInteger)index location:(NSInteger)tvl;
-(UIView *)showViewWithIndex:(NSInteger)index location:(NSInteger)tvl isShow:(BOOL)isShow;
-(UIView *)mdImageAsset:(NSString *)asset location:(NSInteger)tvl index:(NSInteger)index;
-(UIView *)mdImageUrl:(NSString *)url location:(NSInteger)tvl index:(NSInteger)index;
-(UIView *)mdText:(NSString *)text location:(NSInteger)tvl index:(NSInteger)index;
-(void)removeAllByLocation:(NSInteger)tvl;

@end

@interface LTitleView : MyRelativeLayout<ITitleView>

@property(assign, nonatomic) NSInteger space;

@end
