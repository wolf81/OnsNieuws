//
//  NewsItemParser.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/9/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsItem.h"
#import "Media.h"


@interface NewsItemParser : NSObject

@property (nonatomic, copy)   NSString       *text;
@property (nonatomic, strong) NSURL          *imageURL;
@property (nonatomic, strong) NSMutableArray *mediaItems; 

typedef void (^completionHandler)();

- (void)parseNewsItem:(NewsItem *)newsItem completionHandler:(completionHandler)block;

@end