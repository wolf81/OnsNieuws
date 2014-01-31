//
//  NewsItemHeaderCell.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/13/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsItemHeaderCell : UITableViewCell

@property (nonatomic, strong) NSURL       *imageURL;
@property (nonatomic, copy)   NSString    *title;

+ (CGFloat)height;

@end
