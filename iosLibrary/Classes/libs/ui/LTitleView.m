//
//  LTitleView.m
//  iosLibrary
//
//  Created by liu on 2018/1/3.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "LTitleView.h"
#import "toolMacro.h"
#import "UIView+UIViewHelper.h"
#import "UIButton+WGBCustom.h"
#import <UIImageView+WebCache.h>

@interface LTitleView()
{
    NSArray<MyLinearLayout *> * llAry;
    BOOL                        middelClickSetup;
}
@end

@implementation LTitleView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        llAry = @[[MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz],
                  [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz],
                  [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz]];
        for (MyLinearLayout * ll in llAry)
        {
            [self addSubview:ll];
            ll.myCenterY = 0;
            ll.wrapContentSize = YES;
        }
        llAry[1].myCenterX = 0;
        llAry[2].rightPos.equalTo(self);
    }
    return self;
}

-(void)setSpace:(NSInteger)space
{
    for (MyLinearLayout * ll in llAry)
    {
        ll.subviewHSpace = space;
    }
}

-(void)addBtn:(UIButton *)btn tag:(NSInteger)tag needClick:(BOOL)nc layout:(MyLinearLayout *)ll
{
    [ll addSubview:btn];
    btn.myCenterY = 0;
    [btn sizeToFit];
    if (nc)
    {
        btn.tag = tag;
        [btn addTarget:self action:@selector(textClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

-(void)addImageView:(UIImageView *)iv tag:(NSInteger)tag needClick:(BOOL)nc layout:(MyLinearLayout *)ll
{
    [ll addSubview:iv];
    iv.myCenterY = 0;
    if (nc)
    {
        iv.tag = tag;
        [iv addTapGestureSelector:@selector(ivClick:) target:self];
    }
}

-(NSInteger)addImageAsset:(NSString *)asset location:(NSInteger)tvl needClick:(BOOL)nc
{
    if (tvl >= llAry.count) return NON_INDEX;
    MyLinearLayout * ll = llAry[tvl];
    NSInteger index = ll.subviews.count;
    //
    UIImageView * iv = OIV_STR(asset);
    [ll addSubview:iv];
    iv.mySize = PTTO6SIZE(iv.image.size);
    [self addImageView:iv tag:(tvl << 3) | (index & 7) needClick:nc layout:ll];
    return index;
}

-(NSInteger)addImageUrl:(NSString *)url location:(NSInteger)tvl needClick:(BOOL)nc
{
    if (tvl >= llAry.count) return NON_INDEX;
    MyLinearLayout * ll = llAry[tvl];
    NSInteger index = ll.subviews.count;
    //
    UIImageView * iv = ONEW(UIImageView);
    WEAKOBJ(iv);
    [iv sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
    {
        if (image)
        {
            weak_iv.mySize = PXTO6SIZE(image.size);
        }
    }];
    [self addImageView:iv tag:(tvl << 3) | (index & 7) needClick:nc layout:ll];
    return index;
}

-(NSInteger)addText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)tc location:(NSInteger)tvl needClick:(BOOL)nc
{
    if (tvl >= llAry.count) return NON_INDEX;
    MyLinearLayout * ll = llAry[tvl];
    NSInteger index = ll.subviews.count;
    //
    UIButton * btn = ONEW(UIButton);
    [btn setNormalTitle:text textColor:tc];
    btn.titleLabel.font = font;
    [self addBtn:btn tag:(tvl << 3) | (index & 7) needClick:nc layout:ll];
    return index;
}

-(UIView *)getViewWithIndex:(NSInteger)index location:(NSInteger)tvl
{
    if (tvl >= llAry.count) return nil;
    MyLinearLayout * ll = llAry[tvl];
    if (index >= ll.subviews.count) return nil;
    return ll.subviews[index];
}

-(UIView *)showViewWithIndex:(NSInteger)index location:(NSInteger)tvl isShow:(BOOL)isShow
{
    UIView * view = [self getViewWithIndex:index location:tvl];
    if (view)
    {
        view.hidden = !isShow;
    }
    return view;
}

-(UIView *)mdImageAsset:(NSString *)asset location:(NSInteger)tvl index:(NSInteger)index
{
    UIImageView * view = (UIImageView *) [self getViewWithIndex:index location:tvl];
    if (view)
    {
        view.image = OIMG_STR(asset);
        view.mySize = PTTO6SIZE(view.image.size);
    }
    return view;
}

-(UIView *)mdImageUrl:(NSString *)url location:(NSInteger)tvl index:(NSInteger)index
{
    UIImageView * view = (UIImageView *) [self getViewWithIndex:index location:tvl];
    if (view)
    {
        WEAKOBJ(view);
        [view sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
         {
             if (image)
             {
                 weak_view.mySize = PXTO6SIZE(image.size);
             }
         }];
    }
    return view;
}

-(UIView *)mdText:(NSString *)text location:(NSInteger)tvl index:(NSInteger)index
{
    UIButton * view = (UIButton *) [self getViewWithIndex:index location:tvl];
    if (view)
    {
        [view setNormalTitle:text];
    }
    return view;
}

-(void)removeAllByLocation:(NSInteger)tvl
{
    if (tvl >= llAry.count) return;
    MyLinearLayout * ll = llAry[tvl];
    [ll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma --------------------------------------------------------
-(void)ivClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag & 7;
    NSInteger tvl = tap.view.tag >> 3;
    if (self.delegate)
    {
        [self.delegate clickView:[self getViewWithIndex:index location:tvl] location:tvl index:index];
    }
}

-(void)textClick:(UIButton *)btn
{
    NSInteger index = btn.tag & 7;
    NSInteger tvl = btn.tag >> 3;
    if (self.delegate)
    {
        [self.delegate clickView:[self getViewWithIndex:index location:tvl] location:tvl index:index];
    }
}

@end
