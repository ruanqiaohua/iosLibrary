//
//  MotionManager.m
//  cjcr
//
//  Created by liu on 16/7/19.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "MotionManager.h"
#import <CoreMotion/CoreMotion.h>

static MotionManager * inst = nil;

@interface MotionManager()
{
    CMMotionManager * cmm;
}
@end

@implementation MotionManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        cmm = [[CMMotionManager alloc] init];
    }
    return self;
}

+(MotionManager *)getInst
{
    @synchronized(self)
    {
        if (inst == nil)
        {
            inst = [[super allocWithZone:NULL] init];
        }
    }
    return inst;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (inst == nil)
        {
            inst = [super allocWithZone:zone];
        }
    }
    return inst;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

-(BOOL)startWithUpdateTime:(double)time
{
    if (cmm.isAccelerometerAvailable)
    {
        if (!cmm.isAccelerometerActive && self.delegate)
        {
            NSOperationQueue * queue = [[NSOperationQueue alloc] init];
            cmm.accelerometerUpdateInterval = time;
            [cmm startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error)
            {
                if (error)
                {
                    NSLog(@"startWithUpdateTime is err -> %@",error);
                    [cmm stopAccelerometerUpdates];
                }
                [self.delegate motion:self accelerationX:accelerometerData.acceleration.x accelerationY:accelerometerData.acceleration.y accelerationZ:accelerometerData.acceleration.z];
            }];
        }
        return YES;
    }
    return NO;
}

-(void)stop
{
    if (cmm.isAccelerometerActive)
    {
        [cmm stopAccelerometerUpdates];
    }
}

@end
