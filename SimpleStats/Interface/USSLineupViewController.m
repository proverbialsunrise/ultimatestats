//
//  USSLineupViewController.m
//  SimpleStats
//
//  Created by Daniel Johnson on 1/3/14.
//  Copyright (c) 2014 Daniel Johnson. All rights reserved.
//

#import "USSLineupViewController.h"
#import "USSGameTrackingViewController.h"

#import "USSRosterCell.h"

#import "USSTeam.h"
#import "USSPoint.h"
#import "USSPlayer.h"

@interface USSLineupViewController ()

@property (nonatomic, retain) USSTeam *team;
@property (nonatomic, retain) USSPoint *point;

@property (nonatomic, retain) NSMutableArray *playersOnField;
@property (nonatomic, retain) NSMutableArray *otherPlayers;


- (void) done;

- (void) cancel;

@end


typedef enum lineupSections {
    kOnFieldSection,
    kOtherSection,
    NUM_SECTIONS
} lineupSections;

@implementation USSLineupViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.playersOnField = [NSMutableArray array];
        self.otherPlayers = [NSMutableArray array];
        
        [[self tableView] registerNib:[UINib nibWithNibName:@"RosterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RosterCell"];

    }
    return self;
}


- (void) configureWithTeam:(USSTeam *)team andPoint:(USSPoint *)point {
    self.team = team;
    self.point = point;
    
    //Populate the two arrays for on the field and off the field players.
    for (USSPlayer* player in self.team.players) {
        if ([self.point.players containsObject:player]) {
            [self.playersOnField addObject:player];
        } else {
            [self.otherPlayers addObject:player];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.title = NSLocalizedString(@"Set Lineup", nil);
}

- (void) done {
    if ([self.delegate respondsToSelector:@selector(loadLineupFromLineupViewController:)]) {
        [self.delegate loadLineupFromLineupViewController:self];
    }
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) cancel {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSArray *) playersInLineup {
    return [self.playersOnField copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kOnFieldSection:
            return [self.playersOnField count];
            break;
            
        case kOtherSection:
            return [self.otherPlayers count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kOnFieldSection:
            return NSLocalizedString(@"On Field", @"");
            break;
            
        case kOtherSection:
            return NSLocalizedString(@"Other Players", @"");
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RosterCell";
    USSRosterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    USSPlayer *player;
    // Configure the cell...
    switch (indexPath.section) {
        case kOnFieldSection:
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            player = [self.playersOnField objectAtIndex:indexPath.row];
        }
            break;
            
        case kOtherSection:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            player = [self.otherPlayers objectAtIndex:indexPath.row];
        }
            break;
            
        default:
            break;
    }
    
    cell.nameLabel.text = player.name;
    cell.numberLabel.text = player.number;
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //get the cell.
    USSRosterCell *cell = (USSRosterCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSIndexPath *newLocation;
    
    switch (indexPath.section) {
        case kOnFieldSection:
            {
                //We need to remove this player from the field.
                cell.accessoryType = UITableViewCellAccessoryNone;
                //we need to move this player from the on field array to the other array.
                USSPlayer *playerToMove = [self.playersOnField objectAtIndex:indexPath.row];
                [self.playersOnField removeObjectAtIndex:indexPath.row];
                [self.otherPlayers addObject:playerToMove];
                newLocation = [NSIndexPath indexPathForRow:[self.otherPlayers count]-1 inSection:kOtherSection];
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newLocation];
            }
            break;
            
        case kOtherSection:
            {
                //We need to add this player to the field
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                USSPlayer *playerToMove = [self.otherPlayers objectAtIndex:indexPath.row];
                [self.otherPlayers removeObjectAtIndex:indexPath.row];
                [self.playersOnField addObject:playerToMove];
                newLocation = [NSIndexPath indexPathForRow:[self.playersOnField count]-1 inSection:kOnFieldSection];
                [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newLocation];

            }
            break;
            
        default:
            break;
    }
    
    
    [self.tableView deselectRowAtIndexPath:newLocation animated:YES];
    
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
