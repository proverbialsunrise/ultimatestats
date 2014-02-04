//
//  USSCreateTeamViewController.h
//  SimpleStats
//
//  Created by Daniel Johnson on 1/7/14.
//  Copyright (c) 2014 Daniel Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USSCreateTeamViewDelegate.h"

@interface USSCreateTeamViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UITextField *teamNameField;

@property (nonatomic, weak) id <USSCreateTeamViewDelegate> delegate;

- (IBAction)doneButtonTapped:(id)sender;


@end
