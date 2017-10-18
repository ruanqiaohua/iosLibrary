//
//  TestTouchTextView.m
//  cjcr
//
//  Created by liu on 16/8/2.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "TouchTextView.h"
#import "UIView+UIViewHelper.h"
#import "Utils.h"

#define CTRL_STATE_INIT         0
#define CTRL_STATE_ZOOM         1
#define CTRL_STATE_DRAG         2

#define DEFAULT_FRAME_WIDTH     1
#define DEFAULT_FRAME_COLOR     0xffaad993

#define TEXT_ORIENTATION_HOR    0
#define TEXT_ORIENTATION_VER    1

@interface TouchTextView()
{
    CGPoint                 _selfCenter;
    CGPoint                 _downPoint;
    UIImageView             * _iv_close;
    UIImageView             * _iv_scale;
    //
    int                     _ctrl_state;
    //frame
    CGFloat                 _frameColorRed;
    CGFloat                 _frameColorGreen;
    CGFloat                 _frameColorBlue;
    CGFloat                 _frameWidth;
    //text
    UIFont                  * _textFont;
    UIColor                 * _textColor;
    NSString                * _drawText;
    NSUInteger              _orientation; //0 hor , 1 ver
    //
    CGAffineTransform       _transScale;
    CGAffineTransform       _transRotate;
    CGRect                  _drawTextRect;
    CGFloat                 _degree;
}
@end

@implementation TouchTextView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _iv_scale = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_scale"]];
        [self addSubview:_iv_scale];
        _iv_close = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ico_close_text"]];
        [self addSubview:_iv_close];
        
        _ctrl_state = CTRL_STATE_INIT;
        [self setFrameColor:DEFAULT_FRAME_COLOR frameWidth:DEFAULT_FRAME_WIDTH];
        //
        _transScale = CGAffineTransformIdentity;
        _transRotate = CGAffineTransformIdentity;
        //
        _textColor = [UIColor blackColor];
    }
    return self;
}

-(void)setIsEditable:(BOOL)isEditable
{
    _isEditable = isEditable;
    _iv_close.hidden = isEditable ? NO : YES;
    _iv_scale.hidden = _iv_close.hidden;
    [self setNeedsDisplay];
}

-(void)setText:(NSString *)text textColor:(UIColor *)color isVertical:(BOOL)isVer font:(UIFont *)font
{
    _drawText = text;
    _textColor = color;
    _textFont = font;
    
    _orientation = isVer ? TEXT_ORIENTATION_VER : TEXT_ORIENTATION_HOR;
    [self caleRectWithScale:1 radian:0];
}

-(void)setText:(NSString *)text
{
    if (![_drawText isEqualToString:text])
    {
        _drawText = text;
        _selfCenter = self.center;
        [self caleRectWithScale:1 radian:0];
    }
}

-(void)setFrameColor:(NSUInteger)color frameWidth:(CGFloat)fw
{
    _frameColorRed = ((color & 0xFF0000) >> 16) / 255.0;
    _frameColorGreen = ((color & 0x00FF00) >> 8) / 255.0;
    _frameColorBlue = (color & 0x0000FF) / 255.0;
    _frameWidth = fw;
}

-(void)setFont:(UIFont *)font
{
    _textFont = font;
    _selfCenter = self.center;
    [self caleRectWithScale:1 radian:0];
    [self setNeedsDisplay];
}

-(void)setTextColor:(UIColor *)color
{
    CGFloat a = 0;
    [_textColor getWhite:NULL alpha:&a];
    _textColor = [color colorWithAlphaComponent:a];
    [self setNeedsDisplay];
}

-(void)setTextAlpha:(int)alpha
{
    if (alpha < 0) alpha = 0;
    else if (alpha > 1) alpha = 1;
    _textColor = [_textColor colorWithAlphaComponent:alpha];
}

-(void)addTextAlpha:(int)alpha
{
    CGFloat a = 0;
    [_textColor getWhite:NULL alpha:&a];
    [self setTextAlpha:a + alpha];
}

-(void)setVertical
{
    if (_orientation != TEXT_ORIENTATION_VER)
    {
        _orientation = TEXT_ORIENTATION_VER;
        _selfCenter = self.center;
        [self caleRectWithScale:1 radian:0];
    }
}

-(void)setHorizontal
{
    if (_orientation != TEXT_ORIENTATION_HOR)
    {
        _orientation = TEXT_ORIENTATION_HOR;
        _selfCenter = self.center;
        [self caleRectWithScale:1 radian:0];
    }
}

-(CGFloat)getFontSize
{
    return _textFont.pointSize;
}

///////////////////////////////////////////////////////////////////
-(NSString *)formatVerticalText:(NSString *)text
{
    NSMutableString * str = [[NSMutableString alloc] init];
    UniChar c;
    for (NSUInteger i = 0; i < text.length; i++)
    {
        c = [text characterAtIndex:i];
        [str appendFormat:@"%C", c];
        if (i + 1 != text.length)
        {
            [str appendString:@"\n"];
        }
    }
    return str;
}

