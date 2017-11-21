//
//  TapLayout.h
//  iosLibrary
//
//  Created by liu on 2017/11/7.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>

#pragma -------- 标签的信息类
@interface TagInfo : NSObject

@property(nonatomic, copy) NSString * name;
@property(nonatomic, strong) id value;

@end

@interface TagLayout : MyRelativeLayout

@property(nonatomic, readonly) MyFlowLayout * flowLayout;

@end
