//
//  ContactsIOS9.m
//  iosLibrary
//
//  Created by liu on 2017/11/23.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "ContactsIOS9.h"
#import "BaseViewController.h"
#import "toolMacro.h"
#import <ContactsUI/ContactsUI.h>

@interface ContactsIOS9()<CNContactPickerDelegate>
@end

@implementation ContactsIOS9

-(void)checkAuth:(void (^)(bool isAuthorized))block
{
    CNContactStore * contactStore = [[CNContactStore alloc]init];
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined)
    {
        [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error)
        {
            if (error)
            {
                block(NO);
            }
            else if (!granted)
            {

                block(NO);
            }
            else
            {
                block(YES);
            }
        }];
    }
    else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
    {
        block(YES);
    }
    else
    {
        block(NO);
    }
}

-(void)openContactsView
{
    [self checkAuth:^(bool isAuthorized) {

        if (isAuthorized)
        {
            CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
            contactPicker.delegate = self;
            contactPicker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
            [self.vc presentViewController:contactPicker animated:YES completion:nil];
        }else
        {
            [self.delegate notAuth];
        }
    }];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    CNContact * contact = contactProperty.contact;
    NSString * name = FRMSTR(@"%@%@",contact.familyName,contact.givenName);
    CNPhoneNumber * pn = (CNPhoneNumber *)contactProperty.value;
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    [self.delegate chooseContactPhones:@[pn.stringValue] name:name];
}

//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
//{
//    NSString * name = FRMSTR(@"%@%@",contact.familyName,contact.givenName);
//    NSArray *phoneNums = contact.phoneNumbers;
//    NSMutableArray * phones = ONEW(NSMutableArray);
//    for (CNLabeledValue *labeledValue in phoneNums)
//    {
//        //NSString *phoneLabel = labeledValue.label;
//        CNPhoneNumber * phoneNumer = labeledValue.value;
//        NSString *phoneValue = phoneNumer.stringValue;
//        [phones addObject:phoneValue];
//    }
//    [self.vc dismissViewControllerAnimated:YES completion:nil];
//    [self.delegate chooseContactPhones:phones name:name];
//}

-(void)dealloc
{
    NSLog(@"-------------------------------");
}

@end
