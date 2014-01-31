//
//  NewsDetailViewController.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/12/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsItemHeaderCell.h"
#import "NewsItemMediaCell.h"
#import "NewsItemTextCell.h"
#import "NewsItemParser.h"
#import "OnsNieuwsAppDelegate.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Twitter/Twitter.h>


#define CELL_ITEM_TITLE_FONT_SIZE 15.0f
#define CELL_ITEM_TEXT_FONT_SIZE  15.0f
#define PADDING                   10.0f


@interface NewsDetailViewController ()
{
    id _audioPlayerWillShowObserver;
}

@property (nonatomic, copy)   NSString       *itemTitle;
@property (nonatomic, copy)   NSString       *itemText;
@property (nonatomic, strong) NSURL          *itemImageURL;
@property (nonatomic, copy)   NSMutableArray *itemMediaItems;

- (void)showMovieWithURL:(NSURL *)URL;
- (void)playAudioWithURL:(NSURL *)URL title:(NSString *)title;
- (void)shareNewsItem:(id)sender;
- (void)shareOnFacebook;

@end


@implementation NewsDetailViewController

@synthesize newsItem, itemText, itemTitle, itemImageURL, itemMediaItems;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem activityBarButtonItem];
    

    NewsItemParser *parser = [[NewsItemParser alloc] init];
    [parser parseNewsItem:self.newsItem completionHandler:^ 
     {
         self.itemTitle =      newsItem.title;
         self.itemText =       parser.text;
         self.itemImageURL =   parser.imageURL;
         self.itemMediaItems = parser.mediaItems;
         
         self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareNewsItem:)];
         
         [self.tableView reloadData];
     }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];     
    
    _audioPlayerWillShowObserver = 
    [[NSNotificationCenter defaultCenter] addObserverForName:kAudioPlayerWillShowNotification object:nil queue:[NSOperationQueue currentQueue] usingBlock:^ (NSNotification *note) 
    {
        NSArray *indexPaths = [self.tableView indexPathsForVisibleRows];
        NSIndexPath *indexPath = [indexPaths lastObject];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:_audioPlayerWillShowObserver name:kAudioPlayerWillShowNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([self.itemMediaItems count] > 0 ? 2 : 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    if (section == 0)
        return (itemTitle ? 1 : 0) + (itemText ? 1 : 0);
    else 
        return [self.itemMediaItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TextCell =   @"NewsItemTextCell";
    static NSString *HeaderCell = @"NewsItemHeaderCell";
    static NSString *MediaCell =  @"NewsItemMediaCell";
    
    NSString *CellIdentifier = nil;
    switch (indexPath.section) {
        case 0: 
            CellIdentifier = (indexPath.row == 0 ? HeaderCell : TextCell);
            break;
        default:
            CellIdentifier = MediaCell;
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        if (indexPath.section == 0 && indexPath.row == 0)
        {
            cell = [[NewsItemHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        else if (indexPath.section == 0 && indexPath.row == 1)
        {
            cell = [[NewsItemTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];        
        }        
        else 
        {
            cell = [[NewsItemMediaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        NewsItemHeaderCell *newsItemHeaderCell = (NewsItemHeaderCell *)cell;
        newsItemHeaderCell.imageURL = self.itemImageURL;
        newsItemHeaderCell.title =    self.itemTitle;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        NewsItemTextCell *newsItemTextCell = (NewsItemTextCell *)cell;
        newsItemTextCell.text = self.itemText;
    }
    else 
    {
        NewsItemMediaCell *newsItemMediaCell = (NewsItemMediaCell *)cell;
        newsItemMediaCell.media = [self.itemMediaItems objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) 
        return @"Media";
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        Media *media = [self.itemMediaItems objectAtIndex:indexPath.row];
        if ([media.extension isEqualToString:@"mp4"] && media.type == MediaTypeMovie)
        {
            [self showMovieWithURL:media.URL];
        }        
        else if ([media.extension isEqualToString:@"mp3"] && media.type == MediaTypeAudio)
        {
            [self playAudioWithURL:media.URL title:media.title];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return [NewsItemHeaderCell height];
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        CGFloat width = self.tableView.frame.size.width - ([NewsItemTextCell labelPadding] * 2);
        CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
        CGSize size = [self.itemText sizeWithFont:[NewsItemTextCell labelFont] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        
        return size.height + [NewsItemTextCell labelPadding];
    }
    
    return 44.0f;
}

#pragma mark - Private methods

- (void)showMovieWithURL:(NSURL *)URL
{
    OnsNieuwsAppDelegate *delegate = (OnsNieuwsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.audioPlayer pause];
    
    MPMoviePlayerViewController *viewController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
    [self.navigationController presentModalViewController:viewController animated:YES];    
}

- (void)playAudioWithURL:(NSURL *)URL title:(NSString *)title
{
    OnsNieuwsAppDelegate *appDelegate = (OnsNieuwsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.audioPlayer playAudioAtURL:URL withTitle:title];
}

- (void)shareNewsItem:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delen" 
                                                             delegate:self 
                                                    cancelButtonTitle:@"Annuleer" 
                                               destructiveButtonTitle:nil 
                                                    otherButtonTitles:@"Twitter", @"Facebook", nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

- (void)shareOnTwitter
{
    TWTweetComposeViewController *viewController = [[TWTweetComposeViewController alloc] init];
    [viewController setInitialText:self.newsItem.title];
    [viewController addURL:self.newsItem.URL];
    [viewController setCompletionHandler:^ (TWTweetComposeViewControllerResult result)
     {
         switch (result) 
         {
             case TWTweetComposeViewControllerResultDone:
             {
                 [UIAlertView showAlertWithTitle:@"Voltooid" message:@"Bericht succesvol geplaatst op Twitter" cancelButtonTitle:@"OK"];
             }
                 break;
             case TWTweetComposeViewControllerResultCancelled:
             default: 
                 break;                 
         }        
         
         [self dismissModalViewControllerAnimated:YES];
     }];        
    
    [self.navigationController presentModalViewController:viewController animated:YES];
}

- (void)shareOnFacebook
{
    NSString *URLString = [self.newsItem.URL absoluteString];
    
    OnsNieuwsAppDelegate *delegate = (OnsNieuwsAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       self.newsItem.title, @"message", 
                                       URLString,           @"link", 
                                       nil];
    [delegate.facebook requestWithGraphPath:@"me/feed" andParams:dictionary andHttpMethod:@"POST" andDelegate:self];
}

#pragma mark - Facebook request delegate

- (void)requestLoading:(FBRequest *)request
{
    DLog(@"%@", request);
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    [UIAlertView showAlertWithTitle:@"Voltooid" message:@"Bericht succesvol geplaatst op Facebook" cancelButtonTitle:@"OK"];
    
    DLog(@"%@", result);
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    [UIAlertView showAlertWithTitle:@"Fout opgetreden" message:@"Fout opgetreden bij het plaatsen van bericht op Facebook. Probeer later opnieuw." cancelButtonTitle:@"OK"];
    
    DLog(@"%@", error);
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    DLog(@"statusCode: %d", httpResponse.statusCode);
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: [self shareOnTwitter];  break;
        case 1: [self shareOnFacebook]; break;
        default: /* do nothing */ break;
    }
}

@end
