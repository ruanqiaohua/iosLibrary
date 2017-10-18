//
//  objMacro.h
//  iosLibrary
//
//  Created by liu on 2017/7/27.
//  Copyright © 2017年 liu. All rights reserved.
//

#ifndef objMacro_h
#define objMacro_h

#define PropertyObj(s,type)         @property(strong, nonatomic) type * s
#define PropertyBOOL(s)             @property(assign, nonatomic) BOOL s
#define PropertyCString(s)          @property(nonatomic,copy) NSString * s
#define PropertySString(s)          @property(nonatomic,strong) NSString * s
#define PropertyNSInteger(s)        @property(nonatomic,assign) NSInteger s
#define PropertyFloat(s)            @property(nonatomic,assign) float s
#define PropertyLongLong(s)         @property(nonatomic,assign) long long s
#define PropertyNSDictionary(s)     @property(nonatomic,strong) NSDictionary * s
#define PropertyNSArray(s)          @property(nonatomic,strong) NSArray * s
#define PropertyNSArrayType(s,type) @property(nonatomic,strong) NSArray<type*> * s
#define PropertyNSMutableArray(s)   @property(nonatomic,strong) NSMutableArray * s



#endif /* objMacro_h */
