//
//  BaseViewController.m
//  test
//
//  Created by liu on 16/10/19.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+ViewControllerHelper.h"
#import "toolMacro.h"
#import "NSObject+NSObjectHelper.h"

static __weak BaseViewController                    * curr_vc;
static NSMutableArray<BaseViewController *>         * vc_set;
static BOOL                                         exitTo;
static __weak BaseViewController                    * exitToVC;

@implementation ShowInfo
@end

@interface BaseViewController()
{
    BOOL            isOnceWillAppear;
    BOOL            isOnceDidAppear;
}
@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.showInfo = ONEW(ShowInfo);
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

-(void)loadView
{
    if (![self onInitViewTime:INIT_TIME_LOAD_VIEW])
    {
        [super loadView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self onInitViewTime:INIT_TIME_DID_LOAD];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    curr_vc = self;
    //
    if (!isOnceWillAppear)
    {
        [self onInitViewTime:INIT_TIME_WILL_APPEAR];
        isOnceWillAppear = YES;
        if (!self.showInfo.isReturn)
        {
            [self onInitData:self.showInfo.data];
            self.showInfo.data = nil;
        }
    }
    //
    if (self.showInfo.isReturn)
    {
        [self onVCResult:self.showInfo.data];
        self.showInfo.isReturn = NO;
        self.showInfo.data = nil;
    }
    if (exitTo)
    {
        if (exitToVC != self)
        {
            NSUInteger index = [vc_set indexOfObject:self];
            if (index != NSNotFound)
            {
                self.showInfo.isShowAnimated = NO;
                [self closeWindowVC];
            }
        }else
        {
            if (self.showInfo.data)
            {
                [self onVCResult:self.showInfo.data];
                self.showInfo.data = nil;
            }
            exitTo = NO;
            exitToVC = nil;
        }
    }
    [self onWillEnter];
}

-(void)onWillEnter
{}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!isOnceDidAppear)
    {
        [self onInitViewTime:INIT_TIME_DID_APPEAR];
        isOnceDidAppear = YES;
    }
}

/*************        ViewControllerDelegate           *****************/
-(void)setReturnData:(NSDictionary *)data
{
    self.showInfo.data = data;
    self.showInfo.isReturn = YES;
}

/***********************************************************************/
-(void)lightStatusBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)darkStatusBar
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

/**********        static funaction           **************/
+(NSMutableArray *)getVCSet
{
    @synchronized([BaseViewController class])
    {
        if (!vc_set)
        {
            vc_set = ONEW(NSMutableArray);
        }
    }
    return vc_set;
}

+(void)showVC:(BaseViewController *)bvc showType:(NSUInteger)st isAnimated:(BOOL)anim withVC:(BaseViewController *)vc data:(NSDictionary *)data
{
    bvc.showInfo.isShowAnimated = anim;
    bvc.showInfo.isReturn = NO;
    bvc.showInfo.showType = st;
    bvc.showInfo.data = data;
    NSMutableArray * vcs = [BaseViewController getVCSet];
    if (vc)
    {
        bvc.lasVCDelegate = vc;
    }else if (vcs.count > 0)
    {
        bvc.lasVCDelegate = [vcs lastObject];
    }
    //
    [vcs addObject:bvc];
    switch (st)
    {
        case VC_SHOW_DIRECT:
            [[UIApplication sharedApplication].delegate window].rootViewController = bvc;
            break;
        case VC_SHOW_PUSH:
            [vc.navigationController pushViewController:bvc animated:anim];
            break;
        case VC_SHOW_PRESENT:
            [vc presentViewController:bvc animated:anim completion:nil];
            break;
    }
}

+(void)showVCClass:(Class)cls showType:(NSUInteger)st isAnimated:(BOOL)anim withVC:(BaseViewController *)vc data:(NSDictionary *)data
{
    BaseViewController * bvc = [[cls alloc] init];
    [BaseViewController showVC:bvc showType:st isAnimated:anim withVC:vc data:data];
}

+(void)showPushClass:(Class)cls withVC:(BaseViewController *)vc data:(NSDictionary *)data
{
    [BaseViewController showVCClass:cls showType:VC_SHOW_PUSH isAnimated:YES withVC:vc data:data];
}

+(void)showPresentClass:(Class)cls withVC:(BaseViewController *)vc data:(NSDictionary *)data
{
    [BaseViewController showVCClass:cls showType:VC_SHOW_PRESENT isAnimated:YES withVC:vc data:data];
}

+(void)showPushVC:(BaseViewController *)bvc withVC:(BaseViewController *)vc data:(NSDictionary *)data
{
    [BaseViewController showVC:bvc showType:VC_SHOW_PUSH isAnimated:YES withVC:vc data:data];
}

+(void)showPresentVC:(BaseViewController *)bvc withVC:(BaseViewController *)vc data:(NSDictionary *)data
{
    [BaseViewController showVC:bvc showType:VC_SHOW_PRESENT isAnimated:YES withVC:vc data:data];
}

