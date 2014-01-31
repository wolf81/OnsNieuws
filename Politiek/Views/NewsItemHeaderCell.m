//
//  NewsItemHeaderCell.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/13/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "NewsItemHeaderCell.h"
#import "AFNetworking.h"


#define FONT_SIZE 15.0f


@interface NewsItemHeaderCell ()
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage     *image;
@end


@implementation NewsItemHeaderCell
@synthesize imageView, titleLabel, title = _title, imageURL = _imageURL, image = _image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        titleLabel.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        [self.contentView addSubview:titleLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
#define PADDING_HORIZONTAL      10.0f
#define PADDING_VERTICAL        10.0f
#define HEADER_MAX_IMAGE_WIDTH  80.0f
#define HEADER_MAX_HEIGHT       50.0f
    
    if (self.image && self.imageView.image == nil)
    {
        self.imageView.frame = CGRectMake(PADDING_HORIZONTAL, PADDING_VERTICAL, HEADER_MAX_IMAGE_WIDTH, HEADER_MAX_HEIGHT);
        self.imageView.alpha = 0.0f;
        self.imageView.image = self.image;
        
        [UIView animateWithDuration:0.3f animations:^ 
        { 
            self.imageView.alpha = 1.0f; 
        }];
    }
    
    if ([self.titleLabel.text isEqualToString:self.title] == NO)
    {
        CGFloat x = PADDING_HORIZONTAL + (self.imageURL ? PADDING_HORIZONTAL + HEADER_MAX_IMAGE_WIDTH : 0);
        CGFloat width = self.bounds.size.width - x - PADDING_HORIZONTAL;
        self.titleLabel.frame = CGRectMake(x, PADDING_VERTICAL, width, HEADER_MAX_HEIGHT);
        self.titleLabel.text = self.title;
        self.titleLabel.textAlignment = self.imageURL ? UITextAlignmentLeft : UITextAlignmentCenter;
    }
}

#pragma mark - Properties

- (void)setImageURL:(NSURL *)imageURL
{
    if (_imageURL == imageURL)
        return;
    
    _imageURL = imageURL;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.imageURL cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:TIMEOUT_INTERVAL];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation 
     setCompletionBlockWithSuccess:^ (AFHTTPRequestOperation *operation, id object) 
    {
        DLog(@"did load image from URL: %@", imageURL);
        self.image = [UIImage imageWithData:object];    
    } 
     failure:^ (AFHTTPRequestOperation *operation, NSError *error) 
    {    
        DLog(@"%@", error);
    }];
    
    [operation start];
}

- (void)setTitle:(NSString *)title
{
    if ([_title isEqualToString:title])
        return;
    
    _title = title;
    
    [self setNeedsLayout];
}

- (void)setImage:(UIImage *)image
{
    if (_image == image)
        return;
    
    _image = image;
    
    [self setNeedsLayout];
}

#pragma mark - Class methods

+ (CGFloat)height
{
    return (PADDING_VERTICAL * 2) + HEADER_MAX_HEIGHT;
}

@end
