//
//  NewsDetailViewController.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/12/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPTableViewController.h"
#import "NewsItem.h"
#import "Facebook.h"


@interface NewsDetailViewController : FSPTableViewController 
    <UITableViewDataSource, 
    UITableViewDelegate, 
    UIActionSheetDelegate,
    FBRequestDelegate>

@property (nonatomic, strong) NewsItem *newsItem;

@end
