//
//  LViewPager.m
//  cjcr
//
//  Created by liu on 2017/2/23.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import "LViewPager.h"
#import "toolMacro.h"
#import "category_inc.h"
#import <WZLBadgeImport.h>

#define TAB_HEIGHT              PTTO6SH(50)
#define TAB_TEXT_FONT_SIZE      15
#define TAB_TAG_START           0x100

#define TAB_VLINE_PER           0.6
#define TAB_HLINE_HEIGTH        1 //水平线高度
#define TAB_VLINE_WIDTH         1 //垂直线宽度
#define TAB_SELECT_LINE_HEIGHT  3 //选中线高度

@interface LViewPager()<UIScrollViewDelegate>
{
    UIScrollView    * svRoot;
    UIView          * llContent;
    UIView          * curView;
    CGPoint         downPoint;
    CGFloat         oldWidth;
    CGFloat         oldHeight;
}

@property(weak, nonatomic) BaseViewController * hostVC;
@property(strong, nonatomic) UIView * tabView;
@property(strong, nonatomic) NSArray * vcs;
//tab
@property(strong, nonatomic) NSArray * tabs;
@property(strong, nonatomic) NSArray * tabIcons;
@property(strong, nonatomic) NSArray * tabSelectIcons;
//line
@property(strong, nonatomic) UIView * viewHLine;
@property(strong, nonatomic) UIView * viewSelectLine;

@property(strong, nonatomic) NSArray * tipCounts;

@end

@implementation LViewPager

-(UIView *)viewHLine
{
    if (!_viewHLine)
    {
        _viewHLine = ONEW(UIView);
    }
    return _viewHLine;
}

-(UIView *)viewSelectLine
{
    if (!_viewSelectLine)
    {
        _viewSelectLine = ONEW(UIView);
    }
    return _viewSelectLine;
}

-(UIView *)tabView
{
    if (!_tabView)
    {
        _tabView = ONEW(UIView);
    }
    return _tabView;
}

-(UIFont *)tabTextFont
{
    if (!_tabTextFont)
    {
        _tabTextFont = [UIFont systemFontOfSize:TAB_TEXT_FONT_SIZE];
    }
    return _tabTextFont;
}

-(void)layoutSubviews
{
    if (oldWidth != self.width || oldHeight != self.height)
    {
        oldWidth = self.width;
        oldHeight = self.height;
        [self loadData];
    }
}

-(void)setEnabledScroll:(BOOL)enabledScroll
{
    _enabledScroll = enabledScroll;
    svRoot.scrollEnabled = enabledScroll;
}

-(instancetype)initHostVC:(BaseViewController *)vc tabs:(NSArray *)tabs subVC:(NSArray *)svc
{
    self = [super init];
    if (self)
    {
        self.vcs = svc;
        self.tabs = tabs;
        self.hostVC = vc;
        [self initView];
        [self setDefault];
    }
    return self;
}

-(void)setDefault
{
    self.tabLocation = TAB_LOC_BOTTOM;
    self.selectIndex = 0;
    self.tabBgColor = [UIColor whiteColor];
    self.tabSelectedBgColor = self.tabBgColor;
    self.horLineColor = UIColorFromRGBA(0xffdcdcdc);
    self.vertLineColor = self.horLineColor;
    self.tabTextColor = self.horLineColor;
    self.tabSelectedTextColor = [UIColor blackColor];
    self.tabTextFont = [UIFont systemFontOfSize:18];
    self.tabHeight = TAB_HEIGHT;
    self.showVLine = YES;
    self.showHLine = YES;
    self.tabSelectedArrowColor = UIColorFromRGBA(0xff0c86ed);
    self.showTabSelectedArrowLine = YES;
    self.showAnimationMoveArrowLine = YES;
}

-(void)initView
{
    svRoot = ONEW(UIScrollView);
    svRoot.showsHorizontalScrollIndicator = NO;
    svRoot.showsVerticalScrollIndicator = NO;
    svRoot.pagingEnabled = YES;
    svRoot.bounces = NO;
    svRoot.delegate = self;
    svRoot.scrollEnabled = NO;
    [self addSubview:svRoot];
    
    llContent = ONEW(UIView);
    llContent.backgroundColor = [UIColor whiteColor];
    [svRoot addSubview:llContent];
    
}

