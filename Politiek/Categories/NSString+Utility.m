//
//  NSString+Utility.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/15/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import "NSString+Utility.h"


@implementation NSString (Utility)

- (NSString *)substringFromString:(NSString *)from toString:(NSString *)to
{
    NSRange range = [self rangeOfString:from];
    if (range.location == NSNotFound)
    {
        DLog(@"could not find string '%@' in string '%@", from, self);
        return nil;
    }
    
    NSString *string = [self substringFromIndex:range.location + range.length];
    range = [string rangeOfString:to];
    if (range.location == NSNotFound)
    {
        DLog(@"could not find string '%@' in string '%@", to, string);
        return nil;
    }
    
    return [string substringToIndex:range.location];
}

@end
