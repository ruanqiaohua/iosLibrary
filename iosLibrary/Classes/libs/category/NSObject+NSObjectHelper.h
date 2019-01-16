//
//  NSObject+NSObjectHelper.h
//  lightup
//
//  Created by liu on 15/7/10.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObjectHelper)

-(void)performAsync:(dispatch_block_t)block sec:(float)delta;
-(void)performAsync:(dispatch_block_t)block;
-(void)performUIAsync:(dispatch_block_t)block sec:(float)delta;
-(void)performUIAsync:(dispatch_block_t)block;

@end
