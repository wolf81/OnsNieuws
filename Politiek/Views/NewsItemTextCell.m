//
//  NewsItemTextCell.m
//  Politiek
//
//  Created by Wolfgang Schreurs on 11/13/11.
//  Copyright (c) 2011 Sound of Data. All rights reserved.
//

#import "NewsItemTextCell.h"


@interface NewsItemTextCell ()
@end


@implementation NewsItemTextCell
@synthesize text = _text, label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        [self.contentView addSubview:label];
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
    
#define PADDING   10.0f
#define FONT_SIZE 15.0f
    
    if ([label.text isEqualToString:self.text] == NO)
    {
        CGFloat width = self.bounds.size.width - (PADDING * 2);
        UIFont *font = [UIFont systemFontOfSize:FONT_SIZE];
        CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
        CGSize size = [self.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = size.height + PADDING;
        
        label.frame = CGRectMake(PADDING, 0.0f, width, height);
        label.text = self.text;
        label.font = font;
    }
}

#pragma mark - Properties

- (void)setText:(NSString *)text
{
    if ([_text isEqualToString:text])
        return;
    
    _text = text;
    
    [self setNeedsLayout];
}

#pragma mark - Class methods

+ (CGFloat)labelPadding
{
    return PADDING;
}

+ (UIFont *)labelFont
{
    return [UIFont systemFontOfSize:FONT_SIZE];
}

@end
