//
//  AudioPlayerViewController.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/18/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "AudioPlayerView.h"
#import "AudioPlayer.h"


NSString *const kAudioPlayerWillShowNotification = @"kAudioPlayerWillShowNotification";
NSString *const kAudioPlayerWillHideNotification = @"kAudioPlayerWillHideNotification";


@interface AudioPlayerViewController () <AudioPlayerDelegate>

@property (nonatomic, strong) AudioPlayerView *playerView;

- (void)playButtonTouched:(id)sender;
- (void)closeButtonTouched:(id)sender;
- (void)hidePlayer;

@end


@implementation AudioPlayerViewController

@synthesize playerView, isPlaying, isPlayerVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        playerView = [[AudioPlayerView alloc] initWithFrame:CGRectZero];
        
        [AudioPlayer sharedAudioPlayer].delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = playerView;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [playerView.playButton addTarget:self action:@selector(playButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [playerView.closeButton addTarget:self action:@selector(closeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Private methods

- (AudioPlayerView *)playerView
{
    return (AudioPlayerView *)self.view;
}

- (void)hidePlayer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioPlayerWillHideNotification object:nil];
    [self.playerView hidePlayer];
}

- (void)playButtonTouched:(id)sender
{
    DLog(@"play / pause");

    if ([AudioPlayer sharedAudioPlayer].isPlaying) 
    {
        [[AudioPlayer sharedAudioPlayer] pause];
    }
    else
    {
        [[AudioPlayer sharedAudioPlayer] play];
    }
    
    [self.playerView showPlayer];
}

- (void)closeButtonTouched:(id)sender
{
    DLog(@"close");

    if ([AudioPlayer sharedAudioPlayer].isPlaying)
        [[AudioPlayer sharedAudioPlayer] pause];
    
    [self hidePlayer];
}

#pragma mark - Instance methods

- (void)playAudioAtURL:(NSURL *)URL withTitle:(NSString *)title
{
    playerView.titleLabel.text = title;
    [[AudioPlayer sharedAudioPlayer] playAudioAtURL:URL];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioPlayerWillShowNotification object:nil];
    [playerView showPlayer];
}

- (void)pause
{
    [[AudioPlayer sharedAudioPlayer] pause];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAudioPlayerWillHideNotification object:nil];
    [playerView hidePlayer];
}

#pragma mark - Audio player delegate

- (void)audioPlayerDidStartPlaying
{
    DLog(@"did start playing");

    playerView.playButtonStyle = PlayButtonStylePause;    
}

- (void)audioPlayerDidStartBuffering
{
    DLog(@"did start buffering");

    playerView.playButtonStyle = PlayButtonStyleActivity;
}

- (void)audioPlayerDidPause
{
    DLog(@"did pause");
    
    playerView.playButtonStyle = PlayButtonStylePlay;
}

- (void)audioPlayerDidFinishPlaying
{
    [self hidePlayer];
}

#pragma mark - Properties

- (BOOL)isPlaying
{
    return [AudioPlayer sharedAudioPlayer].isPlaying;
}

- (BOOL)isPlayerVisible
{
    return !playerView.isPlayerHidden;
}

@end
