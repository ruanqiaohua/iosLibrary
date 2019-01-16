//
//  TabView.m
//  UserApp
//
//  Created by liu on 2018/9/28.
//  Copyright © 2018年 ljh. All rights reserved.
//

#import "TabView.h"
#import "ImageViewAnimationHelper.h"
#import "ImgTxtBtn.h"
#import "toolMacro.h"
#import "category_inc.h"
#import "Utils.h"

@interface TabView()
{
    ImageViewAnimationHelper * helper;
}
@end

@implementation TabView

-(instancetype)initTitles:(NSArray<NSString *> *)titles textSize:(CGFloat)ts textColor:(UIColor *)tc textSelColor:(UIColor *)tsc imgTxtLoc:(NSInteger)itl icons:(NSArray<NSString *> *)icons selIcons:(NSArray<NSString *> *)selIcons lineHeight:(CGFloat)lh lineSelColor:(UIColor *)lsc lineColor:(UIColor *)lc lineWdithType:(NSInteger)lwt
{
    self = [super initWithOrientation:MyOrientation_Vert];
    self.maskIndex = 0xFF;
    if (self)
    {
        MyLinearLayout * llHorz = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
        llHorz.myHorzMargin = 0;
        llHorz.weight = 0.1;
        [self addSubview:llHorz];
        ////////////////////////////
        ImgTxtBtn * btn;
        UIFont * font = SYS_FONT(ts);
        for (NSInteger i = 0; i < titles.count; i++)
        {
            btn = ONEW(ImgTxtBtn);
            switch (itl)
            {
                case TV_IMG_TOP:
                    [btn setTopImageStr:icons ? icons[i] : nil topSelImgStr:selIcons ? selIcons[i] : nil bottomText:titles[i] font:font txtColor:tc txtSelColor:tsc space:PXTO6SW(10)];
                    break;
                case TV_IMG_LEFT:
                    [btn setLeftImageStr:icons ? icons[i] : nil leftSelImgStr:selIcons ? selIcons[i] : nil bottomText:titles[i] font:font txtColor:tc txtSelColor:tsc space:PXTO6SW(10)];
                    break;
                case TV_IMG_RIGHT:
                    [btn setRightImageStr:icons ? icons[i] : nil rightSelImgStr:selIcons ? selIcons[i] : nil bottomText:titles[i] font:font txtColor:tc txtSelColor:tsc space:PXTO6SW(10)];
                    break;
            }
            btn.myVertMargin = 0;
            btn.weight = 0.1;
            btn.tag = i;
            [btn addTapGestureSelector:@selector(tabClick:) target:self];
            [llHorz addSubview:btn];
            if (i == 0)
            {
                btn.isSelect = YES;
            }
        }
        UIView * line = ONEW(UIView);
        CGFloat w = lwt == LINE_WIDTH_TAB_WIDTH ? SCREEN_WIDTH / titles.count : [Utils calSizeWithText:titles[0] font:font].width;
        line.myWidth = w;
        line.myHeight = lh;
        line.backgroundColor = lsc;
        [self addSubview:line];

        helper = ONEW(ImageViewAnimationHelper);
        [helper setView:line moveNum:titles.count lineWidth:w];
    }
    return self;
}

-(void)tabClick:(UITapGestureRecognizer *)tap
{
    if (self.delegate)
    {
        [self.delegate tabView:self tabIndex:tap.view.tag];
    }
    if (tap.view.tag >= self.maskIndex)return;
    [helper startMoveNum:tap.view.tag];
}

@end
