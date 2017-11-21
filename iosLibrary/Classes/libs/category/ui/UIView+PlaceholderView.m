//
//  UIView+PlaceholderView.m
//  iosLibrary
//
//  Created by liu on 2017/10/12.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "UIView+PlaceholderView.h"
#import <objc/runtime.h>
#import <MyLayout.h>
#import "toolMacro.h"

@interface UIView ()

/** 用来记录UIScrollView最初的scrollEnabled */
@property (nonatomic, assign) BOOL ljh_originalScrollEnabled;
@property (nonatomic, strong) UIView * ljh_placeholderView;

@end

static void * dictViewsKey = &dictViewsKey;
static void * placeholderViewKey = &placeholderViewKey;
static void * originalScrollEnabledKey = &originalScrollEnabledKey;

@implementation UIView (PlaceholderView)

-(BOOL)ljh_originalScrollEnabled
{
    return [objc_getAssociatedObject(self, &originalScrollEnabledKey) boolValue];
}

- (void)setLjh_originalScrollEnabled:(BOOL)ljh_originalScrollEnabled
{
    objc_setAssociatedObject(self, &originalScrollEnabledKey, @(ljh_originalScrollEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)ljh_placeholderView
{
    return objc_getAssociatedObject(self, &placeholderViewKey);
}

- (void)setLjh_placeholderView:(UIView *)cq_placeholderView
{
    objc_setAssociatedObject(self, &placeholderViewKey, cq_placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setPlaceholderView:(UIView *)view type:(NSInteger)type
{
    NSMutableDictionary * dict = objc_getAssociatedObject(self, &dictViewsKey);
    if (!dict)
    {
        dict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &dictViewsKey, dict,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    dict[@(type)] = view;
}

-(void)showPlaceholderViewType:(NSInteger)type
{
    NSMutableDictionary * dict = objc_getAssociatedObject(self, &dictViewsKey);
    if (dict)
    {
        UIView * view = dict[@(type)];
        if (!view) return;
        //
        if (self.ljh_placeholderView)
        {
            [self.ljh_placeholderView removeFromSuperview];
            self.ljh_placeholderView = nil;
        }

        self.ljh_placeholderView = view;
        //
        [view makeLayout:^(MyMaker *make) {
            make.width.height.equalTo(self);
        }];
        [self addSubview:view];
        //
        if ([self isKindOfClass:[UIScrollView class]])
        {
            UIScrollView * scrollView = (UIScrollView *)self;
            self.ljh_originalScrollEnabled = scrollView.scrollEnabled;
            scrollView.scrollEnabled = NO;
        }
    }
}

-(void)removePlaceholderView
{
    if (self.ljh_placeholderView)
    {
        [self.ljh_placeholderView removeFromSuperview];
        self.ljh_placeholderView = nil;
    }
    // 复原UIScrollView的scrollEnabled
    if ([self isKindOfClass:[UIScrollView class]])
    {
        UIScrollView *scrollView = (UIScrollView *)self;
        scrollView.scrollEnabled = self.ljh_originalScrollEnabled;
    }
}

@end
