//
//  UIAlertView+Utility.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/15/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Utility)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)buttonTitle;

@end
