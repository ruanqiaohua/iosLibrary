//
//  VersionManager.h
//  iosLibrary
//
//  Created by liu on 2017/10/30.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VersionInfo.h"
#import "BaseAppVC.h"

@class VersionManager;

@protocol VersionDelegate

-(void)versionManager:(VersionManager *)vm versionInfo:(VersionInfo *)vi;
-(BaseViewController *)onConfirmUpdateVM:(VersionManager *)vm;

@end

@interface VersionManager : NSObject

@property(weak, nonatomic) id<VersionDelegate> delegate;

-(void)reqUrl:(NSString *)url;
-(void)confirmUpdateVersion:(VersionInfo *)vi vc:(BaseViewController *)vc;

@end
