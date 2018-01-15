//
//  VersionManager.m
//  iosLibrary
//
//  Created by liu on 2017/10/30.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "VersionManager.h"
#import "HttpUtils.h"
#import "NSObject+NSObjectHelper.h"
#import <YYModel.h>
#import "SPAlertController.h"

@implementation VersionManager

-(void)reqUrl:(NSString *)url
{
    if (!self.delegate)return;
    WEAKOBJ(self);
    [HU getUrl:url param:nil onResult:^(NetResult *nr)
    {
        if (nr.state == STATE_CODE_OK)
        {
            VersionInfo * vi = [VersionInfo yy_modelWithDictionary:nr.obj];
            if (vi)
            {
                [weak_self.delegate versionManager:weak_self versionInfo:vi];
                if ((vi.remark.length > 0 || vi.enforce))
                {
                    BaseViewController * vc = [weak_self.delegate onConfirmUpdateVM:weak_self];
                    if (vc)
                    {
                        if (vi.remark.length == 0)vi.remark = @"该版本太低，需强制升级到最新版本";
                        [vc performUIAsync:^{

                            [weak_self confirmUpdateVersion:vi vc:vc];
                        }];
                    }
                }
            }
        }
    }];
}

-(void)confirmUpdateVersion:(VersionInfo *)vi vc:(BaseViewController *)vc
{
    if (vi.remark.length > 0)
    {
        SPAlertController * spac = [SPAlertController alertControllerWithTitle:@"新版本" message:vi.remark preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];

        SPAlertAction * ok = [SPAlertAction actionWithTitle:@"升级" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action)
                              {
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vi.url]];
                              }];
        [spac addAction:ok];
        spac.disableClose = vi.enforce;
        if (!vi.enforce)
        {
            SPAlertAction * cancel = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action)
                                      {
                                      }];
            [spac addAction:cancel];
        }
        [vc presentViewController:spac animated:YES completion:nil];
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vi.url]];
    }
}

@end
