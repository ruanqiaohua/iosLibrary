//
//  UMengLoader.h
//  iosLibrary
//
//  Created by liu on 2017/10/10.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ILoader.h"

@interface UMengLoader : NSObject<IAppDelegateLoader>

-(instancetype)initAppKey:(NSString *)key channel:(NSString *)channel;

@end
