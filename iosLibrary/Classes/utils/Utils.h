//
//  Utils.h
//  lightup
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

//+(void)alertWithTitle:(NSString *)title message:(NSString *)msg;
//+(void)alertWithTitle:(NSString *)title message:(NSString *)msg okClick:(void(^)())okClick;
+(void)callLocalPhone:(NSString *)phone;
+(CGSize)calSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)ms;
@end
