//
//  ImageViewAnimationHelper.h
//  UserApp
//
//  Created by liu on 2018/9/27.
//  Copyright © 2018年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageViewAnimationHelper : NSObject

-(void)setView:(UIView *)view moveNum:(NSUInteger)mn lineWidth:(int)lw;
-(void)startMoveNum:(NSUInteger)mn;

@end
