//
//  UIBarButtonItem+CustomBarButtonItems.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/15/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomBarButtonItems)

+ (UIBarButtonItem *)activityBarButtonItem;
+ (UIBarButtonItem *)infoBarButtonItemWithTarget:(id)target selector:(SEL)selector;

@end
