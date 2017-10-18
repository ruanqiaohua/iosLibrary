//
//  ViewController.m
//  iosLibrary
//
//  Created by liu on 2017/7/27.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "ViewController.h"
#import "LWaveView.h"
#import "toolMacro.h"
#import "UIViewController+ViewControllerHelper.h"
#import <MyLayout.h>

@interface ViewController ()
{
    LWaveView * wave;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView * rl = ONEW(MyRelativeLayout);
    rl.backgroundColor = [UIColor purpleColor];
    [rl makeLayout:^(MyMaker *make)
    {
        make.width.height.equalTo(self.view);
    }];
    [self.view addSubview:rl];
//    self.view.backgroundColor = [UIColor colorWithWhite:.9 alpha:.8];
//
//    wave = ONEW(LWaveView);
//    [self.view addSubview:wave];
//    wave.center = self.view.center;
//    wave.bounds = CGRectMake(0, 0, 300, 300);
//    wave.waveWidth = 200;
//    wave.waveHeight = 10;
//    wave.progress = 0.9;
//    wave.waveBgColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.9 alpha:0.4];
//    wave.isWaveStart = YES;
//    //
//    UIButton * btn = ONEW(UIButton);
//    [btn addTarget:self action:@selector(addWaveClick:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:@"添加" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.view addSubview:btn];
//    btn.frame = CGRectMake((self.width - 30) / 2, self.height - 50, 100, 50);
//    //
//    NSTimer * verTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(uiTimerHandler:) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:verTimer forMode:NSDefaultRunLoopMode];
}

-(void)uiTimerHandler:(NSTimer *)timer
{
    wave.progress += 0.01;
}

-(void)addWaveClick:(id)sender
{
    [wave addWaveWithColor:[UIColor colorWithRed:30/255.0 green:150/255.0 blue:255/255.0 alpha:0.60f]];
}

@end