-(void)setupHLine
{
    self.viewHLine.backgroundColor = self.horLineColor;
    self.viewHLine.frame = CGRectMake(0, (!self.tabLocation) * (self.tabHeight - TAB_HLINE_HEIGTH), self.width, TAB_HLINE_HEIGTH);
    [self.tabView addSubview:self.viewHLine];
    self.viewHLine.hidden = !self.showHLine;
}

-(CGRect)setupTab
{
    CGRect tabFrame = CGRectZero;
    if (self.tabs)
    {
        tabFrame.size = CGSizeMake(self.width, self.tabHeight);
        tabFrame.origin = CGPointMake(0, self.tabLocation * (self.height - self.tabHeight) + (!self.tabLocation) * 20);
        self.tabView.frame = tabFrame;
        [self addSubview:self.tabView];
        
        UIButton * btn;
        CGFloat btnWidth = tabFrame.size.width / self.tabs.count;
        UIView * vv;
        CGFloat vhHeight = tabFrame.size.height * TAB_VLINE_PER;
        for (NSUInteger i = 0; i < self.tabs.count; i++)
        {
            btn = ONEW(UIButton);
            btn.titleLabel.font = self.tabTextFont;
            btn.backgroundColor = self.tabBgColor;
            btn.tag = TAB_TAG_START + i;
            
            [btn setTitleColor:self.tabTextColor forState:UIControlStateNormal];
            [btn setTitleColor:self.tabSelectedTextColor forState:UIControlStateSelected];
            [btn setTitle:self.tabs[i] forState:UIControlStateNormal];
            
            btn.frame = CGRectMake(i * btnWidth, 0, btnWidth, self.tabHeight);
            [btn addTarget:self action:@selector(tabClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabView addSubview:btn];

            //vert line
            if (self.showVLine && i > 0)
            {
                vv = ONEW(UIView);
                vv.backgroundColor = self.horLineColor;
                vv.frame = CGRectMake(0, (self.tabHeight - vhHeight) / 2, TAB_VLINE_WIDTH, vhHeight);
                [btn addSubview:vv];
            }

            if (self.tabIcons)
            {
                UIImage * img = OIMG_STR(self.tabIcons[i]);
                img = [img rescaleImageToSize:PTTO6SIZE(img.size)];
                [btn setImage:img forState:UIControlStateNormal];
            }
            if (self.tabSelectIcons)
            {
                UIImage * img = OIMG_STR(self.tabSelectIcons[i]);
                img = [img rescaleImageToSize:PTTO6SIZE(img.size)];
                [btn setImage:img forState:UIControlStateSelected];
            }
            
            [btn titleBelowTheImageWithSpace:1];
        }
        ((UIButton *)[self.tabView viewWithTag:TAB_TAG_START + self.selectIndex]).selected = YES;
        [self setupHLine];
        [self setupSelectLine];
    }
    return tabFrame;
}

-(void)setTitleIcons:(NSArray *)icons selectIcons:(NSArray *)selIcons
{
    self.tabIcons = icons;
    self.tabSelectIcons = selIcons;
}

-(void)setupSelectLine
{
    self.viewSelectLine.backgroundColor = self.tabSelectedArrowColor;
    CGFloat w = self.width / self.tabs.count;
    self.viewSelectLine.frame = CGRectMake(self.selectIndex * w, self.tabHeight - TAB_SELECT_LINE_HEIGHT, self.width / self.tabs.count, TAB_SELECT_LINE_HEIGHT);
    [self.tabView addSubview:self.viewSelectLine];
    self.viewSelectLine.hidden = !self.showTabSelectedArrowLine;
}

-(void)loadData
{
    //self.frame = self.hostVC.view.bounds;
    UIView * view;
    
    CGRect tabFrame = [self setupTab];
    svRoot.frame = CGRectMake(0, (!self.tabLocation) * tabFrame.size.height, self.width, self.height - tabFrame.size.height);
    llContent.frame = CGRectMake(0, 0, self.tabs.count * self.width, svRoot.height);
    for (NSUInteger i = 0; i < self.vcs.count; i++)
    {
        if ([self.vcs[i] isKindOfClass:[BaseViewController class]])
        {
            [self.hostVC addChildViewController:self.vcs[i]];
            view = ((BaseViewController *)self.vcs[i]).view;
        }else
        {
            view = self.vcs[i];
        }
        view.frame = CGRectMake(i * self.width, 0, svRoot.width, svRoot.height);
        [llContent addSubview:view];
    }
    svRoot.contentSize = CGSizeMake(llContent.width, 0);
    [self enterViewController];
}

- (void)setSelectTabIndex:(NSUInteger)index
{
    _selectIndex = index;
    if (self.tabs)
    {
        UIButton * btn;
        for (NSUInteger i = 0; i < self.tabs.count; i++)
        {
            btn = (UIButton *)[self.tabView viewWithTag:TAB_TAG_START + i];
            btn.backgroundColor = _tabBgColor;
            btn.selected = NO;
        }
        btn = (UIButton *)[self.tabView viewWithTag:TAB_TAG_START + index];
        btn.backgroundColor = _tabSelectedBgColor;
        btn.selected = YES;
        //
        if (self.showTabSelectedArrowLine)
        {
            if (_showAnimationMoveArrowLine)
            {
                WEAKOBJ(self);
                [UIView animateWithDuration:0.3 animations:^{
                    STRONGOBJ(self);
                    CGRect frame = self->_viewSelectLine.frame;
                    frame.origin.x = btn.frame.origin.x;
                    self->_viewSelectLine.frame = frame;
                }];
            }else
            {
                CGRect frame = _viewSelectLine.frame;
                frame.origin.x = btn.frame.origin.x;
                _viewSelectLine.frame = frame;
            }
        }
    }
    [self.vcs[index] performSelectorOnMainThread:@selector(viewWillAppear:) withObject:@YES waitUntilDone:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int offSetX = scrollView.contentOffset.x;
    NSUInteger index = offSetX / self.width;
    [self setSelectTabIndex:index];
}

-(void)tabClick:(UIButton *)sender
{
    NSInteger index = sender.tag - TAB_TAG_START;
    if (self.delegate && ![self.delegate viewPager:self selectIndex:index])
    {
        return;
    }
    if (_showAnimationMoveArrowLine)
    {
        [UIView beginAnimations:@"navTab" context:nil];
        [UIView setAnimationDuration:0.3];
        [self setSelectTabIndex:index];
        svRoot.contentOffset = CGPointMake(index * self.frame.size.width, 0);
        [UIView commitAnimations];
    }else{
        [self setSelectTabIndex:index];
        svRoot.contentOffset = CGPointMake(index * self.frame.size.width, 0);
    }
}

-(void)enterViewController
{
    [self performUIAsync:^{
        [self.vcs[self.selectIndex] performSelectorOnMainThread:@selector(viewWillAppear:) withObject:@YES waitUntilDone:YES];
    } sec:0.1];
}
//显示右上角红点数量，-1 为红点， 0 为去掉红点， 大于0 为红点中数字
-(void)setTipsNumber:(NSInteger)number titleIndex:(NSUInteger)ti;
{
    if (self.tabs.count <= ti) return;
    UIButton * btn = [self.tabView viewWithTag:TAB_TAG_START + ti];
    if (btn == NULL)return;
    if (number == 0)
    {
        [btn clearBadge];
    }else
    {
        btn.badgeCenterOffset = CGPointMake(-20, 20);
        [btn showBadgeWithStyle:number < 0 ? WBadgeStyleRedDot : WBadgeStyleNumber value:number animationType:WBadgeAnimTypeNone];
    }
}

-(void)setTipsBageCenterOffset:(CGPoint)cp
{
    for (int i = 0; i < self.tabs.count; i++)
    {
        [self.tabView viewWithTag:TAB_TAG_START + i].badgeCenterOffset = cp;
    }
}

-(NSInteger)viewPagerCount
{
    return self.tabs.count;
}

@end
