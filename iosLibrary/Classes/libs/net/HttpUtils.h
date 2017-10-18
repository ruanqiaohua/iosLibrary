//
//  HttpUtils.h
//  iosLibrary
//
//  Created by liu on 2017/9/14.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "toolMacro.h"
#import "NetModel.h"
#import <UIKit/UIKit.h>

#define STATE_CODE_OK                   0x0
#define STATE_CODE_ERROR                -1
#define HU                              [HttpUtils sharedInst]

@interface HttpUtils : NSObject

singleton_interface

@property(copy, nonatomic) NSString * aseKey;
@property(assign, nonatomic) CGFloat imageCompressionQuality;

-(void)getUrl:(NSString *)url param:(NSDictionary *)param onResult:(void (^)(NetResult * nr))onResult;

-(void)getUrl:(NSString *)url aesParam:(NSDictionary *)param onResult:(void (^)(NetResult * nr))onResult;

-(void)getCmd:(NetReqCmd *)cmd onResult:(void (^)(NetResult * nr))onResult;

-(void)uploadFile:(NSDictionary<NSString *, NSData *> *)fileDatas reqCmd:(NetReqCmd *)cmd onStrResult:(void (^)(NSString * result))onResult onProgress:(void (^)(float progress))onProgress failure:(void (^)(NSString * err)) failure;

-(void)uploadImage:(NSDictionary<NSString *, UIImage *> *)images reqCmd:(NetReqCmd *)cmd onResult:(void (^)(NetResult * nr))onResult;

-(void)uploadImage:(NSDictionary<NSString *, UIImage *> *)images reqCmd:(NetReqCmd *)cmd onStrResult:(void (^)(NSString * result))onResult onProgress:(void (^)(float progress))onProgress failure:(void (^)(NSString * err)) failure;

@end
