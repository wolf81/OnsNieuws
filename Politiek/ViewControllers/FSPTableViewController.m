//
//  FSPTableViewController.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/19/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "FSPTableViewController.h"
#import "OnsNieuwsAppDelegate.h"


@interface FSPTableViewController ()
@end


@implementation FSPTableViewController
{
    id _audioPlayerWillShowObserver;
    id _audioPlayerWillHideObserver;
}

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    OnsNieuwsAppDelegate *delegate = (OnsNieuwsAppDelegate *)[[UIApplication sharedApplication] delegate];
    CGFloat playerHeight = delegate.audioPlayer.view.frame.size.height;
    
    if (delegate.audioPlayer.isPlaying)
    {
        CGRect frame = self.view.bounds;
        frame.size.height -= playerHeight;
        
        if (CGRectEqualToRect(self.tableView.frame, frame) == NO)         
            self.tableView.frame = frame;
    }
    else 
    {
        CGRect frame = self.view.bounds;
        self.tableView.frame = frame;
    }
    
    
    _audioPlayerWillShowObserver = 
    [[NSNotificationCenter defaultCenter] addObserverForName:kAudioPlayerWillShowNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^ (NSNotification *note) 
     {                 
         CGRect frame = self.view.bounds;
         frame.size.height -= playerHeight;
         
         if (CGRectEqualToRect(self.tableView.frame, frame) == YES)
             return;
         
         [UIView animateWithDuration:0.3f animations:^ 
          {
              self.tableView.frame = frame;                       
          }];         
     }];


    _audioPlayerWillHideObserver = 
    [[NSNotificationCenter defaultCenter] addObserverForName:kAudioPlayerWillHideNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^ (NSNotification *note) 
     {         
         [UIView animateWithDuration:0.3f animations:^ 
          {
              CGRect frame = self.view.bounds;
              self.tableView.frame = frame;
          }];
     }];
}

- (void)viewDidDisappear:(BOOL)animated
{    
    [super viewDidDisappear:animated];
        
    [[NSNotificationCenter defaultCenter] removeObserver:_audioPlayerWillShowObserver name:kAudioPlayerWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:_audioPlayerWillHideObserver name:kAudioPlayerWillHideNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
