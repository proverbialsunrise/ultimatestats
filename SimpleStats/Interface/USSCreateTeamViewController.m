//
//  USSCreateTeamViewController.m
//  SimpleStats
//
//  Created by Daniel Johnson on 1/7/14.
//  Copyright (c) 2014 Daniel Johnson. All rights reserved.
//

#import "USSCreateTeamViewController.h"
#import "USSTeam.h"
@interface USSCreateTeamViewController ()

@end

@implementation USSCreateTeamViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)doneButtonTapped:(id)sender{
    //Create a new team with the correct name.
    if (![self.teamNameField.text isEqualToString:@""]) {
        USSTeam *newTeam = [USSTeam new];
        newTeam.name = self.teamNameField.text;
        [newTeam save];
        if ([self.delegate respondsToSelector:@selector(configureWithTeam:)]) {
            [self.delegate configureWithTeam:newTeam];
        }
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"Tried to make a team without a name");
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
