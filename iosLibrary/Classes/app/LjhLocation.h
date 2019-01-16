//
//  LjhLocation.h
//  iosLibrary
//
//  Created by liu on 2018/10/15.
//  Copyright © 2018年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "toolMacro.h"

#define LOCATION    [LjhLocation sharedInst]
@class LjhLocation;
@protocol LocationDelegate

-(void)ljhLocation:(LjhLocation *)loc isSuccess:(BOOL)isSuccess;

@end

@interface LjhLocation : NSObject
@property(nonatomic, weak) id<LocationDelegate> delegate;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;
@property(nonatomic, strong) NSString * country;
@property(nonatomic, strong) NSString * city;
@property(nonatomic, strong) NSString * locality;//地区
@property(nonatomic, strong) NSString * address;//具体地址(街道)

singleton_interface

-(void)reqLocation;

@end
