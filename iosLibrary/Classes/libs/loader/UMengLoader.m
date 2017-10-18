//
//  UMengLoader.m
//  iosLibrary
//
//  Created by liu on 2017/10/10.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "UMengLoader.h"
#import "UMMobClick/MobClick.h"
#import "objMacro.h"
#import "toolMacro.h"

@interface UMengLoader()

PropertyCString(appKey);
PropertyCString(channel);

@end

@implementation UMengLoader

-(instancetype)initAppKey:(NSString *)key channel:(NSString *)channel
{
    self = [super init];
    if (self)
    {
        self.appKey = key;
        self.channel = channel;
    }
    return self;
}

-(void)initLoaderWithDict:(id)dict
{
    UMConfigInstance.appKey = self.appKey;
    UMConfigInstance.channelId = self.channel;
    [MobClick startWithConfigure:UMConfigInstance];
}

-(void)deInitLoader
{
    
}

@end
