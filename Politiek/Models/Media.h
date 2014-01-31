//
//  Media.h
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/14/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Media : NSObject 

typedef enum 
{
    MediaTypeMovie,
    MediaTypeAudio,
} MediaType;

@property (nonatomic, assign, readonly) MediaType type;
@property (nonatomic, strong, readonly) NSString  *title;
@property (nonatomic, strong, readonly) NSURL     *URL;
@property (nonatomic, strong, readonly) NSString  *extension;

+ (id)mediaWithType:(MediaType)type title:(NSString *)title URL:(NSURL *)URL;

@end