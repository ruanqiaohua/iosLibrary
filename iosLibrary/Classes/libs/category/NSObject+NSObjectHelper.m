//
//  NSObject+NSObjectHelper.m
//  lightup
//
//  Created by liu on 15/7/10.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "NSObject+NSObjectHelper.h"

@implementation NSObject (NSObjectHelper)

-(void)performAsync:(dispatch_block_t)block sec:(float)delta
{
    int64_t t = delta * NSEC_PER_SEC;
    dispatch_time_t runTime = dispatch_time(DISPATCH_TIME_NOW, t);
    dispatch_after(runTime, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

-(void)performAsync:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

-(void)performUIAsync:(dispatch_block_t)block sec:(float)delta
{
    int64_t t = delta * NSEC_PER_SEC;
    dispatch_time_t runTime = dispatch_time(DISPATCH_TIME_NOW, t);
    dispatch_after(runTime, dispatch_get_main_queue(), block);
}

-(void)performUIAsync:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

@end
