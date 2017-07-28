//
//  CarouselView.m
//  cjcr
//
//  Created by liu on 16/7/11.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "CarouselView.h"
#import "UIView+UIViewHelper.h"
#import "toolMacro.h"
#import "UIImageView+WebCache.h"
#import "NSObject+NSObjectHelper.h"

@interface CarouselView()<UIScrollViewDelegate>
{
    NSArray<NSString *>         * _dataItems;
    //
    NSTimer                     * _playTimer;
    BOOL                        _isAutoScroll;
    //
    NSArray<UIView *>           * _views;
    //
    UIScrollView                * _sv_content;
    UIPageControl               * _pageControl;
    //
    NSInteger                   _currentIndex;
    BOOL                        _isImageContent;
    BOOL                        _isInitCotentView;
    //
    int                         _pageLocation;
    CGFloat                     _pageSpace;
}
@end

@implementation CarouselView

-(void)initScrollView
{
    _sv_content = [[UIScrollView alloc] init];
    _sv_content.bounces = NO;
    _sv_content.showsHorizontalScrollIndicator = NO;
    _sv_content.showsVerticalScrollIndicator = NO;
    _sv_content.pagingEnabled = YES;
    _sv_content.delegate = self;
    [self addSubview:_sv_content];
}

-(void)initViewWithClass:(Class)cls
{
     _isInitCotentView = YES;
    _views = @[[[cls alloc] init],[[cls alloc] init],[[cls alloc] init]];
    UITapGestureRecognizer * tap;
    NSInteger i = 0;
    for (UIView * v in _views)
    {
        [_sv_content addSubview:v];
        v.userInteractionEnabled = YES;
        v.tag = i++;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [v addGestureRecognizer:tap];
    }
}

-(void)initPageControl
{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.currentPage = 0;
    _pageControl.enabled = NO;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
}

- (void)animalPlayImage
{
    if (_dataItems.count == 0)return;
    [_sv_content setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
    _isAutoScroll = YES;
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _currentIndex = 0;
        _isInitCotentView = NO;
        [self initScrollView];
        [self initPageControl];
    }
    return self;
}

-(void)layoutSubviews
{
    _sv_content.frame = self.bounds;
    _sv_content.contentSize = CGSizeMake(self.width * 3, 0);
    if (_views.count == 0)
    {
        return;
    }
    CGFloat h = self.height;
    if (!_isImageContent)
    {
        h -= PTTO6SW(30);
    }
    for (NSUInteger i = 0; i < _views.count; i++)
    {
        _views[i].frame = CGRectMake(self.width * i, 0, self.width, h);
    }
    _sv_content.contentOffset = CGPointMake(self.width, 0);
    
    //
    CGFloat pageWidth = _dataItems.count * 20;
    CGRect frame = CGRectZero;
    switch (_pageLocation)
    {
        case CV_PAGE_LOC_LEFT:
            frame = CGRectMake(_pageSpace, self.height - 20, pageWidth, 20);
            break;
        case CV_PAGE_LOC_RIGHT:
            frame = CGRectMake(self.width - pageWidth - _pageSpace, self.height - 20, pageWidth, 20);
            break;
        case CV_PAGE_LOC_MIDDLE:
            frame = CGRectMake((self.width - pageWidth) / 2, self.height - 20, pageWidth, 20);
            break;
    }
    _pageControl.frame = frame;
}

-(void)setPageLocation:(int)pl space:(CGFloat)space
{
    _pageSpace = space;
    _pageLocation = pl;
    [self setNeedsLayout];
}

-(void)setDatas:(NSArray<NSString *> *)datas
{
    _dataItems = datas;
    if (datas == nil || datas.count == 0)
    {
        return;
    }
    if (datas.count == 1)
    {
        [self setContentWithLeft:-1 centerIndex:0 rightIndex:-1];
        [self setNeedsLayout];
        return;
    }
    if (datas.count == 2)
    {
        [self setContentWithLeft:1 centerIndex:0 rightIndex:1];
    }else
    {
        [self setContentWithLeft:datas.count - 1 centerIndex:_currentIndex rightIndex:_currentIndex + 1];
    }
    _pageControl.numberOfPages = datas.count;
    
    [self setNeedsLayout];
}

-(void)setImageDatas:(NSArray<NSString *> *)datas
{
    _isImageContent = YES;
    if (!_isInitCotentView || ![_views[0] isKindOfClass:[UIImageView class]])
    {
        _views = nil;
        [self initViewWithClass:[UIImageView class]];
    }
    //
    [self setDatas:datas];
}

-(void)setLabelDatas:(NSArray<NSString *> *)datas font:(UIFont *)font textColor:(UIColor *)tc
{
    _isImageContent = NO;
    if (!_isInitCotentView || ![_views[0] isKindOfClass:[UILabel class]])
    {
        [self initViewWithClass:[UILabel class]];
        for (UILabel * lab in _views)
        {
            lab.font = font;
            lab.textColor = tc;
            lab.textAlignment = NSTextAlignmentCenter;
        }
    }
    [self setDatas:datas];
    [self setNeedsLayout];
}

