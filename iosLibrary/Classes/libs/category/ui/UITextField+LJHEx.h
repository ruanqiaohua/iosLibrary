//
//  UITextField+LJHEx.h
//  iosLibrary
//
//  Created by liu on 2017/11/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LJHEx)

- (void)limitTextLength:(int)length;
- (void)setMyLeftView:(UIView *)leftView width:(CGFloat)width height:(CGFloat)height;
- (void)setPlaceholderColor:(UIColor *)pc placeholder:(NSString *)ph;
+(UITextField *)createPHText:(NSString *)pht phtColor:(UIColor *)phtColor tag:(NSInteger)tag limitLen:(int)len keyBoardType:(NSInteger)kbt textColor:(UIColor *)tc textFont:(UIFont *)tf;

@end
