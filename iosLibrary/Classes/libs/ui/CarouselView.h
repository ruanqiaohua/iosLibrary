//
//  CarouselView.h
//  cjcr
//
//  Created by liu on 16/7/11.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CV_PAGE_LOC_LEFT       1
#define CV_PAGE_LOC_MIDDLE     0
#define CV_PAGE_LOC_RIGHT      2

@class CarouselView;

@protocol CarouselDelegate <NSObject>

-(void)carouselView:(CarouselView *)view clickImageOnPageIndex:(NSUInteger)page;
-(void)carouselView:(CarouselView *)view clickLabelOnPageIndex:(NSUInteger)page;

@end

@interface CarouselView : UIView

-(void)setImageDatas:(NSArray<NSString *> *)datas;
-(void)setLabelDatas:(NSArray<NSString *> *)datas font:(UIFont *)font textColor:(UIColor *)tc;
-(void)setPageLocation:(int)pl space:(CGFloat)space;
-(void)autoPlayWithSec:(NSUInteger)sec;
-(void)stopAutoPlay;
-(void)next;
-(void)last;

@property(weak,nonatomic) id<CarouselDelegate> delegate;
@property(assign,nonatomic) NSUInteger autoPlaySec;

@end
