//
//  LWaveView.h
//  PYWaveViewTemp
//
//  Created by liu on 2017/10/12.
//  Copyright © 2017年 liYaoPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LWaveView : UIView

@property(nonatomic,assign) CGFloat waveSpeed;//波浪的速度，值越大越慢
@property(nonatomic,assign) BOOL isWaveStart;
@property(nonatomic,assign) CGFloat progress;
@property(nonatomic,strong) UIColor * waveBgColor;
@property(nonatomic,strong) UIBezierPath * skinPath;

#pragma  波浪设置
@property(nonatomic,assign) CGFloat waveWidth;//一个波浪的宽度
@property(nonatomic,assign) CGFloat waveHeight;//波浪的高度

-(void)addWaveWithColor:(UIColor *)wc;

@end
