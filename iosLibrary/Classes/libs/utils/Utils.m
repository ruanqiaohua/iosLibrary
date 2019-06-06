//
//  Utils.m
//  lightup
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "Utils.h"
#import "toolMacro.h"

@implementation Utils

//+(void)alertWithTitle:(NSString *)title message:(NSString *)msg
//{
//    [DSAlert ds_showAlertWithTitle:title message:msg image:nil buttonTitles:@[@"确定"] buttonTitlesColor:@[COLOR_BLACK_L] configuration:^(DSAlert *tempView) {
//        
//        tempView.isTouchEdgeHide = YES;
//        tempView.bgColor = UIColorFromRGBA(0x70000000);
//    } actionClick:^(NSInteger index) {
//        
//    }];
//}
//
//+(void)alertWithTitle:(NSString *)title message:(NSString *)msg okClick:(void(^)())okClick
//{
//    [DSAlert ds_showAlertWithTitle:title message:msg image:nil buttonTitles:@[@"确定"] buttonTitlesColor:@[COLOR_BLACK_L] configuration:^(DSAlert *tempView) {
//        
//        tempView.isTouchEdgeHide = YES;
//        tempView.bgColor = UIColorFromRGBA(0x70000000);
//    } actionClick:^(NSInteger index) {
//        okClick();
//    }];
//}

+(void)openUrl:(NSString *)url
{
    if (IOS_VERSION >= 10)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:nil];
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

+(void)callLocalPhone:(NSString *)phone
{
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@", phone];
    if (IOS_VERSION >= 10)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:nil];
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

+(CGSize)calSizeWithText:(NSString *)text font:(UIFont *)font
{
    return [Utils calSizeWithText:text font:font maxSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
}

+(CGSize)calSizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)ms
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attribute = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    return [text boundingRectWithSize:ms options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
}

+(NSString *)maskPhone:(NSString *)phone
{
    NSString *string = [phone stringByReplacingOccurrencesOfString:[phone substringWithRange:NSMakeRange(3,4)]withString:@"****"];
    return string;
}

@end
