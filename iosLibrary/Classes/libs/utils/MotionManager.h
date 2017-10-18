//
//  MotionManager.h
//  cjcr
//
//  Created by liu on 16/7/19.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MotionManager;
@protocol MotionDelegate <NSObject>

-(void)motion:(MotionManager *)motion accelerationX:(double)x accelerationY:(double)y accelerationZ:(double)z;

@end

@interface MotionManager : NSObject

@property(weak,nonatomic) id<MotionDelegate> delegate;

+(MotionManager *)getInst;
-(BOOL)startWithUpdateTime:(double)time;
-(void)stop;
@end
