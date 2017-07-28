//
//  RadioGroup.m
//  yezhu
//
//  Created by liu on 2017/6/15.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "RadioGroup.h"
#import "UIButton+WGBCustom.h"
#import "UIView+UIViewHelper.h"
#import "toolMacro.h"

@interface RadioGroup()
{
    UIView                      * hLineView;
    NSMutableArray<UIButton *>  * btnAry;
    id                          exeTarget;
    SEL                         exeAction;
    NSInteger                   curIndex;
}
@end

@implementation RadioGroup

-(instancetype) initTitles:(NSArray<NSString *> *)titles textSize:(CGFloat)ts textColor:(UIColor *)tc selTextColor:(UIColor *)stc
                hLineColor:(UIColor *)hlc hSelLineColor:(UIColor *)hslc isLineTop:(BOOL)isTop hLineHeight:(CGFloat)hLineHeight
                target:(id)target action:(SEL)action
{
    BOOL isHLine = hlc != nil;
    exeTarget = target;
    exeAction = action;
    self = [super initWithOrientation:isHLine ? MyOrientation_Vert : MyOrientation_Horz];
    if (self)
    {
        btnAry = ONEW(NSMutableArray);
        if (isHLine)
        {
            MyLinearLayout * ll = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
            [self createBtnTitles:titles textSize:ts textColor:tc selTextColor:stc target:target action:action rootView:ll];
            
            ll.myHorzMargin = 0;
            ll.weight = 1;
            
            if (isTop)
            {
                [self createHLineRoothLineColor:hlc hSelLineColor:hslc hLineHeight:hLineHeight radioCount:titles.count];
                ll.myTop = hLineHeight;
                [self addSubview:ll];
            }else
            {
                [self addSubview:ll];
                [self createHLineRoothLineColor:hlc hSelLineColor:hslc hLineHeight:hLineHeight radioCount:titles.count];
            }
        }else
        {
            [self createBtnTitles:titles textSize:ts textColor:tc selTextColor:stc target:target action:action rootView:self];
        }
    }
    return self;
}

-(void)createHLineRoothLineColor:(UIColor *)hlc hSelLineColor:(UIColor *)hslc hLineHeight:(CGFloat)hLineHeight radioCount:(NSInteger)count
{
    self.backgroundColor = hlc;
    hLineView = ONEW(UIView);
    hLineView.backgroundColor = hslc;
    [self addSubview:hLineView];
    hLineView.myLeft = 0;
    hLineView.myHeight = hLineHeight;
    hLineView.widthSize.equalTo(self).multiply(1.0f / count);
}

-(void)createBtnTitles:(NSArray<NSString *> *)titles textSize:(CGFloat)ts textColor:(UIColor *)tc selTextColor:(UIColor *)stc target:(id)target action:(SEL)action rootView:(UIView *)rv
{
    UIButton * btn;
    for (NSInteger i = 0; i < titles.count; i++)
    {
        btn = ONEW(UIButton);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        btn.textSize = ts;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:stc forState:UIControlStateSelected];
        [btn setTitleColor:tc forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //
        [rv addSubview:btn];
        btn.weight = 1;
        btn.myVertMargin = 0;
        [btnAry addObject:btn];
    }
    curIndex = 0;
    btnAry[0].selected = YES;
}

-(void)btnClick:(UIButton *)sender
{
    btnAry[curIndex].selected = NO;
    sender.selected = YES;
    curIndex = sender.tag;
    if (hLineView)
    {
        hLineView.myLeft = curIndex * (self.width / btnAry.count);
    }
    SuppressPerformSelectorLeakWarning([exeTarget performSelector:exeAction withObject:sender]);
}

@end
