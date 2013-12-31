//
//  USSGameListViewController.m
//  SimpleStats
//
//  Created by Daniel Johnson on 12/13/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSGameListViewController.h"
#import "USSGameDetailsViewController.h"
#import "USSGameTrackingViewController.h"
#import "USSGameCell.h"
#import "USSTeam.h"
#import "USSGame.h"


@interface USSGameListViewController ()

@property (nonatomic, retain) USSTeam *team;

@end

@implementation USSGameListViewController


static NSDateFormatter *generateGameDate = nil;

- (void) configureWithTeam:(USSTeam *)aTeam {
    self.team = aTeam;
    self.title = self.team.name;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[self tableView] registerNib:[UINib nibWithNibName:@"GameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GameCell"];
        if (generateGameDate == nil){
            generateGameDate = [[NSDateFormatter alloc] init];
            [generateGameDate setDateStyle:NSDateFormatterMediumStyle];
            [generateGameDate setTimeStyle:NSDateFormatterShortStyle];
        }
        
        self.title = @"Games";
        //Register for updates when the Players change.
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadGames:) name:FCModelInsertNotification object:USSGame.class];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadGames:) name:FCModelUpdateNotification object:USSGame.class];
        
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGame)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    }
    return self;
}

- (void) reloadGames:(NSNotification *)notification  {
    [self.team reloadGames];
    //If this becomes a performance problem, we can do this reloading more selectively...
    [self.tableView reloadData];
}

- (void) addGame{
    
    USSGameDetailsViewController *gameViewController = [[USSGameDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [gameViewController configureWithNewGameForTeam:self.team];
    
    //Push onto navigation controller stack.
    [self.navigationController pushViewController:gameViewController animated:YES];
}

- (void) toggleEditing {
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGame)];
    } else {
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEditing)];
    }
}




- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.team.games count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GameCell";
    USSGameCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    USSGame *game = [self.team.games objectAtIndex:indexPath.row];
    cell.teamLabel.text = [NSString stringWithFormat:@"%@ vs. %@", self.team.name, game.opponent];
    cell.dateLabel.text = [generateGameDate stringFromDate:game.date];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        USSGame *gameToRemove = [self.team.games objectAtIndex:indexPath.section];
        [gameToRemove delete];
        [self.team reloadGames];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    USSGame *game = [self.team.games objectAtIndex:indexPath.row];
    NSLog(@"Select game against %@", game.opponent);
    USSGameDetailsViewController *gameViewController = [[USSGameDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [gameViewController configureWithGame:game];
    
    //Push onto navigation controller stack.
    [self.navigationController pushViewController:gameViewController animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    USSGame *game = [self.team.games objectAtIndex:indexPath.row];
    USSGameTrackingViewController *gameTrackViewController = [[USSGameTrackingViewController alloc] initWithNibName:@"USSGameTrackingViewController" bundle:[NSBundle mainBundle]];
    [gameTrackViewController setHidesBottomBarWhenPushed:YES];
    [gameTrackViewController configureWithGame:game];
    [self.navigationController pushViewController:gameTrackViewController animated:YES];
}


- (void)dealloc
{
    //Unregister for FCModel notifications
    [NSNotificationCenter.defaultCenter removeObserver:self name:FCModelInsertNotification object:USSGame.class];
    [NSNotificationCenter.defaultCenter removeObserver:self name:FCModelUpdateNotification object:USSGame.class];
    
}

@end
