//
//  TitleViewEx.m
//  cjcr
//
//  Created by liu on 2017/1/19.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import "TitleViewEx.h"
#import "toolMacro.h"
#import <UIKit/UIKit.h>
#import <UIButton+WebCache.h>
#import <UIView+WZLBadge.h>

@interface BtnInfo : NSObject

@property(assign,nonatomic) int execType;
@property(strong,nonatomic) NSDictionary * param;

@end

@implementation BtnInfo
@end

#define HOR_SPACE   PTTO6SH(10)

@interface TitleViewEx()
{
    UIButton                            * btnExit;
    UIButton                            * btnTitle;
    UIView                              * line;
    //
    MyLinearLayout                      * llLeft;
    MyLinearLayout                      * llRight;
    //
    NSMutableArray                      * btnParamArray;
    NSMutableArray                      * btnArray;
    int                                 btnCounter;
}
@end

@implementation TitleViewEx

-(void)initExitBtn
{
    btnExit = ONEW(UIButton);
    btnExit.hidden = YES;
    btnExit.leftPos.equalTo(@0);
    btnExit.centerYPos.equalTo(btnTitle);
    [self addSubview:btnExit];
    [btnExit addTarget:self action:@selector(exit_click:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initTitleBtn
{
    btnTitle = ONEW(UIButton);
    btnTitle.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    btnTitle.titleLabel.numberOfLines = 1;
    [btnTitle addTarget:self action:@selector(title_click:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initView
{
    self.insetsPaddingFromSafeArea = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    [self initTitleBtn];
    [self initExitBtn];
    //
    llLeft = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    [llLeft makeLayout:^(MyMaker *make) {
        make.left.equalTo(btnExit.rightPos);
        make.centerY.equalTo(btnTitle);
        make.height.equalTo(btnTitle);
    }];
    llLeft.wrapContentWidth = YES;
    [self addSubview:llLeft];
    //
    llRight = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    llRight.wrapContentWidth = YES;
    
    [llRight makeLayout:^(MyMaker *make) {
        make.right.equalTo(self.rightPos);
        make.centerY.equalTo(btnTitle);
        make.height.equalTo(llLeft);
    }];
    [self addSubview:llRight];
    //
    btnParamArray = [[NSMutableArray alloc] init];
    btnArray = [[NSMutableArray alloc] init];
    //
    line = [[UIView alloc] init];
    line.bottomPos.equalTo(self.bottomPos);
    line.leftPos.equalTo(self.leftPos);
    line.rightPos.equalTo(self.rightPos);
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initView];
    }
    return self;
}

+(instancetype)createTitleView
{
    return ONEW(TitleViewEx);
}

-(void)setTitle:(NSString *)title
{
    [btnTitle setTitle:title forState:UIControlStateNormal];
}

-(void)setTitle:(NSString *)title titleFont:(UIFont *)tf titleColor:(UIColor *)tc
{
    [self setTitle:title titleFont:tf titleColor:tc titleAlignment:TITLE_ALIG_MIDDLE];
}

-(void)setTitle:(NSString *)title titleFont:(UIFont *)tf titleColor:(UIColor *)tc titleAlignment:(int)ta
{
    [btnTitle removeFromSuperview];
    //
    [btnTitle setTitle:title forState:UIControlStateNormal];
    [btnTitle setTitleColor:tc forState:UIControlStateNormal];
    btnTitle.titleLabel.font = tf;
    //
    if (ta == TITLE_ALIG_LEFT)
    {
        btnTitle.leftPos.equalTo(llLeft.rightPos).offset(HOR_SPACE);
        btnTitle.titleLabel.textAlignment = NSTextAlignmentLeft;
    }else
    {
        btnTitle.centerXPos.equalTo(self.centerXPos);
        btnTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    btnTitle.wrapContentSize = YES;
    btnTitle.centerYPos.equalTo(self.centerYPos).offset(SYSTEM_STATUS_HEIGHT / 2);
    [self addSubview:btnTitle];
    btnTitle.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *v)
    {
        NSLog(@"------------- btnTitle t = %f, h = %f",v.frame.origin.y,v.frame.size.height);
    };
}

-(void)setExitImgStr:(NSString *)eis
{
    btnExit.hidden = eis == nil;
    if (eis == nil) return;
    BOOL isHttp = [eis hasPrefix:@"http"];
    if (isHttp)
    {
        [btnExit sd_setImageWithURL:[NSURL URLWithString:eis] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image)
            {
                btnExit.mySize = PTTO6SIZE(image.size);
            }
        }];
    }else
    {
        UIImage * image = [UIImage imageNamed:eis];
        [btnExit setBackgroundImage:image forState:UIControlStateNormal];
        btnExit.mySize = PTTO6SIZE(image.size);
    }
}

/*****************************************************************/
-(void)addButton:(UIButton *)btn btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et
{
    btn.myCenterY = 0;
    if (bl == TITLE_BTN_LEF)
    {
        [llLeft addSubview:btn];
        [btn addTarget:self action:@selector(btn_left_click:) forControlEvents:UIControlEventTouchUpInside];
    }else
    {
        [llRight addSubview:btn];
        [btn addTarget:self action:@selector(btn_right_click:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    btn.tag = btnCounter++;
    BtnInfo * bi = [[BtnInfo alloc] init];
    bi.param = param;
    bi.execType = et;
    [btnParamArray addObject:bi];
    [btnArray addObject:btn];
}

-(void)addButtonWithImage:(NSString *)imgUrl btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et
{
    UIButton * btn = [[UIButton alloc] init];
    [self loadBtnImageUrl:imgUrl btn:btn];
    [self addButton:btn btnLoc:bl param:param execType:et];
}

-(void)addButtonWithText:(NSString *)text btnTextColor:(UIColor *)tc font:(UIFont *)font btnLoc:(int)bl param:(NSDictionary *)param execType:(int)et
{
    UIButton * btn = [[UIButton alloc] init];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:tc forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    [btn sizeToFit];
    if (bl == TITLE_BTN_RIGHT)
    {
        btn.myRight = PTTO6SW(HOR_SPACE);
    }else
    {
        btn.myLeft = PTTO6SW(HOR_SPACE);
    }
    [self addButton:btn btnLoc:bl param:param execType:et];
}

-(void)loadBtnImageUrl:(NSString *)imgUrl btn:(UIButton *)btn
{
    if ([imgUrl hasPrefix:@"http"])
    {
        __weak UIButton * tmp = btn;
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            if (image)
            {
                CGSize size = image.size;
                size.width = size.width / 3.0f;
                size.height = size.height / 3.0f;
                tmp.mySize = PTTO6SIZE(size);
            }
        }];
        
    }else
    {
        UIImage * img = [UIImage imageNamed:imgUrl];
        [btn setBackgroundImage:img forState:UIControlStateNormal];
        btn.mySize = PTTO6SIZE(img.size);
    }
}

//
-(void)mdBtnImgUrl:(NSString *)imgUrl btnIndex:(int)index
{
    if (index < btnArray.count)
    {
        [self loadBtnImageUrl:imgUrl btn:btnArray[index]];
    }
}

-(void)mdBtnText:(NSString *)text btnIndex:(int)index
{
    if (index < btnArray.count)
    {
        UIButton * btn = btnArray[index];
        [btn setTitle:text forState:UIControlStateNormal];
        [btn sizeToFit];
    }
}

-(void)showBadgeBtnIndex:(int)index
{
    if (index < btnArray.count)
    {
        UIButton * btn = btnArray[index];
        [btn showBadge];
    }
}

-(void)hiddenBadgeBtnIndex:(int)index
{
    if (index < btnArray.count)
    {
        UIButton * btn = btnArray[index];
        [btn clearBadge];
    }
}
//
-(void)setTitleViewBottomLineColor:(UIColor *)color lineHeight:(int)height
{
    [line removeFromSuperview];
    line.backgroundColor = color;
    line.myHeight = PTTO6SH(height);
    [self addSubview:line];
}

-(void)btn_left_click:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onTitleBtnClick:sender:param:execType:)])
    {
        BtnInfo * bi = btnParamArray[sender.tag];
        [self.delegate onTitleBtnClick:self sender:sender param:bi.param execType:bi.execType];
    }
}

-(void)btn_right_click:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onTitleBtnClick:sender:param:execType:)])
    {
        BtnInfo * bi = btnParamArray[sender.tag];
        [self.delegate onTitleBtnClick:self sender:sender param:bi.param execType:bi.execType];
    }
}

-(void)exit_click:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onTitleExitClick)])
    {
        [self.delegate onTitleExitClick];
    }
}

-(void)title_click:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onTitleClick)])
    {
        [self.delegate onTitleClick];
    }
}

-(void)clearTitleBtn:(int)btnLoc
{
    if (btnLoc == TITLE_BTN_ALL)
    {
        [btnParamArray removeAllObjects];
        for (UIButton * btn in btnArray)
        {
            [btn removeFromSuperview];
        }
        btnCounter = 0;
    }else
    {
        UIView * content = (btnLoc == TITLE_BTN_LEF ? llLeft : llRight);
        for (NSInteger i = content.subviews.count - 1; i > -1; i--)
        {
            [btnParamArray removeObjectAtIndex:[btnArray indexOfObject:content.subviews[i]]];
            [content.subviews[i] removeFromSuperview];
        }
    }
}

@end
