//
//  NSString+NSStringHelper.m
//  lightup
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "NSString+NSStringHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSStringHelper)

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

-(BOOL) isInt
{
    NSString * pattern = @"^[0-9]+$";
    NSRegularExpression * re = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    return [re matchesInString:self options:0 range:NSMakeRange(0, self.length)].count > 0;
}

-(NSString *) encode
{
    NSString * vailid = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890-_.:";
    if (self == nil || self.length == 0)
    {
        return @"$B";
    }
    NSMutableString * ret = [[NSMutableString alloc] init];
    NSString * tmp;
    for (int i = 0; i < self.length; i++)
    {
        unichar c = [self characterAtIndex:i];
        tmp = [NSString stringWithFormat:@"%C", c];
        if ([vailid rangeOfString:tmp].location != NSNotFound)
        {
            [ret appendString:tmp];
        }else
        {
            [ret appendString:[NSString stringWithFormat:@"$%.4x", c]];
        }
    }
    return ret;
}

-(NSString *) decoded
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL)validateRegular:(NSString *)regular
{
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regular];
    return [pre evaluateWithObject:self];
//    NSRange range = [self rangeOfString:regular options:NSRegularExpressionSearch];
//    return range.location != NSNotFound;
}

-(NSArray *)split:(NSString *)str
{
    return [self componentsSeparatedByString:str];
}

@end
