//
//  WebPluginBase.m
//  iosLibrary
//
//  Created by liu on 2018/1/2.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebPluginBase.h"
#import "WebShellVCBase.h"

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

@end
