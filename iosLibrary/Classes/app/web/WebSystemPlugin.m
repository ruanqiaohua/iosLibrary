//
//  WebSystemPlugin.m
//  iosLibrary
//
//  Created by liu on 2018/1/16.
//  Copyright © 2018年 liu. All rights reserved.
//
#import "WebSystemPlugin.h"
#import "ContactsManager.h"
#import "LTitleView.h"
#import "WebShellVCBase.h"
#import "NSString+NSStringHelper.h"
#import <YYModel.h>

@implementation WebSystemPlugin

-(BOOL)execWithFunName:(NSString *)name param:(NSDictionary *)param callback:(NSString *)cb
{
    BOOL isProc = NO;
    if ([name isEqualToString:SEND_SMS])
    {
        [[ContactsManager sharedInst] sendSms:[self.shell getVC] tos:[param[P_SS_TOS] split:@","] content:param[P_SS_TXT]];
        isProc = YES;
    }else if ([name isEqualToString:VERSION])
    {
        if (cb.length > 0)
        {
            NSDictionary * d = @{METHOD:param[P_ALIAS],
                                 SUCCESS:@(YES),
                                 P_VER:APP_VERSION
                                 };
            [self.shell execJScript: [cb stringByReplacingOccurrencesOfString:@"#" withString:[d yy_modelToJSONString]]];
        }
        return YES;
    }else if ([name isEqualToString:CALL_PHONE])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FRMSTR(@"telprompt://%@",param[P_CP_PHONE])]];
        isProc = YES;
    }else if ([name isEqualToString:UPDAGE])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:P_U_URL]];
        isProc = YES;
    }
    isProc = isProc || !([self execOtherWithFunName:name param:param callback:cb] == EXEC_OTHER_NO_PROC);
    return [self procCallback:cb isProc:isProc alias:param[P_ALIAS]];
}

@end
