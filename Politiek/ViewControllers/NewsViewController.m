//
//  NewsViewController.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/15/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsDetailViewController.h"
#import "AFNetworking.h"
#import "NewsItem.h"
#import "OnsNieuwsAppDelegate.h"

#import <MediaPlayer/MediaPlayer.h>


@interface NewsViewController ()

@property (nonatomic, strong) NewsItem *currentItem;
@property (nonatomic, strong) NSMutableString *currentStringValue;
@property (nonatomic, copy) NSString *currentProperty;

- (void)showVideoStream:(id)sender;
- (NSArray *)newsItemsForSection:(NSInteger)section;
- (void)reload;
- (void)loadData;

@end


@implementation NewsViewController
@synthesize newsItems, currentItem, currentProperty, currentStringValue, sections, tableView;


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem activityBarButtonItem];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
    
    [super viewWillAppear:animated];   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSComparisonResult (^dateComparator)(NSDate *, NSDate *) = ^ (NSDate *firstDate, NSDate *secondDate) 
    {
        return [secondDate compare:firstDate]; 
    }; 
    
    NSArray *results = [self.newsItems valueForKeyPath:@"@distinctUnionOfObjects.publishDate"];    
    sections         = [results sortedArrayWithOptions:NSSortConcurrent usingComparator:dateComparator];
    
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    NSArray *results = [self newsItemsForSection:section];
    return results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *results      = [self newsItemsForSection:indexPath.section];
    
    NewsItem *item               = [results objectAtIndex:indexPath.row];
    cell.textLabel.text          = [item valueForProperty:kNITitleProperty];
    cell.textLabel.font          = [UIFont boldSystemFontOfSize:15.0f];
    cell.detailTextLabel.text    = nil;
    cell.textLabel.numberOfLines = 2;
    
    return cell;
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    static NSDateFormatter *formatter;
    if (!formatter)
    {
        formatter            = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEEE dd-MM-yyyy";
    }
    
    NSDate *date = [sections objectAtIndex:section];
    return [formatter stringFromDate:date];
}

#pragma mark - Segue?

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.identifier isEqualToString:@"NewsDetailViewController"])
    {
        NSIndexPath *indexPath                   = [self.tableView indexPathForSelectedRow];
        NSArray *items                           = [self newsItemsForSection:indexPath.section];
        NewsDetailViewController *viewController = (NewsDetailViewController *)[segue destinationViewController];
        viewController.newsItem                  = [items objectAtIndex:indexPath.row];
    } 
}

#pragma mark - XML parser delegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"item"])
    {
        self.currentItem = [[NewsItem alloc] init];
    }
    else if ([elementName isEqualToString:@"title"])
    {
        self.currentProperty = kNITitleProperty;
    }
    else if ([elementName isEqualToString:@"link"]) 
    {
        self.currentProperty = kNIURLProperty;
    }
    else if ([elementName isEqualToString:@"pubDate"])
    {
        self.currentProperty = kNIPubDateProperty;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        [self.newsItems addObject:self.currentItem];
        self.currentItem = nil;        
    }
    
    if (self.currentProperty) 
    {
        if (self.currentProperty == kNIPubDateProperty)
        {
            static NSDateFormatter *dateFormatter;
            if (!dateFormatter)
            {
                dateFormatter            = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = NEWS_DATE_FORMAT;
                dateFormatter.locale     = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
            }
            
            static NSCalendar *calendar;
            if(!calendar)
            {
                calendar          = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];            
                calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0]; // we'll use a normalized time here - time zone isn't of importance ....
            }
            
            NSDate *date                 = [dateFormatter dateFromString:self.currentStringValue];
            NSUInteger flags             = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
            NSDateComponents *components = [calendar components:flags fromDate:date];
            date                         = [calendar dateFromComponents:components];
            
            DLog(@"%@ > %@", self.currentStringValue, date);
            [self.currentItem setValue:date forProperty:kNIPubDateProperty];
        }
        else if (self.currentProperty == kNIURLProperty)
        {
            NSURL *URL = [NSURL URLWithString:self.currentStringValue];
            [self.currentItem setValue:URL forProperty:kNIURLProperty];
        }
        else 
        {
            DLog(@"%@: %@", self.currentProperty, self.currentStringValue);        
            [self.currentItem setValue:self.currentStringValue forProperty:self.currentProperty];        
        }
    }
    
    self.currentProperty = nil;
    self.currentStringValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.currentStringValue)
    {
        self.currentStringValue = [NSMutableString stringWithCapacity:50];
    }
    
    if (self.currentProperty && self.currentStringValue)
        [self.currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    DLog(@"%@", parseError);
    
    [UIAlertView showAlertWithTitle:@"Fout opgetreden" message:[parseError localizedDescription] cancelButtonTitle:@"OK"];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    DLog(@"started parsing");
    
    self.newsItems = [NSMutableArray array];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    DLog(@"successfully parsed");
    
    [self reload];
}

