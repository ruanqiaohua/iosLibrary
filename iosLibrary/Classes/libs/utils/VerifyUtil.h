//
//  VerifyUtil.h
//  yezhu
//
//  Created by liu on 2017/7/22.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyUtil : NSObject

+(BOOL)verifyIdCard:(NSString *)ic;
+(NSString *)verifyText:(NSArray<NSString *> *)texts aryLen:(NSArray<NSNumber *> *)lens hits:(NSArray<NSString *> *)hits;
+(BOOL)verifyOnlyCharNumStr:(NSString *)str;
+(BOOL)verifyEmail:(NSString *)email;
@end
