//
//  PinYinUtil.h
//  yuyee
//
//  Created by liu on 15/5/15.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinYinUtil : NSObject

+ (PinYinUtil *)getInst;
- (NSArray *)getPinYin:(NSString *)name;
@end
