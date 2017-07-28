//
//  UIImageView+Ex.h
//  cjcr
//
//  Created by liu on 2017/2/17.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Ex)

+(UIImageView *)createImage:(NSString *)img;
-(void)setImageUrl:(NSString *)url phImageStr:(NSString *)ph;

@end
