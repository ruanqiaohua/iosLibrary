//
//  NSPointerArray+Helper.m
//  iosLibrary
//
//  Created by liu on 2017/12/19.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "NSPointerArray+Helper.h"

@implementation NSPointerArray (Helper)

-(void)removeAll
{
    if (self.count == 0)return;
    for (NSInteger i = self.count - 1; i > -1; i--)
    {
        [self removePointerAtIndex:i];
    }
}

@end
