//
//  USSPlayerViewController.m
//  SimpleStats
//
//  Created by Daniel Johnson on 12/6/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSPlayerViewController.h"
#import "USSPlayer.h"
#import "USSTeam.h"
#import "USSEditableTableViewCell.h"

@interface USSPlayerViewController () <UITextFieldDelegate>

@property (nonatomic, retain) USSPlayer *player;

@property (nonatomic, retain) NSString *originalName;
@property (nonatomic, retain) NSString *originalNumber;
@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, assign) BOOL newPlayer;

@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UITextField *numberTextField;

@property (nonatomic, retain) UITextField *activeTextField;


- (void) cancelEdits:(id)obj;

@end

enum kPlayerSections {
    kNameSection = 0,
    kNumberSection,
    NUM_SECTIONS
};


enum nameSectionRows {
    kNameSectionNameRow,
    NUM_NAME_SECTION_ROWS
};

enum numberSectionRows {
    kNumberSectionNumberRow,
    NUM_NUMBER_SECTION_ROWS
};


@implementation USSPlayerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[self tableView] registerClass:[USSEditableTableViewCell class] forCellReuseIdentifier:@"EditableCell"];
    }
    return self;
}

- (void) configureWithNewPlayerForTeam:(USSTeam *)team{
    self.player = [USSPlayer new];
    self.player.teamID = team.id;
    self.newPlayer = YES;
    
}

- (void) configureWithPlayer:(USSPlayer *)aPlayer{
    self.player = aPlayer;
    
    self.originalName = aPlayer.name;
    self.originalNumber = aPlayer.number;
    self.newPlayer = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdits:)];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.title = NSLocalizedString(@"Player Details", nil);
    self.cancelled = NO;
    
}

- (void) cancelEdits:(id)obj{
    self.cancelled = YES;
    if (!self.newPlayer) {
        self.player.name = self.originalName;
        self.player.number = self.originalNumber;
        [self.player save];
    } else {
        [self.player delete];
    }

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    switch (section) {
        case kNameSection:
            return NUM_NAME_SECTION_ROWS;
            break;
            
        case kNumberSection:
            return NUM_NUMBER_SECTION_ROWS;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kNameSection:
            return NSLocalizedString(@"Name", nil);
            break;
            
        case kNumberSection:
            return NSLocalizedString(@"Jersey Number", nil);
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EditableCell";
    USSEditableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell.editableTextView setDelegate:self];

    
    // Configure the cell...
    switch (indexPath.section) {
        case kNameSection:
            switch (indexPath.row) {
                case kNameSectionNameRow:
                    [cell.descriptionLabel setText:NSLocalizedString(@"Name", nil)];
                    [cell.editableTextView setText:[self.player name]];
                    [cell.editableTextView setTag:(NSInteger)kNameSection];
                    self.nameTextField = cell.editableTextView;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case kNumberSection:
            switch (indexPath.row) {
                case kNumberSectionNumberRow:
                    [cell.descriptionLabel setText:NSLocalizedString(@"Number", nil)];
                    [cell.editableTextView setText:[self.player number]];
                    [cell.editableTextView setTag:(NSInteger)kNumberSection];
                    [cell.editableTextView setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
                    self.numberTextField = cell.editableTextView;
                    
                    break;
                    
                default:
                    break;
            }
            
        default:
            break;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

- (void) viewWillDisappear:(BOOL)animated {
    //Save the information in the text fields unless cancelled.
    if (!self.cancelled) {
        self.player.name = self.nameTextField.text;
        self.player.number = self.numberTextField.text;
        [self.player save];
    }
}


#pragma mark - UITextViewDelegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endTextEditing:)];
    self.activeTextField = textField;
    return YES;
}

- (void) endTextEditing:(id)obj {
    [self.activeTextField resignFirstResponder];
    self.player.name = self.nameTextField.text;
    self.player.number = self.numberTextField.text;
    [self.player save];
    self.activeTextField = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdits:)];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    self.player.name = self.nameTextField.text;
    self.player.number = self.numberTextField.text;
    [self.player save];
    [textField resignFirstResponder];

    return YES;

}

@end