+(void)showDirectClass:(Class)cls withVC:(BaseViewController *)vc data:(NSDictionary *)data
{
    [BaseViewController showVCClass:cls showType:VC_SHOW_DIRECT isAnimated:YES withVC:vc data:data];
}

+(void)showDirectVC:(BaseViewController *)bvc withVC:(BaseViewController *)vc data:(NSDictionary *)data
{
    [BaseViewController showVC:bvc showType:VC_SHOW_DIRECT isAnimated:YES withVC:vc data:data];
}

+(void)popCount:(NSUInteger)count data:(NSDictionary *)data
{
    if (count < vc_set.count)
    {
        [BaseViewController exitToIndex:vc_set.count - count - 1 data:data];
    }
}

+(void)exitToIndex:(NSUInteger)index data:(NSDictionary *)data;
{
    if (index == vc_set.count - 1)
    {
        [vc_set[index] closeWindowVC];
    }else if (index < vc_set.count)
    {
        exitTo = YES;
        exitToVC = vc_set[index];
        exitToVC.showInfo.data = data;
        vc_set[vc_set.count - 1].showInfo.isShowAnimated = NO;
        [vc_set[vc_set.count - 1] closeWindowVC];
    }
}

+(void)directPopVC:(BaseViewController *)vcPop
{
    @synchronized([BaseViewController class])
    {
        if (!vc_set)
        {
            vc_set = [BaseViewController getVCSet];
        }
        if (vc_set.count > 1)
        {
            if (vc_set[vc_set.count - 1] == vcPop)
            {
                [[UIApplication sharedApplication].delegate window].rootViewController = vc_set[vc_set.count - 2];
                [vc_set removeObjectAtIndex:vc_set.count - 1];
            }else
            {
                BaseViewController * vc;
                for (NSInteger i = vc_set.count - 1; i > -1; i--)
                {
                    vc = vc_set[i];
                    [vc_set removeObjectAtIndex:i];
                    switch (vc.showInfo.showType)
                    {
                        case VC_SHOW_PUSH:
                            [vc.navigationController popViewControllerAnimated:NO];
                            break;
                        case VC_SHOW_PRESENT:
                            [vc dismissViewControllerAnimated:NO completion:nil];
                            break;
                        case VC_SHOW_DIRECT:
                            [[UIApplication sharedApplication].delegate window].rootViewController = vc;
                            
                            break;
                    }
                    if (vc == vcPop)
                    {
                        if (vc.showInfo.showType == VC_SHOW_DIRECT)
                        {
                            [[UIApplication sharedApplication].delegate window].rootViewController = vc_set[i - 1];
                        }
                        break;
                    }
                }
            }
        }
    }
}

/*************        public funaction        ****************/
-(void)closeWindowVC
{
    [self onUnInitView];
    switch (self.showInfo.showType)
    {
        case VC_SHOW_PUSH:
            [self.navigationController popViewControllerAnimated:self.showInfo.isShowAnimated];
            [vc_set removeObjectAtIndex:vc_set.count - 1];
            break;
        case VC_SHOW_PRESENT:
            [self dismissViewControllerAnimated:self.showInfo.isShowAnimated completion:nil];
            [vc_set removeObjectAtIndex:vc_set.count - 1];
            break;
        case VC_SHOW_DIRECT:
            [BaseViewController directPopVC:self];
            break;
    }
}

-(void)closeWindowVCDelay:(int)sec
{
    [self closeWindowVCWithData:nil delay:sec];
}

-(void)closeWindowVCWithData:(NSDictionary *)data delay:(int)sec
{
    if (data)
    {
        [self.lasVCDelegate setReturnData:data];
    }
    if (sec > 0)
    {
        __weak __typeof(self) ws = self;
        [self performUIAsync:^{
            [ws closeWindowVC];
        } time:sec];
    }else
    {
        [self closeWindowVC];
    }
}

-(void)closeAnimated
{
    self.showInfo.isShowAnimated = NO;
}

+(BaseViewController *)getCurrVC
{
    return curr_vc;
}

/****************           KeyBoard            **********************/
-(void)retract
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.width, self.height);
    [UIView commitAnimations];
}

-(void)attemptKeyBoard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidde:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    
    CGFloat y = -[self onGetScorllHeightWithKBH:kbSize.height];
    y = y > 0 ? 0 : y;
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275];
    self.view.frame = CGRectMake(self.left, y, self.width, self.height);
    [UIView commitAnimations];
}

-(void)keyboardWillHidde:(NSNotification *)notification
{
    [self retract];
}

-(CGFloat)onGetScorllHeightWithKBH:(CGFloat)kbh
{
    return kbh;
}
/************************************************************************************************************/
-(BOOL)onInitViewTime:(NSUInteger)time
{
    return NO;
}

-(void)onInitData:(NSDictionary *)data
{
    
}

-(void)onUnInitView
{
}

-(void)onVCResult:(NSDictionary *)data
{
}

@end
