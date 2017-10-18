//
//  ContactsManager.h
//  iosLibrary
//
//  Created by liu on 2017/9/18.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "toolMacro.h"
#import "BaseViewController.h"

@interface ContactsManager : NSObject

singleton_interface

-(void)sendSms:(BaseViewController *)vc tos:(NSArray *)phones content:(NSString * )text;

@end
