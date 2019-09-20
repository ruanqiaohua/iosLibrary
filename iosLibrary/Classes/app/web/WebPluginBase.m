//
//  WebPluginBase.m
//  iosLibrary
//
//  Created by liu on 2018/1/2.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "WebPluginBase.h"
#import "WebShellVCBase.h"
#import "toolMacro.h"
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

-(BOOL)procCallback:(NSString *)cb param:(NSDictionary *)param isSuccess:(BOOL)isSuccess values:(NSDictionary *)values
{
    if (cb.length > 0)
    {
        NSMutableDictionary * dict;
        if (values)
        {
            dict = [[NSMutableDictionary alloc] initWithDictionary:values];
        }else
        {
            dict = ONEW(NSMutableDictionary);
        }
        dict[METHOD] = SAFESTR(param[METHOD]);
        dict[P_ALIAS] = SAFESTR(param[P_ALIAS]);
        dict[SUCCESS] = @(YES);
        [self.shell execJScript:[cb stringByReplacingOccurrencesOfString:@"#" withString:
                                 [dict yy_modelToJSONString]]];
        return YES;
    }
    return YES;
}

@end
