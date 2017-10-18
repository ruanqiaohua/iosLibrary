//
//  TouchPlate.m
//  cjcr
//
//  Created by liu on 16/7/28.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "TouchPlate.h"
#import "UIImage+SubImage.h"
#import "UIView+UIViewHelper.h"
#define SELECT_X_SPACE  3
#define SELECT_Y_SPACE  3
#define ADD_OFFSET      20

@interface TouchPlate()<TouchTextViewDelegate>
{
    NSMutableArray                  * _overlapViewList;
    NSUInteger                      _curOverlapIndex;
    CGPoint                         _downPoint;
    BOOL                            _isSwitch;
    TouchTextView                   * _lastTouchWapper;
    TouchTextView                   * _selectView;
    NSUInteger                      indexCounter;
}
@end

@implementation TouchPlate

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
    }
    return self;
}

-(void)addSubview:(UIView *)view
{
    if ([view isKindOfClass:[TouchTextView class]])
    {
        ((TouchTextView *)view).isEditable = YES;
        ((TouchTextView *)view).delegate = self;
        NSUInteger count = self.subviews.count;
        if (count > 0)
        {
            ((TouchTextView *)self.subviews[count - 1]).isEditable = NO;
        }
        view.tag = indexCounter++;
        view.center = CGPointMake(self.width / 2 + count * ADD_OFFSET, self.height / 2 + count * ADD_OFFSET);
        [super addSubview:view];
    }
}

-(TouchTextView *)getSelectView
{
    if (self.subviews.count > 0)
    {
        return self.subviews[self.subviews.count - 1];
    }
    return nil;
}

-(NSMutableArray *)sort:(NSMutableArray *)ls
{
    NSComparator cmptr = ^(id obj1, id obj2)
    {
        if ([obj1 integerValue] > [obj2 integerValue])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    return [ls sortedArrayUsingComparator:cmptr].mutableCopy;
}

-(NSMutableArray *) getViewInPoint:(CGPoint)point
{
    NSUInteger count = self.subviews.count;
    if (count < 1)
    {
        return nil;
    }
    NSMutableArray * vl = [[NSMutableArray alloc] init];
    NSMutableArray<NSString *> * il = [[NSMutableArray alloc] init];
    TouchTextView * tw;
    for (NSInteger i = count - 1; i > -1; i--)
    {
        tw = self.subviews[i];
        if (CGRectContainsPoint(tw.frame, point))
        {
            [vl addObject:tw];
            [il addObject:[[NSString alloc] initWithFormat:@"%ld", (long)tw.tag]];
        }
    }
    if (vl.count == 0) return nil;
    il = [self sort:il];
    NSMutableString * ms = [[NSMutableString alloc] init];
    for (NSString * inx in il)
    {
        [ms appendString:inx];
    }
    [vl addObject:ms];
    return vl;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isEditable)
    {
        return self;
    }
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    _downPoint = [touch locationInView:self];
    _isSwitch = YES;
    NSMutableArray * list = [self getViewInPoint:_downPoint];
    if (list)
    {
        _selectView = (TouchTextView *) list[0];
        if (self.subviews[self.subviews.count - 1] != _selectView)
        {
            ((TouchTextView *)self.subviews[self.subviews.count - 1]).isEditable = NO;
            [self bringSubviewToFront:_selectView];
        }
        _selectView.isEditable = YES;
        [_selectView touchesBegan:touches withEvent:event];
    }else
    {
        _selectView = nil;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isSwitch = NO;
    if (_selectView)
    {
        UITouch * touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        _isSwitch = (fabs(_downPoint.x - point.x) <= SELECT_X_SPACE) && (fabs(_downPoint.y - point.y) < SELECT_X_SPACE);
        [_selectView touchesMoved:touches withEvent:event];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isSwitch)
    {
        UITouch * touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        
        NSMutableArray * list = [self getViewInPoint:point];
        if (list.count > 2)
        {
            if (_overlapViewList == nil || ![((NSMutableString *)_overlapViewList[_overlapViewList.count - 1]) isEqualToString:(NSMutableString *)list[_overlapViewList.count - 1]])
            {
                [_overlapViewList removeAllObjects];
                ((TouchTextView *)self.subviews[self.subviews.count - 1]).isEditable = NO;
                _overlapViewList = list;
                _curOverlapIndex = 0;
                _curOverlapIndex = _curOverlapIndex + 1 % (_overlapViewList.count - 1);
                _lastTouchWapper = ((TouchTextView *)_overlapViewList[_curOverlapIndex]);
                
            }else
            {
                _lastTouchWapper.isEditable = NO;
                _curOverlapIndex = (_curOverlapIndex + 1) % (_overlapViewList.count - 1);
                _lastTouchWapper = ((TouchTextView *)_overlapViewList[_curOverlapIndex]);
            }
            _lastTouchWapper.isEditable = YES;
            [self bringSubviewToFront:_lastTouchWapper];
        }
    }
    if (_selectView)
    {
        [_selectView touchesEnded:touches withEvent:event];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        UITouch * touch = [touches anyObject];
        //CGPoint touchPoint = [touch locationInView:self];
        if(touch.tapCount == 2 && self.delegate)
        {
            [self.delegate doubleTapTouchTextView:_selectView];
        }
    }
}

-(void)removeSelectView
{
    if (_selectView)
    {
        [_selectView removeFromSuperview];
        _selectView = nil;
    }
}

-(void)setIsEditable:(BOOL)isEditable
{
    _isEditable = isEditable;
    for (TouchTextView * ttv in self.subviews)
    {
        [ttv setIsEditable:isEditable];
    }
}

/*******************    TouchTextViewDelegate   ***********************/
-(void)removeTouchTextView:(TouchTextView *)ttv
{
    if (_selectView != ttv)
    {
        NSLog(@"tp, remove textview is error, select != remove");
        return;
    }
    [self removeSelectView];
}

-(UIImage *)outImageOnBgImage:(UIImage *)bgImage bgRect:(CGRect)bgRc
{
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawAtPoint:CGPointMake(0, 0)];
    CGFloat x,y,ws,hs;
    UIImage * image;
    for (TouchTextView * ttv in self.subviews)
    {
        ws = bgImage.size.width / bgRc.size.width;
        hs = bgImage.size.height / bgRc.size.height;
        
        x = (ttv.left - bgRc.origin.x) * ws;
        y = (ttv.top - bgRc.origin.y) * hs;
        
        image = [ttv saveImageWithScale:ws];
        image = [image rescaleImageToSize:CGSizeMake(image.size.width * ws, image.size.height * ws)];
        //image = [ImageToo scaleImage:image size:CGSizeMake(image.size.width * ws, image.size.height * ws)];
        [image drawAtPoint:CGPointMake(x,y)];
        image = nil;
    }
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
