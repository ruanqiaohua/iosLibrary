//
//  XDataSave.h
//  iosLibrary
//
//  Created by liu on 2018/10/1.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "toolMacro.h"

#define XDS     [XDataSave sharedInst]

@interface XDataSave : NSObject

singleton_interface

-(void)saveObject:(NSObject *)obj;
-(NSObject *)getObjectByClass:(Class)cls;
-(void)saveKey:(NSString *)key value:(NSString *)value;
-(NSString *)getKey:(NSString *)key;
-(void)saveKey:(NSString *)key intValue:(NSInteger)value;
-(NSInteger)getIntValueByKey:(NSString *)key;
-(void)saveAccounts:(NSString *)acc;
-(NSString *)getAccounts;
-(void)saveSecret:(NSString *)secret;
-(NSString *)getSecret;

@end
