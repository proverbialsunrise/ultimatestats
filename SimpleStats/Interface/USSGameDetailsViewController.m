//
//  USSGameDetailsViewController.m
//  SimpleStats
//
//  Created by Daniel Johnson on 12/14/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSGameDetailsViewController.h"

#import "USSGame.h"
#import "USSTeam.h"

#import "USSEditableTableViewCell.h"

@interface USSGameDetailsViewController ()

@property (nonatomic, retain) USSGame *game;

@property (nonatomic, assign) BOOL newGame;
@property (nonatomic, assign) BOOL cancelled;


@property (nonatomic, retain) NSString *originalOpponent;
@property (nonatomic, retain) NSDate * originalDate;

@property (nonatomic, retain) UITextField *opponentTextField;
@property (nonatomic, retain) UITextField *dateTextField;

@property (nonatomic, retain) UITextField *activeTextField;


- (void) cancelEdits:(id)obj;

- (void) endTextEditing:(id)obj;

@end


static NSDateFormatter *generateGameDate = nil;



@implementation USSGameDetailsViewController


enum kGameDetailsSections {
    kOpponentSection = 0,
    kDateSection,
    NUM_SECTIONS
};


enum kOpponentSectionRows {
    kOpponentSectionOpponentRow,
    NUM_OPPONENT_SECTION_ROWS
};

enum kDateSectionRows {
    kDateSectionDateRow,
    NUM_DATE_SECTION_ROWS
};


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[self tableView] registerClass:[USSEditableTableViewCell class] forCellReuseIdentifier:@"EditableCell"];
        
        if (generateGameDate == nil){
            generateGameDate = [[NSDateFormatter alloc] init];
            [generateGameDate setDateStyle:NSDateFormatterMediumStyle];
            [generateGameDate setTimeStyle:NSDateFormatterShortStyle];
        }
    }
    return self;
}

- (void) configureWithNewGameForTeam:(USSTeam *)team{
    self.game = [USSGame newWithTeamID:team.id];
    self.newGame = YES;
    
}

- (void) configureWithGame:(USSGame *)game{
    self.game = game;
    
    self.originalOpponent = game.opponent;
    self.originalDate = game.date;
    self.newGame = NO;
}

- (void) cancelEdits:(id)obj{
    self.cancelled = YES;
    if (!self.newGame) {
        self.game.opponent = self.originalOpponent;
        self.game.date = self.originalDate;
        [self.game save];
    } else {
        [self.game delete];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdits:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.title = NSLocalizedString(@"Game Details", nil);
    self.cancelled = NO;
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
        case kOpponentSection:
            return NUM_OPPONENT_SECTION_ROWS;
            break;
            
        case kDateSection:
            return NUM_DATE_SECTION_ROWS;
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kOpponentSection:
            return NSLocalizedString(@"Opponent", nil);
            break;
            
        case kDateSection:
            return NSLocalizedString(@"Game Date and Time", nil);
            
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
        case kOpponentSection:
            switch (indexPath.row) {
                case kOpponentSectionOpponentRow:
                {
                    [cell.descriptionLabel setText:NSLocalizedString(@"Opponent", nil)];
                    [cell.editableTextView setText:self.game.opponent];
                    [cell.editableTextView setTag:(NSInteger)kOpponentSection];
                    self.opponentTextField = cell.editableTextView;
                }
                break;
                    
                default:
                    break;
            }
            break;
            
        case kDateSection:
            switch (indexPath.row) {
                case kDateSectionDateRow:
                {
                    [cell.descriptionLabel setText:NSLocalizedString(@"Date", nil)];
                    [cell.editableTextView setText:[generateGameDate  stringFromDate:self.game.date]];
                    [cell.editableTextView setTag:(NSInteger)kDateSection];
                    self.dateTextField = cell.editableTextView;
                    //Make a date picker to be the input view of the text field.
                    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
                    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
                    [self.dateTextField setInputView:datePicker];
                }
                break;
                
                    
                default:
                    break;
            }
            
        default:
            break;
    }
    return cell;
}

-  (void) dateChanged:(id)sender {
    UIDatePicker *picker = (UIDatePicker *)sender;
    [self.dateTextField setText:[generateGameDate stringFromDate:[picker date]]];
    self.game.date = picker.date;
    [self.game save];
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
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void) viewWillDisappear:(BOOL)animated {
    //Save the information in the text fields unless cancelled.
    if (!self.cancelled) {
        self.game.opponent = self.opponentTextField.text;
        self.game.date =  [generateGameDate dateFromString:self.dateTextField.text];
        [self.game save];
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(endTextEditing:)];
    self.activeTextField = textField;
    return YES;
}

- (void) endTextEditing:(id)obj {
    [self.activeTextField resignFirstResponder];
    self.game.opponent = self.opponentTextField.text;
    self.game.date =  [generateGameDate dateFromString:self.dateTextField.text];
    [self.game save];
    self.activeTextField = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdits:)];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self endTextEditing:textField];
    
    return YES;
}



/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
