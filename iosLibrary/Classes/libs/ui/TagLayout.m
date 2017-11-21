//
//  TagLayout.m
//  iosLibrary
//
//  Created by liu on 2017/11/7.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "TagLayout.h"
#import "toolMacro.h"
#import "UIImage+Color.h"
#import "UIView+UIViewHelper.h"

const NSInteger VIEW_TAG_START = 0xff1010;

@implementation TagInfo
@end

@implementation TagStyle

+(instancetype)initNlBgColor:(UIColor *)nlBg
               nlBorderColor:(UIColor *)nlBc
                 nlTextColor:(UIColor *)nlTc
                  nlTextFont:(UIFont *)nlTf
                  selBgColor:(UIColor *)selBg
              selBorderColor:(UIColor *)selBc
                selTextColor:(UIColor *)selTc
                 borderWidth:(CGFloat)bw flagMinWidth:(CGFloat)fmw borderRadius:(CGFloat)br
{
    TagStyle * fbs = [[TagStyle alloc] init];
    fbs.nlBgColor = nlBg;
    fbs.nlTextColor = nlTc;
    fbs.nlTextFont = nlTf;
    fbs.nlBorderColor = nlBc;
        //
    fbs.selBgColor = selBg;
    fbs.selTextColor = selTc;
    fbs.selBorderColor = selBc;
        //
    fbs.borderWidth = bw;
    fbs.flagMinWidth = fmw;
    fbs.borderRadius = br;
    return fbs;
}

@end

@interface TagLayout()
{
    NSMutableArray<TagInfo *>   * tagAry;
    TagStyle                    * curTagStyle;
}
@end

@implementation TagLayout

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        tagAry = [[NSMutableArray alloc] init];
        self.backgroundColor = UIColorFromRGBA(0xB2000000);
        _flowLayout = [[MyFlowLayout alloc] init];
        _flowLayout.backgroundColor = [UIColor whiteColor];
        _flowLayout.myTop = _flowLayout.myLeft = 0;
        _flowLayout.widthSize.equalTo(self);
        _flowLayout.wrapContentHeight = YES;
        _flowLayout.subviewSpace = PXTO6SW(50);
        _flowLayout.padding = UIEdgeInsetsMake(PXTO6SW(50), PXTO6SW(30), PXTO6SW(50), PXTO6SW(30));
        [self addSubview:_flowLayout];
        [self addTapGestureSelector:@selector(selfClick:) target:self];
        _curSelIndex = -1;
    }
    return self;
}

-(void)setCurSelIndex:(NSInteger)curSelIndex
{
    if (_curSelIndex != curSelIndex)
    {
        //sel
        UIButton * curBtn = [self viewWithTag:VIEW_TAG_START + curSelIndex];
        curBtn.selected = YES;
        if (curTagStyle.selBorderColor)
        {
            curBtn.layer.borderColor = [curTagStyle.selBorderColor CGColor];
            curBtn.layer.borderWidth = curTagStyle.borderWidth;
        }

        if (_curSelIndex > -1)
        {
            UIButton * curBtn = [self viewWithTag:VIEW_TAG_START + _curSelIndex];
            curBtn.selected = NO;
            if (curTagStyle.nlBorderColor)
            {
                curBtn.layer.borderColor = [curTagStyle.nlBorderColor CGColor];
            }else
            {
                curBtn.layer.borderWidth = 0;
            }
        }
        _curSelIndex = curSelIndex;
    }
}

-(void)addTags:(NSArray<TagInfo *> *)tags tagStyle:(TagStyle *)ts
{
    if (tags.count == 0)return;
    [tagAry addObjectsFromArray:tags];
    UIButton * btn;
    curTagStyle = ts;
    for (NSInteger i = 0; i < tags.count; i++)
    {
        btn = [[UIButton alloc] init];
        //背景
        btn.tag = VIEW_TAG_START + i;
        if (ts.selBgColor)
        {
            [btn setBackgroundImage:[UIImage imageWithColor:ts.selBgColor] forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:ts.nlBgColor] forState:UIControlStateNormal];
        }else
        {
            btn.backgroundColor = ts.nlBgColor;
        }
        //边框
        if (ts.nlBorderColor)
        {
            btn.layer.borderColor = [ts.nlBorderColor CGColor];
        }
        btn.layer.borderWidth = ts.borderWidth;
        btn.layer.cornerRadius = ts.borderRadius;
            //文本
        [btn setTitleColor:ts.nlTextColor forState:UIControlStateNormal];
        if (ts.selTextColor)
        {
            [btn setTitleColor:ts.selTextColor forState:UIControlStateSelected];
        }
        btn.titleLabel.font = ts.nlTextFont;
        [btn setTitle:tags[i].name forState:UIControlStateNormal];
            //
        btn.widthSize.equalTo(btn.widthSize).add(10).min(ts.flagMinWidth);
        btn.heightSize.equalTo(btn.heightSize).add(10); //高度根据自身的内容再增加10
        [btn sizeToFit];
        [btn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        [_flowLayout addSubview:btn];
    }
}

-(void)removeAllTag
{
    [_flowLayout.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

-(void)tagClick:(UIButton *)sender
{
    self.curSelIndex = sender.tag - VIEW_TAG_START;
    if (self.delegate)
    {
        [self.delegate clickTagInfo:tagAry[self.curSelIndex]];
    }
}

-(void)selfClick:(id)sender
{
    self.hidden = YES;
}

@end
