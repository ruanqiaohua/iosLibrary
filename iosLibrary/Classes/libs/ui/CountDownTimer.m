//
//  CountDownTimer.m
//  iosLibrary
//
//  Created by liu on 2017/11/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "CountDownTimer.h"
#import "toolMacro.h"

@interface CountDownTimer()
{
    int         timeCount;
    NSTimer     * cdTimer;
    NSString    * btnText;
}
@end

@implementation CountDownTimer

-(void)startTime
{
    [self cancelTime];
    self.btn.userInteractionEnabled = NO;
    btnText = self.btn.titleLabel.text;
    timeCount = self.cdTime;
    cdTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(uiTimerHandler:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:cdTimer forMode:NSDefaultRunLoopMode];
}

-(void)cancelTime
{
    if (cdTimer)
    {
        [cdTimer invalidate];
        [self.btn setTitle:btnText forState:UIControlStateNormal];
        self.btn.userInteractionEnabled = YES;
        cdTimer = nil;
    }
}

-(void)uiTimerHandler:(NSTimer *)timer
{
    if (timeCount > 0)
    {
        [self.btn setTitle:FRMSTR(@"%d",--timeCount) forState:UIControlStateNormal];
    }else
    {
        [self cancelTime];
    }
}

@end
