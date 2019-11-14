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
#import "SPAlertController.h"
#import <SVProgressHUD.h>
#import "UIView+UIViewHelper.h"

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
    UIView          * inputLastView;
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
        if (!self.showInfo.isReturnData)
        {
            [self onInitData:self.showInfo.data];
            self.showInfo.data = nil;
        }
    }
    //
    if (self.showInfo.isReturnData)
    {
        [self onVCResult:self.showInfo.data];
        self.showInfo.isReturnData = NO;
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
    if (isOnceWillAppear && self.showInfo.isNextCloseSelfColse)
    {
        [self closeWindowVC];
        return;
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
    self.showInfo.isReturnData = YES;
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
+(BaseViewController *)getViewControllerByIndex:(NSInteger)index
{
    NSMutableArray * ary = [BaseViewController getVCSet];
    if (ary.count > 0)
    {
        return ary[index];
    }
    return nil;
}

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
    bvc.showInfo.isReturnData = NO;
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
            bvc.modalPresentationStyle = 0;
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
        [vc_set[index] closeWindowVCWithData:data delay:0];
    }else if (index < vc_set.count)
    {
        exitTo = YES;
        exitToVC = vc_set[index];
        exitToVC.showInfo.isReturnData = YES;
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
-(void)showSPTitle:(NSString *)title msg:(NSString *)msg actNames:(NSArray<NSString *> *)actNames redActIndex:(NSInteger)rai style:(NSInteger)style clickAction:(void(^)(NSInteger index))clickAction
{
    SPAlertController * spac = [SPAlertController alertControllerWithTitle:title message:msg preferredStyle:style animationType:SPAlertAnimationTypeDefault];
    SPAlertAction * spAct;
    for (NSInteger i = 0;i < actNames.count;i++)
    {
        spAct = [SPAlertAction actionWithTitle:actNames[i] style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action)
                 {
                     [self performUIAsync:^{
                         clickAction(i);
                     } sec:0.1];
                 }];
        spAct.titleColor = i == rai ? [UIColor redColor] : [UIColor blackColor];
        [spac addAction:spAct];
    }
    [self presentViewController:spac animated:YES completion:nil];
}

-(void)showAlertTitle:(NSString *)title msg:(NSString *)msg actNames:(NSArray<NSString *> *)actNames redActIndex:(NSInteger)rai clickAction:(void(^)(NSInteger index))clickAction
{
    [self showSPTitle:title msg:msg actNames:actNames redActIndex:rai style:SPAlertControllerStyleAlert clickAction:clickAction];
}

-(void)showSheetTitle:(NSString *)title msg:(NSString *)msg sheets:(NSArray<NSString *> *)sheets redActIndex:(NSInteger)rai clickAction:(void(^)(NSInteger index))clickAction
{
    [self showSPTitle:title msg:msg actNames:sheets redActIndex:rai style:SPAlertControllerStyleActionSheet clickAction:clickAction];
}

-(void)showInputTitle:(NSString *)title msg:(NSString *)msg placeholder:(NSString *)ph clickAction:(void(^)(NSString * text))clickAction
{
    SPAlertController * spac = [SPAlertController alertControllerWithTitle:title message:msg preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];
    [spac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = ph;
    }];
    SPAlertAction * spAct;
    spAct = [SPAlertAction actionWithTitle:@"确定" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action)
     {
         [self performUIAsync:^{
             clickAction(spac.textFields.firstObject.text);
         } sec:0.1];
     }];
    spAct.titleColor = [UIColor blackColor];
    [spac addAction:spAct];
    spAct = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action)
    {
    }];
    spAct.titleColor = [UIColor blackColor];
    [spac addAction:spAct];
    [self presentViewController:spac animated:YES completion:nil];
}

-(NSString *)getTFTextWithViewTag:(NSInteger)tag
{
    return ((UITextField *)[self.view viewWithTag:tag]).text;
}

-(void)setTFTextWithViewTag:(NSInteger)tag text:(NSString *)text
{
    ((UITextField *)[self.view viewWithTag:tag]).text = text;
}

-(NSString *)getLabTextWithViewTag:(NSInteger)tag
{
    return ((UILabel *)[self.view viewWithTag:tag]).text;
}

-(void)setLabTextWithViewTag:(NSInteger)tag text:(NSString *)text
{
    ((UILabel *)[self.view viewWithTag:tag]).text = text;
}

-(void)showProgress:(float)progess title:(NSString *)title
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showProgress:progess status:title];
}

-(void)showDlgTitle:(NSString *)title
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:title];
}

-(void)dismissHUD
{
    [SVProgressHUD dismiss];
}

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
        } sec:sec];
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

-(void)attemptKeyBoardWithView:(UIView *)view
{
    [self attemptKeyBoard];
    inputLastView = view;
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    CGFloat y = 0;
    if (inputLastView)
    {
        CGPoint p = [self.view convertPoint:inputLastView.frame.origin toView:nil];
        CGFloat t = p.y + inputLastView.height;
        y = (t - (self.view.height - kbSize.height)) * 1.5;
        y = y < 0 ? 0 : y;
    }else
    {
        y = [self onGetScorllHeightWithKBH:kbSize.height];
    }
    [UIView beginAnimations:@"srcollView" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.275];
    self.view.frame = CGRectMake(self.left, -y, self.width, self.height);
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
/************************************************************************/
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
