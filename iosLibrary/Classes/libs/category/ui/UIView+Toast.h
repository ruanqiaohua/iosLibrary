//
//  UIView+Toast.h
//  iosLibrary
//
//  Created by liu on 2017/10/26.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Toast)

-(void) toast:(NSString *)toast;
-(void) toast:(NSString *)toast duration:(NSTimeInterval)duration;
-(void) toast:(NSString *)toast duration:(NSTimeInterval)duration yPosPer:(CGFloat)per;

@end