-(CGSize)getContentSize
{
    if (_orientation == TEXT_ORIENTATION_VER)
    {
        NSRange range = [_drawText rangeOfString:@"\n"];
        if (range.length == 0)
        {
            _drawText = [self formatVerticalText:_drawText];
        }
    }else
    {
        _drawText = [_drawText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return [Utils calSizeWithText:_drawText font:_textFont maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
}

-(void)caleRectWithScale:(CGFloat)scale radian:(CGFloat)radian
{
    CGFloat of = _textFont.pointSize / _transScale.a;
    _transScale = CGAffineTransformScale(_transScale, scale, scale);
    scale = _transScale.a;
    _textFont = [_textFont fontWithSize:of * scale];
    CGSize size = [self getContentSize];
    CGFloat ow = size.width + _iv_close.width;
    CGFloat oh = size.height + _iv_scale.width + _iv_close.width;
    
    _transRotate = CGAffineTransformRotate(_transRotate, radian);
    radian = atan2f(_transRotate.b, _transRotate.a);
    _degree = radian * (180 / M_PI);
    
    
    CGPoint center = CGPointMake(ow / 2, oh / 2);
    
    self.frameLT = CGPointMake(center.x - size.width / 2.0, center.y - size.height / 2.0 - _iv_close.width / 2);
    self.frameRT = CGPointMake(self.frameLT.x + size.width, self.frameLT.y);
    self.frameLB = CGPointMake(self.frameLT.x, center.y + size.height / 2.0 + _iv_scale.width / 2);
    self.frameRB = CGPointMake(self.frameRT.x, self.frameLB.y);
    
    self.frameLT = [self caleRoationPoint:self.frameLT center:center degree:_degree];
    self.frameRT = [self caleRoationPoint:self.frameRT center:center degree:_degree];
    self.frameLB = [self caleRoationPoint:self.frameLB center:center degree:_degree];
    self.frameRB = [self caleRoationPoint:self.frameRB center:center degree:_degree];
    
    CGFloat w = MAX(fabs(self.frameLT.x - self.frameRB.x), fabs(self.frameRT.x - self.frameLB.x)) + _iv_close.width;
    CGFloat h = MAX(fabs(self.frameLT.y - self.frameRB.y), fabs(self.frameRT.y - self.frameLB.y)) + _iv_scale.width;
    
    self.frame = CGRectMake(0, 0, w, h);
    self.center = _selfCenter;
    
    center = CGPointMake(w / 2, h / 2);
    
    self.frameLT = CGPointMake(center.x - size.width / 2.0, center.y - size.height / 2.0 - _iv_close.width / 2);
    self.frameRT = CGPointMake(self.frameLT.x + size.width, self.frameLT.y);
    self.frameLB = CGPointMake(self.frameLT.x, center.y + size.height / 2.0 + _iv_scale.width / 2);
    self.frameRB = CGPointMake(self.frameRT.x, self.frameLB.y);
    
    self.frameLT = [self caleRoationPoint:self.frameLT center:center degree:_degree];
    self.frameRT = [self caleRoationPoint:self.frameRT center:center degree:_degree];
    self.frameLB = [self caleRoationPoint:self.frameLB center:center degree:_degree];
    self.frameRB = [self caleRoationPoint:self.frameRB center:center degree:_degree];
    
    _iv_close.center = self.frameLT;
    _iv_scale.center = self.frameRB;
    
    _drawTextRect = CGRectMake((w - size.width) / 2, (h - size.height) / 2, size.width, size.height);
}

///////////////////////////////////////////////////////////////////
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isEditable) return;
    UITouch * touch = [touches anyObject];
    _downPoint = [touch locationInView:self];
    if (CGRectContainsPoint(_iv_close.frame, _downPoint))
    {
        [self.delegate removeTouchTextView:self];
        return;
    }
    _ctrl_state = CGRectContainsPoint(_iv_scale.frame, _downPoint) ? CTRL_STATE_ZOOM : CTRL_STATE_DRAG;
    _selfCenter = self.center;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.isEditable) return;
    UITouch * touch = [touches anyObject];
    
    CGPoint center = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
    CGPoint currentTouchPoint = [touch locationInView:self];
    CGPoint previousTouchPoint = [touch previousLocationInView:self];
    
    if (_ctrl_state == CTRL_STATE_ZOOM)
    {
        CGFloat rotation = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
        
        CGFloat downPointDistance = [self distance4Point:center p2:previousTouchPoint];
        CGFloat curPointDistance = [self distance4Point:center p2:currentTouchPoint];
        CGFloat scale = curPointDistance / downPointDistance;
        
        [self caleRectWithScale:scale radian:rotation];
        [self setNeedsDisplay];
    }else
    {
        CGFloat offsetX = currentTouchPoint.x - previousTouchPoint.x;
        CGFloat offsetY = currentTouchPoint.y - previousTouchPoint.y;
        self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _ctrl_state = CTRL_STATE_INIT;
}

///////////////////////////////////////////////////////////////////
-(void)drawFrameWithContext:(CGContextRef)context lt:(CGPoint)lt rt:(CGPoint)rt lb:(CGPoint)lb rb:(CGPoint)rb redColor:(CGFloat)rc greenColor:(CGFloat)gc blueColor:(CGFloat)bc frameWidth:(CGFloat)fw
{
    CGContextSetRGBStrokeColor(context, rc, gc, bc, 1);
    CGContextSetLineWidth(context, fw);
    
    CGContextMoveToPoint(context, lt.x, lt.y);
    CGContextAddLineToPoint(context, rt.x, rt.y);
    CGContextAddLineToPoint(context, rb.x, rb.y);
    CGContextAddLineToPoint(context, lb.x, lb.y);
    CGContextAddLineToPoint(context, lt.x, lt.y);
    CGContextStrokePath(context);
}

-(void)drawText:(NSString *)text textRect:(CGRect)trc textColor:(UIColor *)tc textFont:(UIFont *)tf canvaSize:(CGSize)cs rotate:(CGFloat)rotate lineWidth:(CGFloat)lw context:(CGContextRef)context
{
    CGContextSetLineWidth(context, lw);
    
    CGContextTranslateCTM(context, cs.width / 2, cs.height / 2);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, -cs.width / 2, -cs.height / 2);
    
    [text drawInRect:trc withAttributes:@{NSFontAttributeName:tf,NSForegroundColorAttributeName:tc}];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.isEditable)
    {
        [self drawFrameWithContext:context lt:self.frameLT rt:self.frameRT lb:self.frameLB rb:self.frameRB redColor:_frameColorRed greenColor:_frameColorGreen blueColor:_frameColorBlue frameWidth:1];
    }
    [self drawText:_drawText textRect:_drawTextRect textColor:_textColor textFont:_textFont canvaSize:self.frame.size rotate:atan2f(_transRotate.b, _transRotate.a) lineWidth:1 context:context];
}

