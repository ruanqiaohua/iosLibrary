//
//  objMacro.h
//  iosLibrary
//
//  Created by liu on 2017/7/27.
//  Copyright © 2017年 liu. All rights reserved.
//

#ifndef objMacro_h
#define objMacro_h

#define PropertyObj(name,type)             @property(strong, nonatomic) type * name
#define PropertyWeakObj(name,type)         @property(weak, nonatomic) type * name
#define PropertyBOOL(name)                 @property(assign, nonatomic) BOOL name
#define PropertyCString(name)              @property(nonatomic,copy) NSString * name
#define PropertySString(name)              @property(nonatomic,strong) NSString * name
#define PropertyNSInteger(name)            @property(nonatomic,assign) NSInteger name
#define PropertyInt(name)                  @property(nonatomic,assign) int name
#define PropertyFloat(name)                @property(nonatomic,assign) float name
#define PropertyLong(name)                 @property(nonatomic,assign) long name
#define PropertyLongLong(name)             @property(nonatomic,assign) long long name
#define PropertyNSDictionary(name)         @property(nonatomic,strong) NSDictionary * name
#define PropertyNSArray(name)              @property(nonatomic,strong) NSArray * name
#define PropertyNSArrayType(name,type)     @property(nonatomic,strong) NSArray<type*> * name
#define PropertyNSMutableArray(name)       @property(nonatomic,strong) NSMutableArray * name
#define PropertyDelegate(type)             @property(nonatomic,weak) id<type> delegate
//#define PropertyDelegate(type,name)        @property(nonatomic,weak) id<type> name


#endif /* objMacro_h */
