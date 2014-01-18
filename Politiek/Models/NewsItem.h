//
//  NewsItem.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/8/11.
//  Copyright 2011 Sound of Data. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const kNITitleProperty;
extern NSString * const kNIURLProperty;
extern NSString * const kNIPubDateProperty;


@interface NewsItem : NSObject 

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSURL    *URL;
@property (nonatomic, strong, readonly) NSDate   *publishDate;

- (void)setValue:(id)value forProperty:(NSString *)property;
- (id)valueForProperty:(NSString *)property;

@end
