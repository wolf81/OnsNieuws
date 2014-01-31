//
//  NewsItemMediaCell.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/14/11.
//  Copyright (c) 2012 Wolfgang Schreurs. All rights reserved.
//

#import "NewsItemMediaCell.h"


#define FONT_SIZE 13.0f


@interface NewsItemMediaCell ()
@property (nonatomic, strong) UILabel     *label;
@property (nonatomic, strong) UIImageView *imageView;
@end


@implementation NewsItemMediaCell
@synthesize media = _media, label, imageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont boldSystemFontOfSize:FONT_SIZE];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.backgroundColor = [UIColor whiteColor];
        label.highlightedTextColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 2;
        [self addSubview:label];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
#define PADDING_HORIZONTAL 10.0f
#define PADDING_VERTICAL   5.0f
#define IMAGE_SIZE         20.0f
    
    UIImage *image = (_media.type == MediaTypeMovie ? [UIImage imageNamed:@"movie"] : [UIImage imageNamed:@"audio"]);
    CGFloat y = (self.bounds.size.height - IMAGE_SIZE) / 2;
    imageView.frame = CGRectMake(PADDING_HORIZONTAL, y, IMAGE_SIZE, IMAGE_SIZE);
    imageView.image = image;

    CGFloat x = imageView.frame.origin.x + imageView.frame.size.width + PADDING_HORIZONTAL;
    CGFloat width = self.bounds.size.width - x - PADDING_HORIZONTAL;
    CGFloat height = self.bounds.size.height - (PADDING_VERTICAL * 2);
    label.text = _media.title;
    label.frame = CGRectMake(x, PADDING_VERTICAL, width, height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Properties

- (void)setMedia:(Media *)media
{
    if (_media == media)
        return;
    
    _media = media;
    
    [self setNeedsLayout];
}

@end