#pragma mark - Private methods

- (void)reload
{
    // make sure reload is always performed on main thread ...
    
    if ([NSThread isMainThread] == NO)
    {
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
        return;
    }
    
    
    // the "Video Stream" button is only displayed on the first tab ...
    
    if (self.tabBarController.selectedIndex == 0)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(showVideoStream:)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    // reload table view data ....

    [self.tableView reloadData];
}

- (void)showVideoStream:(id)sender
{
    // stop audio player, if it's running ...
    
    OnsNieuwsAppDelegate *delegate = (OnsNieuwsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.audioPlayer pause];
    
    
    // display video stream ...
    
    NSURL *URL                                  = [NSURL URLWithString:LIVE_STREAM_URL];
    MPMoviePlayerViewController *viewController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];    
    [self.navigationController presentModalViewController:viewController animated:YES];    
}

- (NSArray *)newsItemsForSection:(NSInteger)section
{
    NSDate *date           = [sections objectAtIndex:section];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"publishDate = %@", date];
    return [newsItems filteredArrayUsingPredicate:predicate];
}

- (void)loadData
{
    // code to be executed if request succeeds ...

    void (^successHandler)(NSURLRequest *, NSHTTPURLResponse *, NSXMLParser *) = ^ (NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *parser) 
    {
        DLog(@"%@", response.allHeaderFields);
        
        parser.delegate = self;
        
        [parser parse];                  
    };
    
    
    // code to be executed if request fails ...
    
    void (^failureHandler)(NSURLRequest *, NSHTTPURLResponse *, NSError *, NSXMLParser *) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, NSXMLParser *parser) 
    {
        DLog(@"%@", error);
        
        [self reload];
        
        [UIAlertView showAlertWithTitle:@"Fout opgetreden" message:error.localizedDescription cancelButtonTitle:@"OK"];
    };
    
    
    // configure & perform request ...

    NSString *URLString = nil;
    switch (self.tabBarController.selectedIndex) 
    {
        case 0: URLString = NEWS_FEED_POLITICS_URL; break;
        case 1: URLString = NEWS_FEED_INTERIOR_URL; break;
        case 2: URLString = NEWS_FEED_ABROAD_URL; break;
        case 3: URLString = NEWS_FEED_ECONOMY_URL; break;
        case 4: URLString = NEWS_FEED_SPORTS_URL; break;
        case 5: URLString = NEWS_FEED_ROYALTY_URL; break;
        case 6: URLString = NEWS_FEED_HEADLINES_URL; break;
        case 7: URLString = NEWS_FEED_NEWS_BULLETIN_URL; break;
        default: break;
    } 
    
    NSURL *feedURL                   = [NSURL URLWithString:URLString];
    NSURLRequest *request            = [NSURLRequest requestWithURL:feedURL];
    AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:successHandler failure:failureHandler];
    operation.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    [operation start];
}

@end
