//
//  AppData.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/14/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject <NSCoding>

@property (nonatomic, assign) BOOL appDidCrash;

+ (AppData *)sharedAppData;

@end
