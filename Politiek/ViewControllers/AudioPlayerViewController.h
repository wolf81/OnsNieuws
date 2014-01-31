//
//  AudioPlayerViewController.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/18/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kAudioPlayerWillShowNotification;
extern NSString *const kAudioPlayerWillHideNotification;


@interface AudioPlayerViewController : UIViewController

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) BOOL isPlayerVisible;

- (void)playAudioAtURL:(NSURL *)URL withTitle:(NSString *)title;
- (void)pause;

@end
