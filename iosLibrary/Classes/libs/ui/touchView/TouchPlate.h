//
//  TouchPlate.h
//  cjcr
//
//  Created by liu on 16/7/28.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchTextView.h"

@protocol TouchPlateDelegate <NSObject>

-(void)doubleTapTouchTextView:(TouchTextView *)ttv;

@end

@interface TouchPlate : UIView

@property(weak,nonatomic) id<TouchPlateDelegate> delegate;
@property(assign,nonatomic) BOOL isEditable;

-(TouchTextView *)getSelectView;
-(void)removeSelectView;
-(UIImage *)outImageOnBgImage:(UIImage *)bgImage bgRect:(CGRect)bgRc;

@end
