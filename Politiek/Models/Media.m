//
//  Media.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/14/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "Media.h"


@interface Media ()
@property (nonatomic, assign) MediaType type;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSURL     *URL;
@property (nonatomic, strong) NSString  *extension;
@end


@implementation Media

@synthesize type  = _type;
@synthesize title = _title;
@synthesize URL   = _URL;
@synthesize extension;

+ (id)mediaWithType:(MediaType)type title:(NSString *)title URL:(NSURL *)URL
{
    Media *media = [[self alloc] init];
    media.type   = type;
    media.title  = title;
    media.URL    = URL;
    
    return media;
}

- (NSString *)extension
{
    return _URL.pathExtension;
}

@end