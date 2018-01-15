//
//  CameraManager.m
//  yezhu
//
//  Created by liu on 2017/6/28.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "CameraManager.h"
#import "UIImage+SubImage.h"
#import "NSObject+NSObjectHelper.h"

@interface CameraManager()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property(weak, nonatomic) UIViewController * vc;

@end

@implementation CameraManager

singleton_implementation(CameraManager)

-(void)openWithSourceType:(UIImagePickerControllerSourceType)st withVC:(UIViewController *)vc
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = st;
    picker.delegate = self;
    picker.allowsEditing = NO;
    self.vc = vc;
    [vc presentViewController:picker animated:YES completion:nil];
}

-(void)openCameraWithVC:(UIViewController *)vc
{
    [self openWithSourceType:UIImagePickerControllerSourceTypeCamera withVC:vc];
}

-(void)openPhotoLibraryWithVC:(UIViewController *)vc
{
    [self openWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary withVC:vc];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * img = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation imageOrientation = img.imageOrientation;
    if(imageOrientation != UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContextWithOptions(img.size, NO, [[UIScreen mainScreen] scale]);
        [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
    if (self.maxImageWHPX > 0)
    {
        if ([self.delegate respondsToSelector:@selector(onCMOpenResizeHit)])
        {
            [self.delegate onCMOpenResizeHit];
        }
        [self performAsync:^{

            UIImage * resImage = [img rescaleImageToPX:self.maxImageWHPX];

            [self performUIAsync:^{

                if (self.delegate)
                {
                    [self.delegate onCMImage:resImage];
                }
            }];
        }];
        return;
    }
    //
    if (self.delegate)
    {
        [self.delegate onCMImage:img];
    }
}

@end
