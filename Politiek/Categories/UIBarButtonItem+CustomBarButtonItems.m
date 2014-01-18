//
//  UIBarButtonItem+CustomBarButtonItems.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/15/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import "UIBarButtonItem+CustomBarButtonItems.h"

@implementation UIBarButtonItem (CustomBarButtonItems)

+ (UIBarButtonItem *)activityBarButtonItem
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(0.0f, 0.0f, 32.0f, 32.0f);
    [activityView startAnimating];
    
    return [[UIBarButtonItem alloc] initWithCustomView:activityView];
}

+ (UIBarButtonItem *)infoBarButtonItemWithTarget:(id)target selector:(SEL)selector
{
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(0.0f, 0.0f, 32.0f, 32.0f);
    [infoButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

@end
