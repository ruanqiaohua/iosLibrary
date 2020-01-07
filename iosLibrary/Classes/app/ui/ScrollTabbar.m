//
//  SerollTabbar.m
//  iosLibrary
//
//  Created by liu on 2019/5/24.
//  Copyright © 2019年 liu. All rights reserved.
//

#import "ScrollTabbar.h"
#import "ImageViewAnimationHelper.h"
#import "ImgTxtBtn.h"
#import "toolMacro.h"
#import "category_inc.h"
#import "Utils.h"

#define BTN_TAG_BASE    0xff00

@interface ScrollTabbar()
{
    UIView          * lineView;
    BOOL            isLoad;
}
@end

@implementation ScrollTabbar

-(instancetype)init
{
    if (self = [super init])
    {
        self.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *))
        {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        }
        self.bounces = NO;
        _selectedIndex = -1;
        _lineSkipIndex = -1;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (isLoad)
    {
        return;
    }
    isLoad = YES;
    [self commitInit];
}

-(void)commitInit
{
    if (!isLoad)
    {
        return;
    }
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    lineView = nil;
    [self createTabbar];
}

-(void)createTabbar
{
    MyLinearLayout * llHorz = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    llHorz.myHeight = self.bounds.size.height - self.lineHeight;
    llHorz.widthSize.lBound(self.widthSize, 1, 1);
    [self addSubview:llHorz];
    ImgTxtBtn * btn;
    UIFont * font = SYS_FONT(self.textPXSize);
    CGFloat w = self.titles.count > 5 ? self.bounds.size.width / 4.5f : self.bounds.size.width / self.titles.count;
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.titles.count; i++)
    {
        btn = ONEW(ImgTxtBtn);
        btn.frame = CGRectMake(i * w, 0, w, self.bounds.size.height - self.lineHeight);
        if (self.titles[i].length > self.titles[index].length)
        {
            index = i;
        }
        switch (self.iconTxtLocation)
        {
            case ST_IMG_TOP:
                [btn setTopImageStr:self.icons ? self.icons[i] : nil topSelImgStr:self.selectIcons ? self.selectIcons[i] : nil bottomText:self.titles[i] font:font txtColor:self.textColor txtSelColor:self.textSelectColor space:self.iconTxtSpace];
                break;
            case ST_IMG_LEFT:
                [btn setLeftImageStr:self.icons ? self.icons[i] : nil leftSelImgStr:self.selectIcons ? self.selectIcons[i] : nil rightText:self.titles[i] font:font txtColor:self.textColor txtSelColor:self.textSelectColor space:self.iconTxtSpace];
                break;
            case ST_IMG_RIGHT:
                [btn setRightImageStr:self.icons ? self.icons[i] : nil rightSelImgStr:self.selectIcons ? self.selectIcons[i] : nil leftText:self.titles[i] font:font txtColor:self.textColor txtSelColor:self.textSelectColor space:self.iconTxtSpace];
                break;
        }
        btn.tag = BTN_TAG_BASE + i;
        [btn addTapGestureSelector:@selector(tabBarClick:) target:self];
        [llHorz addSubview:btn];
    }
    self.contentSize = CGSizeMake(w * self.titles.count, self.bounds.size.height);
    //Line
    MyLinearLayout * llLine = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    llLine.myWidth = self.contentSize.width;
    llLine.myHeight = self.lineHeight;
    llLine.myTop = self.bounds.size.height - self.lineHeight;
    llLine.backgroundColor = self.lineColor;
    [self addSubview:llLine];
    
    if (self.lineWidth > 0)
    {
        w = self.lineWidth;
    }else if (self.isLineWidthEqualText)
    {
        w = [Utils calSizeWithText:self.titles[index] font:font].width;
    }
    [self createLineWithLineWidth:w view:llLine];
    WEAKOBJ(self);
    [self performUIAsync:^{
        weak_self.selectedIndex = 0;
    } sec:0.3];
    
}

-(void)createLineWithLineWidth:(CGFloat)width view:(UIView *)view
{
    lineView = ONEW(UIView);
    lineView.backgroundColor = self.lineSelectColor;
    lineView.frame = CGRectMake(0, 0, width, self.lineHeight);
    [view addSubview:lineView];
}

-(void)tabBarClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - BTN_TAG_BASE;
    self.selectedIndex = index;
    if (self.stbDelegate)
    {
        [self.stbDelegate scrollTabbar:self tabSelectIndex:index];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex != selectedIndex)
    {
        if (_selectedIndex >= 0)
        {
            ImgTxtBtn * from = (ImgTxtBtn *)[self viewWithTag:BTN_TAG_BASE + _selectedIndex];
            from.isSelect = NO;
        }

        if (selectedIndex >= 0 && selectedIndex < self.titles.count)
        {
            ImgTxtBtn * to = (ImgTxtBtn *)[self viewWithTag:BTN_TAG_BASE + selectedIndex];
            to.isSelect = YES;

            CGRect rc = to.frame;
                //选中的居中显示
            rc = CGRectMake(CGRectGetMidX(rc) - self.bounds.size.width/2.0f, rc.origin.y, self.bounds.size.width, rc.size.height);

            [self scrollRectToVisible:rc animated:YES];

            if (self.lineSkipIndex != selectedIndex)
            {
                // line view
                CGRect trackRc = [self convertRect:to.bounds fromView:to];
                CGFloat offx = 0;
                //if (self.isLineWidthEqualText)
                {
                    offx = (CGRectGetWidth(to.frame) - CGRectGetWidth(lineView.frame)) / 2;
                }
                lineView.frame = CGRectMake(trackRc.origin.x + offx, lineView.frame.origin.y, CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.bounds));
            }
        }
        _selectedIndex = selectedIndex;
    }
}

-(void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
    [self commitInit];
}

@end
