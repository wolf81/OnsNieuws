//
//  UIAlertView+Utility.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/15/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "UIAlertView+Utility.h"

@implementation UIAlertView (Utility)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)buttonTitle
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil];
    [alert show];
}

@end
