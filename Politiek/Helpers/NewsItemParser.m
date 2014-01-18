//
//  NewsItemParser.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/9/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import "NewsItemParser.h"
#import "AFNetworking.h"
#import "HTMLParser.h"



@interface NewsItemParser ()
- (void)parseVideoItemAtURL:(NSURL *)URL success:(void (^)(id object))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure;
- (NSArray *)parseMediaItemsInAudioNode:(HTMLNode *)node;
- (NSString *)parseTextInArticleContentNode:(HTMLNode *)node;
- (NSURL *)parseImageURLInArticleImageNode:(HTMLNode *)node;
- (void)parseMediaItemsInVideoNode:(HTMLNode *)node bodyNode:(HTMLNode *)bodyNode sourceURL:(NSURL *)URL parsedVideoHandler:(void (^)(Media *media))parsedMediaHandler;
@end


@implementation NewsItemParser
@synthesize text, imageURL, mediaItems = _mediaItems;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.mediaItems = [NSMutableArray array];
    }
    return self;
}

- (void)parseNewsItem:(NewsItem *)newsItem completionHandler:(completionHandler)block
{
    NSURLRequest *request = [NSURLRequest requestWithURL:newsItem.URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:TIMEOUT_INTERVAL];    
    DLog(@"loading: %@", [newsItem.URL absoluteString]); 
    
    
    if ([[newsItem.URL absoluteString] rangeOfString:@"/nosjournaalvideo/"].location != NSNotFound)
    {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation 
         setCompletionBlockWithSuccess:^ (AFHTTPRequestOperation *operation, id object) 
         {
             // create HTML parser object
             NSError *error = nil;
             HTMLParser *parser = [[HTMLParser alloc] initWithData:object error:&error];
             if (!parser)
             {
                 DLog(@"%@", error);
                 [UIAlertView showAlertWithTitle:@"Fout opgetreden" message:[error localizedDescription] cancelButtonTitle:@"OK"];             
                 return;
             }
              
             
             // parse URL
             NSString *string = [parser.body allContents];
             string = [string substringFromString:@"src=\"" toString:@"\""];
             NSURL *URL = [NSURL URLWithString:string];
             
             DLog(@"%@", URL);
             
             
             // parse title
             HTMLNode *node = [parser.body findChildTag:@"h1"];
             NSString *title = [node allContents];
             
             Media *media = [Media mediaWithType:MediaTypeMovie title:title URL:URL];
             [self.mediaItems addObject:media];
             
             
             
             if (block)
                 block();
         } 
         failure:^ (AFHTTPRequestOperation *operation, NSError *error) 
         {
             DLog(@"%@", error);
             
             if (block)
                 block();
         }];
        
        [operation start];
        
        DLog(@"need different parser here ...");
        return;
    }
    
    
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation 
     setCompletionBlockWithSuccess:^ (AFHTTPRequestOperation *operation, id object) 
     {
         // create HTML parser object
         NSError *error = nil;
         HTMLParser *parser = [[HTMLParser alloc] initWithData:object error:&error];
         if (!parser)
         {
             DLog(@"%@", error);
             [UIAlertView showAlertWithTitle:@"Fout opgetreden" message:[error localizedDescription] cancelButtonTitle:@"OK"];             
             return;
         }
         
         
         DLog(@"%@", parser.body);
         DLog(@"%@", [parser.body allContents]);
         
         // header image URL
         HTMLNode *node = [parser.body findChildWithAttribute:@"id" matchingName:@"article-image" allowPartial:NO];
         self.imageURL = [self parseImageURLInArticleImageNode:node];
         
         
         // article text
         node = [parser.body findChildWithAttribute:@"id" matchingName:@"article-content" allowPartial:NO];
         self.text = [self parseTextInArticleContentNode:node];         
         
         
         // video
         node = [parser.body findChildWithAttribute:@"id" matchingName:@"box-video-" allowPartial:YES];
         [self parseMediaItemsInVideoNode:node bodyNode:parser.body sourceURL:newsItem.URL parsedVideoHandler:^ (Media *media)
          {
              [self.mediaItems addObject:media];
              
              if (block)
                  block();
          }];
         
         
         // audio
         node = [parser.body findChildWithAttribute:@"class" matchingName:@"audio-list" allowPartial:NO];
         NSArray *mediaItems = [self parseMediaItemsInAudioNode:node];
         [self.mediaItems addObjectsFromArray:mediaItems];
         
         
         // execute completion handler
         if (block)
             block();
         
     } 
     failure:^ (AFHTTPRequestOperation *operation, NSError *error) 
     {
         DLog(@"%@ %@", operation.response, error);        
         [UIAlertView showAlertWithTitle:@"Fout opgetreden" message:[error localizedDescription] cancelButtonTitle:@"OK"];         
         
         // execute completion handler
         if (block)
             block();
         
     }];
    
    [operation start];
}