-(UIImage *)saveImageWithScale:(CGFloat)scale
{
    //CGPoint center = self.center;
    //[self caleRectWithScale:scale radian:0];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawText:_drawText textRect:_drawTextRect textColor:_textColor textFont:_textFont canvaSize:self.frame.size rotate:atan2f(_transRotate.b, _transRotate.a) lineWidth:1 context:context];
    UIImage * image =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //
    //[self caleRectWithScale:1 / scale radian:0];
    //self.center = center;
    
    
    return image;
}

///////////////////////////////////////////////////////////////////
-(CGFloat)distance4Point:(CGPoint)p1 p2:(CGPoint)p2
{
    CGFloat disX = p2.x - p1.x;
    CGFloat disY = p2.y - p1.y;
    double value = (disX * disX + disY * disY);
    return (CGFloat)sqrt(value);
}

/**
 * 弧度换算成角度
 * @return
 */
-(double)degreeFromRadian:(double)radian
{
    return radian * 180 / M_PI;
}

/**
 * 角度换算成弧度
 * @param degree
 * @return
 */
-(double)radianFromDegree:(double)degree
{
    return degree * M_PI / 180;
}

-(CGPoint)caleRoationPoint:(CGPoint)src center:(CGPoint)center degree:(CGFloat)degree
{
    //两者之间的距离
    CGPoint disPoint;
    disPoint.x = src.x - center.x;
    disPoint.y = src.y - center.y;
    
    //没旋转之前的弧度
    double originRadian = 0;
    
    //没旋转之前的角度
    double originDegree = 0;
    
    //旋转之后的角度
    double resultDegree = 0;
    
    //旋转之后的弧度
    double resultRadian = 0;
    
    //经过旋转之后点的坐标
    CGPoint resultPoint;
    
    double distance = sqrt(disPoint.x * disPoint.x + disPoint.y * disPoint.y);
    if (disPoint.x == 0 && disPoint.y == 0) // 第一象限
    {
        return center;
    } else if (disPoint.x >= 0 && disPoint.y >= 0) // 第二象限
    {
        // 计算与x正方向的夹角
        originRadian = asin(disPoint.y / distance);
    } else if (disPoint.x < 0 && disPoint.y >= 0) // 第三象限
    {
        // 计算与x正方向的夹角
        originRadian = asin(fabs(disPoint.x) / distance);
        originRadian = originRadian + M_PI / 2;
    } else if (disPoint.x < 0 && disPoint.y < 0)
    {
        // 计算与x正方向的夹角
        originRadian = asin(fabs(disPoint.y) / distance);
        originRadian = originRadian + M_PI;
    } else if (disPoint.x >= 0 && disPoint.y < 0)
    {
        // 计算与x正方向的夹角
        originRadian = asin(disPoint.x / distance);
        originRadian = originRadian + M_PI * 3 / 2;
    }
    
    // 弧度换算成角度
    originDegree = [self degreeFromRadian:originRadian];
    resultDegree = originDegree + degree;
    
    // 角度转弧度
    resultRadian = [self radianFromDegree:resultDegree];
    
    resultPoint.x = (int) round(distance * cos(resultRadian));
    resultPoint.y = (int) round(distance * sin(resultRadian));
    resultPoint.x += center.x;
    resultPoint.y += center.y;
    
    return resultPoint;
}

@end
