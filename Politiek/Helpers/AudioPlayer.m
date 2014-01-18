//
//  AudioPlayer.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/14/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>


@interface AudioPlayer ()
- (void)playerItemDidFinishPlaying:(id)sender;
@end


@implementation AudioPlayer
{
    AVPlayer *player;
}

@synthesize isPlaying, delegate;

+ (AudioPlayer *)sharedAudioPlayer
{
    static dispatch_once_t pred;
    static AudioPlayer *sharedAudioPlayer = nil;
    dispatch_once(&pred, ^
    { 
        sharedAudioPlayer = [[self alloc] init]; 
        
        [[NSNotificationCenter defaultCenter] addObserver:sharedAudioPlayer selector:@selector(playerItemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    });
    return sharedAudioPlayer;
}

- (void)playAudioAtURL:(NSURL *)URL
{
    if (player)
    {
        [player removeObserver:self forKeyPath:@"status"];
        [player pause];
    }
    
    player = [AVPlayer playerWithURL:URL];
    [player addObserver:self forKeyPath:@"status" options:0 context:nil];
        
    if (delegate && [delegate respondsToSelector:@selector(audioPlayerDidStartBuffering)])
        [delegate audioPlayerDidStartBuffering];
}

- (void)play
{
    if (player) 
    {
        [player play];

        if (delegate && [delegate respondsToSelector:@selector(audioPlayerDidStartPlaying)])
            [delegate audioPlayerDidStartPlaying];
    }
}

- (void)pause
{
    if (player) 
    {
        [player pause];

        if (delegate && [delegate respondsToSelector:@selector(audioPlayerDidPause)])
            [delegate audioPlayerDidPause];
    }
}

- (BOOL)isPlaying
{
    DLog(@"%f", player.rate);
    
    return (player.rate > 0);
}

#pragma mark - AV player 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context 
{
    if (object == player && [keyPath isEqualToString:@"status"]) 
    {
        if (player.status == AVPlayerStatusReadyToPlay) 
        {
            [self play];
        }
    }
}

#pragma mark - Private methods

- (void)playerItemDidFinishPlaying:(id)sender
{
    DLog(@"%@", sender);
    
    if (delegate && [delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying)])
        [delegate audioPlayerDidFinishPlaying];
}

@end
