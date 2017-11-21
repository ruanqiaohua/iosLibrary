//
//  VersionManager.m
//  iosLibrary
//
//  Created by liu on 2017/10/30.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "VersionManager.h"
#import "HttpUtils.h"
#import <YYModel.h>
#import <SPAlertController.h>

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
            }
        }
    }];
}

-(void)confirmUpdateUrl:(NSString *)url remark:(NSString *)remark vc:(BaseAppVC *)vc
{
    if (remark.length > 0)
    {
        SPAlertController * spac = [SPAlertController alertControllerWithTitle:@"新版本" message:remark preferredStyle:SPAlertControllerStyleAlert animationType:SPAlertAnimationTypeDefault];

        SPAlertAction * ok = [SPAlertAction actionWithTitle:@"升级" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action)
                              {
                                  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                              }];

        SPAlertAction * cancel = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action)
                                  {
                                  }];

        [spac addAction:ok];
        [spac addAction:cancel];
        [vc presentViewController:spac animated:YES completion:nil];
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
