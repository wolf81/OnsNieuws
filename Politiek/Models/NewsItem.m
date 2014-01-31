//
//  NewsItem.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/8/11.
//  Copyright 2012 Wolfgang Schreurs. All rights reserved.
//

#import "NewsItem.h"


NSString * const kNITitleProperty       = @"kNITitleProperty";
NSString * const kNIURLProperty         = @"kNIURLProperty";
NSString * const kNIPubDateProperty     = @"kNIPubDateProperty";


@implementation NewsItem
{
    NSMutableDictionary *_dictionary;
}

@synthesize title, URL, publishDate;

- (id)init
{
    self = [super init];
    if (self) 
    {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setValue:(id)value forProperty:(NSString *)property
{
    DLog(@"%@: %@", property, [value class]);
    
    if (property == kNIURLProperty && [value isKindOfClass:[NSURL class]] == NO)
    {
        return; // fail silently (don't want app to crash)
    }
    else if (property == kNITitleProperty && [value isKindOfClass:[NSString class]] == NO)
    {
        return; // fail silently (don't want app to crash)
    }
    else if (property == kNIPubDateProperty && [value isKindOfClass:[NSDate class]] == NO)
    {
        return; // fail silently (don't want app to crash)
    }
    
    [_dictionary setValue:value forKey:property];
}

- (id)valueForProperty:(NSString *)property
{
    return [_dictionary valueForKey:property];
}

#pragma mark - Properties

- (NSURL *)URL
{
    return [_dictionary valueForKey:kNIURLProperty];
}

- (NSString *)title
{
    return [_dictionary valueForKey:kNITitleProperty];
}

- (NSDate *)publishDate
{
    return [_dictionary valueForKey:kNIPubDateProperty];
}

@end
