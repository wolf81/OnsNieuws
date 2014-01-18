//
//  AudioPlayer.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/14/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AudioPlayerDelegate;

@interface AudioPlayer : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign) id <AudioPlayerDelegate> delegate;

+ (AudioPlayer *)sharedAudioPlayer;

- (void)playAudioAtURL:(NSURL *)URL;
- (void)play;
- (void)pause;

@end



@protocol AudioPlayerDelegate <NSObject>
@optional
- (void)audioPlayerDidStartPlaying;
- (void)audioPlayerDidStartBuffering;
- (void)audioPlayerDidPause;
- (void)audioPlayerDidFinishPlaying;
@end