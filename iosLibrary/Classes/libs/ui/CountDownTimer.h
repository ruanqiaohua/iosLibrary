//
//  CountDownTimer.h
//  iosLibrary
//
//  Created by liu on 2017/11/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CountDownTimer : NSObject

@property(nonatomic, weak) UIButton * btn;
@property(nonatomic, assign) int cdTime;//倒计时时间

-(void)startTime;
-(void)cancelTime;

@end
