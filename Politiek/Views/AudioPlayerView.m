//
//  AudioPlayerView.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/18/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import "AudioPlayerView.h"


@implementation AudioPlayerView
{
    BOOL _isAnimating;
}

@synthesize playButton, closeButton, titleLabel, playButtonStyle, activityView, isPlayerHidden = _playerHidden;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"musicplayer_background.png"]];
        
        _playerHidden = YES;
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];        
        activityView.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
        [self addSubview:activityView];
        
        playButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [playButton setBackgroundImage:[UIImage imageNamed:@"button_pause.png"] forState:UIControlStateNormal];
        playButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:playButton];
        
        closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"button_close.png"] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        closeButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [self addSubview:closeButton];        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 240.0f, 30.0f)];
        titleLabel.text = nil;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{    
    
#define PADDING 5.0f
    
    DLog(@"%@", NSStringFromCGRect(self.bounds));
    CGRect frame = self.bounds;
    CGFloat y = frame.size.height / 2;
    
    titleLabel.center = CGPointMake(frame.size.width / 2, y);
    
    CGFloat x = titleLabel.frame.origin.x - (playButton.frame.size.width / 2) - PADDING;
    playButton.center = CGPointMake(x, y);
    activityView.center = CGPointMake(x, y);
    
    x = titleLabel.frame.origin.x + titleLabel.frame.size.width + (closeButton.frame.size.width / 2) + PADDING;
    closeButton.center = CGPointMake(x, y);
}

#pragma mark - Instance methods

- (void)showPlayer
{
    if (_isAnimating || _playerHidden == NO)
        return;
    
    _isAnimating = YES;
    
    [UIView 
     animateWithDuration:0.5f 
     animations:^ 
     {
         CGRect frame = self.frame;
         frame.origin.y -= 40.0f;
         self.frame = frame;         
     } 
     completion:^ (BOOL finished) 
     {
         _isAnimating = NO;
         _playerHidden = NO;    
     }];
}

- (void)hidePlayer
{
    if (_isAnimating || _playerHidden)
        return;
    
    _isAnimating = YES;
    
    [UIView 
     animateWithDuration:0.5f 
     animations:^ 
     {        
         CGRect frame = self.frame;
         frame.origin.y += 40.0f;
         self.frame = frame;
     }
     completion:^ (BOOL finished) 
     {
         _isAnimating = NO;
         _playerHidden = YES;    
     }];
}

- (void)setPlayButtonStyle:(PlayButtonStyle)style
{
    playButton.hidden = (style == PlayButtonStyleActivity);
    activityView.hidden = (style != PlayButtonStyleActivity);
    
    switch (style) 
    {
        case PlayButtonStyleActivity:
        {
            [activityView startAnimating];
        }
            break;
        case PlayButtonStylePause:
        {
            [activityView stopAnimating];
            
            [playButton setBackgroundImage:[UIImage imageNamed:@"button_pause.png"] forState:UIControlStateNormal];
        }
            break;
        case PlayButtonStylePlay:
        default:
        {
            [activityView stopAnimating];
            
            [playButton setBackgroundImage:[UIImage imageNamed:@"button_play.png"] forState:UIControlStateNormal];
        }
            break;
    }
    
    [self setNeedsLayout];
}

@end
