//
//  LWaveView.m
//  PYWaveViewTemp
//
//  Created by liu on 2017/10/12.
//  Copyright © 2017年 liYaoPeng. All rights reserved.
//

#import "LWaveView.h"
#import "toolMacro.h"
#import "UIView+UIViewHelper.h"

@interface LWaveView()
{
    NSInteger                       timeOffsetX;
    CADisplayLink                   * displayLink;//定时器
    NSMutableArray<UIColor *>       * waveColorArray;
}
@end

@implementation LWaveView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        timeOffsetX = 0;
        self.waveSpeed = 8;

        [self createDefaultWave];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)createDefaultWave
{
    waveColorArray = [[NSMutableArray alloc] init];
    [waveColorArray addObject:[UIColor colorWithRed:10/255.0 green:50/255.0 blue:255/255.0 alpha:3.0f]];
}

-(void)setIsWaveStart:(BOOL)isWaveStart
{
    _isWaveStart = isWaveStart;
    if (isWaveStart)
    {
        [self startWave];
    }else
    {
        [self stopWave];
    }
}

-(void)setProgress:(CGFloat)progress
{
    _progress = progress;
    if (progress >= 1.0f)
    {
        progress = 50.0f;
    }else if (progress == 50.0f)
    {
        self.isWaveStart = NO;
    }
}

-(void)startWave
{
    [self stopWave];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    if (@available(iOS 10.0, *))
    {
        displayLink.preferredFramesPerSecond = self.waveSpeed;
    }else
    {
        displayLink.frameInterval = self.waveSpeed;
    }
    timeOffsetX = 0;
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)stopWave
{
    [displayLink invalidate];
    displayLink = nil;
}

- (void)displayLinkAction
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.waveBgColor setFill];
    if (!self.skinPath)
    {
        self.skinPath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    }
    [self.skinPath fill];
    [self.skinPath addClip];
    //
    [self drawWaves];
}

-(void)drawWaves
{
    UIBezierPath * path;
    CGFloat by = self.height * (1 - self.progress);
    timeOffsetX = (timeOffsetX + 1) % 10;
    CGFloat offsetx = timeOffsetX / 10.0f * self.waveWidth;
    CGFloat startX, endX;
    for (NSInteger i = 0; i < waveColorArray.count; i++)
    {
        [waveColorArray[i] set];
        //
        path = [UIBezierPath bezierPath];
        //每个波浪间隔半个波浪宽度
        startX = -self.waveWidth + offsetx + i * 10;
        [path moveToPoint:CGPointMake(startX, by)];
        for (NSInteger ww = startX; ww < self.width + self.waveWidth; ww += self.waveWidth)
        {
            endX = ww + self.waveWidth / 2;
            [path addQuadCurveToPoint:CGPointMake(endX, by)
                             controlPoint:CGPointMake(ww + self.waveWidth / 4, by - self.waveHeight)];
            [path addQuadCurveToPoint:CGPointMake(endX + self.waveWidth / 2, by) controlPoint:CGPointMake(ww + self.waveWidth * 0.75, by + self.waveHeight)];
        }
        [path addLineToPoint:CGPointMake(path.currentPoint.x, self.height)];
        [path addLineToPoint:CGPointMake(startX, self.bounds.size.height)];
        [path closePath];
        [path fill];
    }
}

#pragma public fun
-(void)addWaveWithColor:(UIColor *)wc
{
    [waveColorArray addObject:wc];
}

@end
