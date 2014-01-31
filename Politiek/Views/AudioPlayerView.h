//
//  AudioPlayerView.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/18/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum 
{
    PlayButtonStylePlay = 0,
    PlayButtonStylePause,
    PlayButtonStyleActivity,
} PlayButtonStyle;


@interface AudioPlayerView : UIView

@property (nonatomic, strong) UIButton                *playButton;
@property (nonatomic, strong) UIButton                *closeButton;
@property (nonatomic, strong) UILabel                 *titleLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, assign) PlayButtonStyle         playButtonStyle;
@property (nonatomic, assign, readonly) BOOL          isPlayerHidden;

- (void)showPlayer;
- (void)hidePlayer;

@end
