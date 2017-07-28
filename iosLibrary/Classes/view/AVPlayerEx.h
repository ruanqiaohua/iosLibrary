//
//  AVPlayerEx.h
//  cjcr
//
//  Created by liu on 16/11/28.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface AVPlayerEx : NSObject

@property(nonatomic,readonly) AVPlayerLayer * playLayer;

-(instancetype) initWithResUrl:(NSURL *)url;
-(void)play;
-(void)pause;
-(void)setIsRepeat:(BOOL)isRepeat;

@end
