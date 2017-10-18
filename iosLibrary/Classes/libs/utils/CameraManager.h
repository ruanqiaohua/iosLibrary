//
//  CameraManager.h
//  yezhu
//
//  Created by liu on 2017/6/28.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "toolMacro.h"

@protocol CameraManagerDelegate <NSObject>

-(void)onCMImage:(UIImage *)image;

@end

@interface CameraManager : NSObject

@property(weak, nonatomic) id<CameraManagerDelegate> delegate;
@property(assign,nonatomic) CGFloat maxImageWHPX;//宽或高最大的大小

singleton_interface

-(void)openCameraWithVC:(UIViewController *)vc;
-(void)openPhotoLibraryWithVC:(UIViewController *)vc;

@end
