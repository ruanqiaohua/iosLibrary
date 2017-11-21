//
//  UIView+PlaceholderView.h
//  iosLibrary
//
//  Created by liu on 2017/10/12.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PlaceholderView)

-(void)setPlaceholderView:(UIView *)view type:(NSInteger)type;
-(void)showPlaceholderViewType:(NSInteger)type;
-(void)removePlaceholderView;

@end