-(BOOL)isHttpIndex:(NSInteger)index
{
    NSString * url = _dataItems[index];
    return [url hasPrefix:@"http"];
}

-(void)setContentWithLeft:(NSInteger)left centerIndex:(NSInteger)center rightIndex:(NSInteger)right
{
    if (_isImageContent)
    {
        if (left >= 0 && left < _dataItems.count)
        {
            if ([self isHttpIndex:left])
            {
                [((UIImageView *)_views[0]) sd_setImageWithURL:[NSURL URLWithString:_dataItems[left]]];
            }else
            {
                ((UIImageView *)_views[0]).image = OIMG_STR(_dataItems[left]);
            }
        }
        if (center >= 0 && center < _dataItems.count)
        {
            if ([self isHttpIndex:center])
            {
                [((UIImageView *)_views[1]) sd_setImageWithURL:[NSURL URLWithString:_dataItems[center]]];
            }else
            {
                ((UIImageView *)_views[1]).image = OIMG_STR(_dataItems[center]);
            }
        }
        if (right >= 0 && right < _dataItems.count)
        {
            if ([self isHttpIndex:right])
            {
                [((UIImageView *)_views[2]) sd_setImageWithURL:[NSURL URLWithString:_dataItems[right]]];
            }else
            {
                ((UIImageView *)_views[2]).image = OIMG_STR(_dataItems[right]);
            }
        }
    }else
    {
        if (left >= 0 && left < _dataItems.count)
        {
            ((UILabel *)_views[0]).text = _dataItems[left];
        }
        if (center >= 0 && center < _dataItems.count)
        {
            ((UILabel *)_views[1]).text = _dataItems[center];
        }
        if (right >= 0 && right < _dataItems.count)
        {
            ((UILabel *)_views[2]).text = _dataItems[right];
        }
    }
    _sv_content.contentOffset = CGPointMake(self.width, 0);
}

-(void)autoPlayWithSec:(NSUInteger)sec
{
    if (_playTimer == nil)
    {
        self.autoPlaySec = sec;
        _playTimer = [NSTimer scheduledTimerWithTimeInterval:sec target:self selector:@selector(animalPlayImage) userInfo:nil repeats:YES];
        _isAutoScroll = NO;
    }
    [_playTimer fire];
}

-(void)stopAutoPlay
{
    if (_playTimer)
    {
        [_playTimer invalidate];
        _playTimer = nil;
    }
}

-(void)next
{
    [_sv_content setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
    WEAKOBJ(self);
    [self performUIAsync:^{
        [weak_self scrollViewDidEndDecelerating:_sv_content];
    } time:0.5];
    
}

-(void)last
{
    [_sv_content setContentOffset:CGPointMake(0, 0) animated:YES];
    [self performUIAsync:^{
        [self scrollViewDidEndDecelerating:_sv_content];
    } time:0.5];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat x = _sv_content.contentOffset.x;
    if (x >= self.width * 2)
    {
        _currentIndex++;
        if (_currentIndex == _dataItems.count - 1)
        {
            [self setContentWithLeft:_currentIndex - 1 centerIndex:_currentIndex rightIndex:0];
        }else if (_currentIndex == _dataItems.count)
        {
            _currentIndex = 0;
            [self setContentWithLeft:_dataItems.count - 1 centerIndex:0 rightIndex:1];
        }else
        {
            [self setContentWithLeft:_currentIndex - 1 centerIndex:_currentIndex rightIndex:_currentIndex + 1];
        }
        _pageControl.currentPage = _currentIndex;
    }else if (x <= 0)
    {
        _currentIndex--;
        if (_currentIndex == 0)
        {
            [self setContentWithLeft:_dataItems.count - 1 centerIndex:0 rightIndex:1];
        }else if (_currentIndex == -1)
        {
            _currentIndex = _dataItems.count - 1;
            [self setContentWithLeft:_currentIndex - 1 centerIndex:_currentIndex rightIndex:0];
        }else
        {
            [self setContentWithLeft:_currentIndex - 1 centerIndex:_currentIndex rightIndex:_currentIndex + 1];
        }
        _pageControl.currentPage = _currentIndex;
    }
    //
    if (!_isAutoScroll && _playTimer != nil)
    {
        [_playTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.autoPlaySec]];
    }
    _isAutoScroll = NO;
}

-(void)viewClick:(UITapGestureRecognizer *)tap
{
    if ([_views[0] isKindOfClass:[UIImageView class]])
    {
        [self.delegate carouselView:self clickImageOnPageIndex:_pageControl.currentPage];
    }else
    {
        [self.delegate carouselView:self clickLabelOnPageIndex:_pageControl.currentPage];
    }
}

@end
