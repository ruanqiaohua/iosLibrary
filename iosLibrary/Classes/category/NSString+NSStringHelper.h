//
//  NSString+NSStringHelper.h
//  lightup
//
//  Created by liu on 15/7/9.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSStringHelper)

-(NSString *) md5;
-(NSString *) encode;
-(NSString *) decoded;
-(BOOL) isInt;
-(BOOL)validateRegular:(NSString *)regular;
-(NSArray *)split:(NSString *)str;
@end
