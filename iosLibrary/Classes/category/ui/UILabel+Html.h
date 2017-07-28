//
//  UILabel+Html.h
//  cjcr
//
//  Created by liu on 2017/2/13.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Html)

-(void)setHtml:(NSString *)html;
+(UILabel *)createWithFont:(UIFont *)font textColor:(UIColor *)tc;

@end
