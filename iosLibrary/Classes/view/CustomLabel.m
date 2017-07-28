//
//  CustomLabel.m
//  yezhu
//
//  Created by liu on 2017/6/24.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (instancetype)init
{
    if (self = [super init])
    {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _textInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}


@end
