//
//  XDataSave.m
//  iosLibrary
//
//  Created by liu on 2018/10/1.
//  Copyright © 2018年 liu. All rights reserved.
//

#import "XDataSave.h"
#import <YYModel.h>
#define ACCOUNT_KEY     @"accounts"
#define SECRET_KEY      @"secret"

@implementation XDataSave

singleton_implementation(XDataSave)

-(void)saveObject:(NSObject *)obj
{
    NSString * json = [obj yy_modelToJSONString];
    [[NSUserDefaults standardUserDefaults] setValue:json forKey:GETCLASSNAME(obj.class)];
}

-(NSObject *)getObjectByClass:(Class)cls
{
    NSString * json = [[NSUserDefaults standardUserDefaults] objectForKey:GETCLASSNAME(cls)];
    if (json.length > 0)
    {
        return [cls yy_modelWithJSON:json];
    }
    return nil;
}

-(void)saveKey:(NSString *)key value:(NSString *)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
}

-(NSString *)getKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

-(void)saveKey:(NSString *)key intValue:(NSInteger)value
{
    [[NSUserDefaults standardUserDefaults] setValue:@(value) forKey:key];
}

-(NSInteger)getIntValueByKey:(NSString *)key
{
    NSNumber * num = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [num integerValue];
}

-(void)saveAccounts:(NSString *)acc
{
    [[NSUserDefaults standardUserDefaults] setValue:acc forKey:ACCOUNT_KEY];
}

-(NSString *)getAccounts
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_KEY];
}

-(void)saveSecret:(NSString *)secret
{
    [[NSUserDefaults standardUserDefaults] setValue:secret forKey:SECRET_KEY];
}

-(NSString *)getSecret
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:SECRET_KEY];
}

@end
