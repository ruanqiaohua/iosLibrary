//
//  ContactsIOS8.m
//  iosLibrary
//
//  Created by liu on 2017/11/23.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "ContactsIOS8.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "toolMacro.h"
#import "BaseViewController.h"

@interface ContactsIOS8()<ABPeoplePickerNavigationControllerDelegate>
@end

@implementation ContactsIOS8

-(void)checkAuth:(void (^)(bool isAuthorized))block
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();

    if (authStatus == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                if (error)
                {
                    block(NO);
                }
                else if (!granted)
                {
                    block(NO);
                }else
                {
                    block(YES);
                }
            });
        });
    }else if (authStatus == kABAuthorizationStatusAuthorized)
    {
        block(YES);
    }else
    {
        block(NO);
    } 
}

-(void)openContactsView
{
    [self checkAuth:^(bool isAuthorized) {

        if (isAuthorized)
        {
            ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
            peoplePicker.peoplePickerDelegate = self;
            [self.vc presentViewController:peoplePicker animated:YES completion:nil];
        }else
        {
            [self.delegate notAuth];
        }
    }];
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSString * fullName = (__bridge_transfer NSString*)ABRecordCopyCompositeName(person);
    //电话
    ABMultiValueRef valuesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFIndex index = ABMultiValueGetIndexForIdentifier(valuesRef, identifier);
    CFStringRef strRef = ABMultiValueCopyValueAtIndex(valuesRef, index);
    NSString * phone = (__bridge NSString *)strRef;
    CFRelease(strRef);
    CFRelease(valuesRef);
    //
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    [self.delegate chooseContactPhones:@[phone] name:fullName];
}

-(void)dealloc
{
    NSLog(@"-------------------------------");
}

@end
