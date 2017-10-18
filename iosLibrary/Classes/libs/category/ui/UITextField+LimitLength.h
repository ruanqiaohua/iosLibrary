//
//  UITextField+LimitLength.h
//  yezhu
//
//  Created by liu on 2017/6/2.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (LimitLength)

- (void)limitTextLength:(int)length;
- (void)setMyLeftView:(UIView *)leftView width:(CGFloat)width height:(CGFloat)height;
- (void)setPlaceholderColor:(UIColor *)pc placeholder:(NSString *)ph;

@end
