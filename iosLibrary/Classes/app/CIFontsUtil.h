//
//  UnifiedUtil.h
//  ryb
//
//  Created by liu on 16/5/23.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "toolMacro.h"

#define CIFU                    [CIFontsUtil sharedInst]
#define CIFU_GET(px,index)      [[CIFontsUtil sharedInst] getFontWithSize:PXTO6SW(px) fontIndex:index]

@interface CIFontsUtil : NSObject

@property(nonatomic, readonly) NSMutableArray<UIFont *> * fontSet;

singleton_interface

-(BOOL)loadDefault;
-(BOOL)addFonts:(NSArray<NSString *> *)fontPath;
-(UIFont *)getFontWithSize:(CGFloat)size fontIndex:(NSUInteger)index;

@end
