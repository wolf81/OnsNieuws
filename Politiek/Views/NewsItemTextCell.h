//
//  NewsItemTextCell.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/13/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsItemTextCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel  *label;
@property (nonatomic, copy)             NSString *text;

+ (CGFloat)labelPadding;
+ (UIFont *)labelFont;


@end
