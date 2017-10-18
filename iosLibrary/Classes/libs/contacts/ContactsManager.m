//
//  ContactsManager.m
//  iosLibrary
//
//  Created by liu on 2017/9/18.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "ContactsManager.h"
#import <MessageUI/MessageUI.h>

@interface ContactsManager()<MFMessageComposeViewControllerDelegate>

@end

@implementation ContactsManager

singleton_implementation(ContactsManager)

-(void)sendSms:(UIViewController *)vc tos:(NSArray *)phones content:(NSString * )text
{
    if( [MFMessageComposeViewController canSendText] )
    {
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        
        controller.recipients = phones;
        controller.body = text;
        controller.messageComposeDelegate = self;
        
        [vc presentViewController:controller animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:NO completion:nil];
}

@end
