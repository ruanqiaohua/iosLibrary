//
//  WebPluginBase.m
//  iosLibrary
//
//  Created by liu on 2018/1/2.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebPluginBase.h"
#import "WebShellVCBase.h"
#import <YYModel.h>

@implementation WebPluginBase

-(void)initPluginWithData:(NSDictionary *)data{}

-(NSString *)getName
{
    return NSStringFromClass(self.class);
}

-(void)deInitPlugin{}

-(NSInteger)execOtherWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    return EXEC_OTHER_NO_PROC;
}

-(BOOL)execWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    return NO;
}

-(BOOL)vcResultData:(NSDictionary *)data
{
    return NO;
}

-(BOOL)procCallback:(NSString *)cb isProc:(BOOL)isProc values:(NSDictionary *)values
{
    if (isProc && cb.length > 0)
    {
        [self.shell execJScript:[cb stringByReplacingOccurrencesOfString:@"#" withString:
                                 [values yy_modelToJSONString]]];
    }
    return isProc;
}

-(BOOL)procCallback:(NSString *)cb isProc:(BOOL)isProc alias:(NSString *)alias
{
    return [self procCallback:cb isProc:isProc values:@{SUCCESS:@(YES),METHOD:alias}];
}

-(BOOL)procCallback:(NSString *)cb isProc:(BOOL)isProc isSuccess:(BOOL)isSuccess alias:(NSString *)alias
{
    return [self procCallback:cb isProc:isProc values:@{SUCCESS:@(isSuccess),METHOD:alias}];
}

@end