- (NSURL *)parseImageURLInArticleImageNode:(HTMLNode *)node
{
    node = [node findChildTag:@"img"];
    NSString *string = [node getAttributeNamed:@"src"];
    return [NSURL URLWithString:string];
}

- (NSString *)parseTextInArticleContentNode:(HTMLNode *)node
{
    NSArray *nodes = [node findChildTags:@"p"];
    NSString *paragraphText = [NSString string];
    for (node in nodes)
    {
        NSString *contents = [node allContents];
        paragraphText = [paragraphText stringByAppendingFormat:@"%@\n\n", contents];         
    }
    
    paragraphText = [paragraphText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    DLog(@"%@", paragraphText);
    
    return paragraphText;
}

- (void)parseMediaItemsInVideoNode:(HTMLNode *)node bodyNode:(HTMLNode *)bodyNode sourceURL:(NSURL *)URL parsedVideoHandler:(void (^)(Media *media))parsedMediaHandler
{
    DLog(@"%@", [URL absoluteString]);
    
    NSString *string = [node allContents];
    if ([string length] > 0)
    {
        string = [string substringFromString:@"src=\"" toString:@"\""];
        
        node = [node findChildTag:@"h4"];
        NSString *title = [node allContents];
        
        if (title)
        {
            NSURL *URL = [NSURL URLWithString:string];
            Media *movie = [Media mediaWithType:MediaTypeMovie title:title URL:URL];
            
            
            // execute completion handler
            if (parsedMediaHandler)
                parsedMediaHandler(movie);
        }
        else 
        {
            NSArray *nodes = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"nieuws" allowPartial:YES];
            for (node in nodes)
            {
                HTMLNode *linkNode = [node findChildTag:@"a"];
                string = [linkNode getAttributeNamed:@"href"];
                title = [linkNode allContents];
                
                NSString *scheme = [URL scheme];
                NSString *host = HOST;
                NSString *URLString = [NSString stringWithFormat:@"%@://%@%@", scheme, host, string];
                DLog(@"%@", URLString);
                
                [self
                 parseVideoItemAtURL:[NSURL URLWithString:URLString]
                 success:^ (NSURL *URL) 
                 {
                     Media *movie = [Media mediaWithType:MediaTypeMovie title:title URL:URL];
                     
                     
                     // execute completion handler
                     if (parsedMediaHandler)
                         parsedMediaHandler(movie);
                 } 
                 failure:^ (NSHTTPURLResponse *response, NSError *error) 
                 {
                     DLog(@"%@ %@", response, error);        
                     [UIAlertView showAlertWithTitle:@"Fout opgetreden" message:[error localizedDescription] cancelButtonTitle:@"OK"];
                 }];
            }                 
        }             
    }
}

- (NSArray *)parseMediaItemsInAudioNode:(HTMLNode *)node
{
    NSMutableArray *mediaItems = [NSMutableArray array];
    
    for (node in node.children)
    {
        NSString *title = [[node findChildTag:@"strong"] allContents];
        if (title)
        {
            HTMLNode *scriptNode = [node findChildWithAttribute:@"type" matchingName:@"text/javascript" allowPartial:NO];
            NSString *string = [scriptNode allContents];
            string = [string substringFromString:@"src=\"" toString:@"\""];
            
            NSURL *URL = [NSURL URLWithString:string];
            Media *audio = [Media mediaWithType:MediaTypeAudio title:title URL:URL];
            [mediaItems addObject:audio];
            
            DLog(@"%@ %@", title, string);
        }
    }
    
    return mediaItems;
}

- (void)parseVideoItemAtURL:(NSURL *)URL success:(void (^)(id object))success failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:TIMEOUT_INTERVAL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation 
     setCompletionBlockWithSuccess:^ (AFHTTPRequestOperation *operation, id object) 
     {
         NSURL *videoURL = nil;
         
         
         HTMLParser *parser = [[HTMLParser alloc] initWithData:object error:nil];
         HTMLNode *node = [parser.body findChildWithAttribute:@"id" matchingName:@"article" allowPartial:NO];
         node = [node findChildWithAttribute:@"type" matchingName:@"text/javascript" allowPartial:NO];
         {
             NSString *string = [node allContents];
             string = [string substringFromString:@"src=\"" toString:@"\""];
             videoURL = [NSURL URLWithString:string];
         }
         
         
         // execute completion handler
         if (success)
             success(videoURL);    
     } 
     failure:^ (AFHTTPRequestOperation *operation, NSError *error) 
     {
         DLog(@"%@ %@", operation.response, error);        
         
         // execute completion handler
         if (failure)
             failure(operation.response, error);
     }];
    
    [operation start];
}

@end