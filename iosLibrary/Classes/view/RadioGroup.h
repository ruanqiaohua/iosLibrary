//
//  RadioGroup.h
//  yezhu
//
//  Created by liu on 2017/6/15.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <MyLayout/MyLayout.h>

@interface RadioGroup : MyLinearLayout

-(instancetype) initTitles:(NSArray<NSString *> *)titles textSize:(CGFloat)ts textColor:(UIColor *)tc selTextColor:(UIColor *)stc
                hLineColor:(UIColor *)hlc hSelLineColor:(UIColor *)hslc isLineTop:(BOOL)isTop hLineHeight:(CGFloat)hLineHeight
                    target:(id)target action:(SEL)action;

@end
