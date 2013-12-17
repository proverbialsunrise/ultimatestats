//
//  USSEditableTableViewCell.m
//  SimpleStats
//
//  Created by Daniel Johnson on 12/6/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSEditableTableViewCell.h"

#define LABELWIDTH 100
#define LABELHEIGHT 44.0

@implementation USSEditableTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.descriptionLabel setFont:[UIFont fontWithName:@"Helvetica Bold" size:16.0]];
        [self.descriptionLabel setTextAlignment:NSTextAlignmentRight];
        
        //Add a UITextView with a frame that fills the space to the right of the textLabel.
        self.editableTextView = [[UITextField alloc] initWithFrame:CGRectZero];
        [self.editableTextView setFont:[UIFont systemFontOfSize:14.0]];
        
        [self.editableTextView setEnablesReturnKeyAutomatically:YES];
        [self.editableTextView setReturnKeyType:UIReturnKeyDone];
        
        [self.contentView addSubview:self.editableTextView];
        [self.contentView addSubview:self.descriptionLabel];
        
        [self.editableTextView setText:@"EDIT THIS"];
        [self.descriptionLabel setText:@"DON'T"];
        
    }
    return self;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    CGFloat cellWidth = self.contentView.frame.size.width;
    CGFloat labelWidth = cellWidth/4;
    CGFloat buffer = 10;
    
    [self.descriptionLabel setFrame:CGRectMake(buffer, 0, labelWidth, LABELHEIGHT)];
    [self.editableTextView setFrame:CGRectMake(labelWidth + 2*buffer, 0, cellWidth - labelWidth - 3*buffer, LABELHEIGHT)];


}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
