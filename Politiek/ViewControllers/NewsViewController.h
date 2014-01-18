//
//  NewsViewController.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/15/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSPTableViewController.h"


@interface NewsViewController : FSPTableViewController 
    <NSXMLParserDelegate, 
    UITableViewDataSource, 
    UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray       *newsItems;
@property (nonatomic, strong) NSArray              *sections;

@end
