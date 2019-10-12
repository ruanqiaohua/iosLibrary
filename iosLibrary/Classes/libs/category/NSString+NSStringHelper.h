//
//  NSString+NSStringHelper.h
//  lightup
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringHelper)

-(NSString *)md5;
-(NSString *)encode;
-(NSString *)decoded;
//截取字符串，从找到fs开始; isHead(YES)从头部开始 （NO）从尾部开始
-(NSString *)cutStr:(NSString *)fs isHead:(BOOL)isHead;
-(BOOL)isInt;
-(BOOL)validateRegular:(NSString *)regular;
-(NSArray *)split:(NSString *)str;
-(NSString *)maskRange:(NSRange)range;

@end
