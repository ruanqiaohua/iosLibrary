//
//  UILabel+Html.m
//  cjcr
//
//  Created by liu on 2017/2/13.
//  Copyright © 2017年 ljh. All rights reserved.
//

#import "UILabel+Html.h"

@implementation UILabel (Html)

-(void)setHtml:(NSString *)html
{
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.attributedText = attrStr;
}

+(UILabel *)createWithFont:(UIFont *)font textColor:(UIColor *)tc
{
    UILabel * lab = [[UILabel alloc] init];
    lab.font = font;
    lab.textColor = tc;
    return lab;
}

@end
