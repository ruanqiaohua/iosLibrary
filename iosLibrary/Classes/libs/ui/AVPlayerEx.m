//
//  AVPlayerEx.m
//  cjcr
//
//  Created by liu on 16/11/28.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "AVPlayerEx.h"

@interface AVPlayerEx()
{
    AVPlayerItem    * playerItem;
    AVPlayer        * player;
    BOOL            _isRepeat;
}
@end

@implementation AVPlayerEx

-(instancetype) initWithResUrl:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        playerItem = [AVPlayerItem playerItemWithURL:url];
        player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        _playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        _playLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
    }
    return self;
}

-(void)play
{
    [player play];
}

-(void)pause
{
    [player pause];
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
}

-(void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)playbackFinished:(NSNotification *)notification
{
    [player seekToTime:CMTimeMake(0, 1)];
    [player play];
}

-(void)setIsRepeat:(BOOL)isRepeat
{
    if (_isRepeat != isRepeat)
    {
        _isRepeat = isRepeat;
        if (_isRepeat)
        {
            [self addNotification];
        }else
        {
            [self removeNotification];
        }
    }
}

@end
