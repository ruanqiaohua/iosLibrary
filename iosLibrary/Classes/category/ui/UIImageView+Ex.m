//
//  UIImageView+Ex.m
//  cjcr
//
//  Created by liu on 2017/2/17.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import "UIImageView+Ex.h"
#import <UIImageView+WebCache.h>

@implementation UIImageView (Ex)

+(UIImageView *)createImage:(NSString *)img
{
    UIImageView * iv = [[UIImageView alloc] init];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    if ([img hasPrefix:@"http"])
    {
        [iv sd_setImageWithURL:[NSURL URLWithString:img]];
    }else
    {
        iv.image = [UIImage imageNamed:img];
    }
    return iv;
}

-(void)setImageUrl:(NSString *)url phImageStr:(NSString *)ph
{
    if (ph)
    {
        [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:ph]];
    }else
    {
        [self sd_setImageWithURL:[NSURL URLWithString:url]];
    }
}

@end
