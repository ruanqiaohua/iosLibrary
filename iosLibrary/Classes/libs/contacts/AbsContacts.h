//
//  AbsContacts.h
//  iosLibrary
//
//  Created by liu on 2017/11/23.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseViewController;

@protocol ContactsDelegate

-(void)notAuth;
-(void)chooseContactPhones:(NSArray<NSString *> *)phones name:(NSString *)name;

@end

@interface AbsContacts : NSObject

@property(nonatomic, weak) BaseViewController * vc;
@property(nonatomic, weak) id<ContactsDelegate> delegate;

-(void)checkAuth:(void (^)(bool isAuthorized))block;
-(void)openContactsView;

@end
