//
//  VersionInfo.h
//  iosLibrary
//
//  Created by liu on 2017/10/30.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionInfo : NSObject

@property(nonatomic, copy) NSString * ver;
@property(nonatomic, copy) NSString * url;
@property(nonatomic, copy) NSString * remark;
@property(nonatomic, assign) BOOL enforce;

@end
