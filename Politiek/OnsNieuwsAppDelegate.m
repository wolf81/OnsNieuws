//
//  PolitiekAppDelegate.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/6/11.
//  Copyright 2012 Wolfgang Schreurs. All rights reserved.
//

#import "OnsNieuwsAppDelegate.h"
#import "Reachability.h"

#import <AVFoundation/AVFoundation.h>


@interface OnsNieuwsAppDelegate ()

@end


@implementation OnsNieuwsAppDelegate
{
    Reachability *_hostReach;
}

@synthesize window = _window, facebook, audioPlayer;

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidFinishLaunching:(UIApplication *)application
{   
    // setup application defaults for appearance, look & feel, etc ...
    
    UIColor *tintColor = [UIColor colorWithRed:40.0f/255 green:115.0f/255 blue:185.0f/255 alpha:1.0f];
    [[UINavigationBar appearance] setTintColor:tintColor];    
    [[UIBarButtonItem appearance] setTintColor:tintColor];
    [[UIButton appearance] setTintColor:tintColor];    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    
    // enable reachability notifications - TODO: figure out if we really need this
    
	_hostReach = [Reachability reachabilityWithHostName:HOST];
    _hostReach.reachableBlock = ^ (Reachability *reachability) 
    {
        DLog(@"host is reachable");
    };
    
    _hostReach.unreachableBlock = ^ (Reachability *reachability) 
    {
        DLog(@"host is not reachable");
        [UIAlertView showAlertWithTitle:@"Geen verbinding" message:@"Kan geen verbinding maken met server. Controleer of uw internetverbinding werkt." cancelButtonTitle:@"OK"];
    };
    
    [_hostReach startNotifier];
    
    

    // setup facebook
    
    facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) 
    {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if (![facebook isSessionValid]) {
        NSArray *permissions = [NSArray arrayWithObject:@"publish_stream"];
        [facebook authorize:permissions];
    }

    
    
    // setup audio player
    
    audioPlayer = [[AudioPlayerViewController alloc] init];
    CGRect frame = self.window.rootViewController.view.frame;
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    audioPlayer.view.frame = CGRectMake(0.0f, frame.size.height - tabBarHeight, 320.0f, 40.0f);
    [self.window.rootViewController.view insertSubview:audioPlayer.view belowSubview:tabBarController.tabBar];
    
    
    
    // add support for background audio - TODO: change category when no audio is playing / audio is started?
    
    NSError *error = nil;    
    AVAudioSession *audio = [[AVAudioSession alloc]init];
    [audio setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audio setActive:YES error:&error];
    DLog(@"%@", error);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    [_hostReach stopNotifier];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    [_hostReach startNotifier];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [facebook handleOpenURL:url];
}

#pragma mark - Facebook delegate

- (void)fbDidLogin
{
    DLog(@"facebook: did login");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidLogout
{
    DLog(@"facebook: did logout");
}

- (void)fbDidNotLogin:(BOOL)cancelled
{
    DLog(@"facebook: did not login");
}

@end
