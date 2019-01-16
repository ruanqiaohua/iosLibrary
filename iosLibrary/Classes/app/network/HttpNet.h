//
//  HttpNet.h
//  iosLibrary
//
//  Created by liu on 2018/10/17.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "toolMacro.h"

#define HTTP_CODE_OK    200
#define HTTP_ERR_KEY    @"err"

@interface HttpNet : NSObject

singleton_interface

-(void)postUrl:(NSString *)url param:(NSDictionary *)param onResult:(void (^)(BOOL isOK, NSString * msg, NSInteger httpCode, NSDictionary * dict))onResult;

-(void)postUrl:(NSString *)url json:(NSDictionary *)json onResult:(void (^)(BOOL isOK, NSString * msg, NSInteger httpCode, NSDictionary * dict))onResult;

@end
