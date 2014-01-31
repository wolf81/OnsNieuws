//
//  PolitiekAppDelegate.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/6/11.
//  Copyright 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayerViewController.h"
#import "FBConnect.h"


@class Reachability;

@interface OnsNieuwsAppDelegate : UIResponder 
    <UIApplicationDelegate, 
    FBSessionDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) Facebook *facebook;
@property (nonatomic, strong) AudioPlayerViewController *audioPlayer;

@end
