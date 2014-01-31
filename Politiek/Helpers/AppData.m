//
//  AppData.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/14/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "AppData.h"


@implementation AppData
@synthesize appDidCrash;

+ (AppData *)sharedAppData
{
    static dispatch_once_t pred;
    static AppData *sharedAppData = nil;
    dispatch_once(&pred, ^
    { 
        sharedAppData = [[self alloc] init]; 
    });
    return sharedAppData;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:appDidCrash forKey:@"appDidCrash"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    appDidCrash = [aDecoder decodeBoolForKey:@"appDidCrash"];

    return self;
}

@end
