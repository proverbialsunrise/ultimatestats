//
//  USSEditableTableViewCell.h
//  SimpleStats
//
//  Created by Daniel Johnson on 12/6/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USSEditableTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel    *descriptionLabel;
@property (nonatomic, retain) UITextField *editableTextView;

@end
