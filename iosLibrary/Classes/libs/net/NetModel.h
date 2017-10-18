//
//  NetModel.h
//  iosLibrary
//
//  Created by liu on 2017/9/15.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#define LIST_SIZE   10

@interface NetResult : NSObject

@property(assign, nonatomic) int                            state;
@property(strong, nonatomic) NSString                       * ret;
@property(strong, nonatomic) NSDictionary                   * obj;

@end

@interface NetReqCmd : NSObject

@property(strong, nonatomic) NSString               * url;
@property(strong, nonatomic) id                     params;
@property(assign, nonatomic) BOOL                   isEnc;//是否加密参数

@end
