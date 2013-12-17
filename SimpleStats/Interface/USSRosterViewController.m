//
//  USSRosterViewController.m
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSRosterViewController.h"

#import "USSTeam.h"
#import "USSPlayer.h"

#import "USSRosterCell.h"
#import "USSPlayerViewController.h"
#import "USSAppDelegate.h"

@interface USSRosterViewController ()

@property (nonatomic, retain) USSTeam *team;

- (void) reloadPlayers:(NSNotification *)notification;

- (void) addPlayer;

- (void) toggleEditing;

@end

@implementation USSRosterViewController


- (void) configureWithTeam:(USSTeam *)team  {
    self.team = team;
    self.title = team.name;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[self tableView] registerNib:[UINib nibWithNibName:@"RosterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RosterCell"];
        
        //Register for updates when the Players change.
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadPlayers:) name:FCModelInsertNotification object:USSPlayer.class];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(reloadPlayers:) name:FCModelUpdateNotification object:USSPlayer.class];
        
        
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPlayer)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(toggleEditing)];
    }
    return self;
}

- (void) reloadPlayers:(NSNotification *)notification  {
    [self.team reloadPlayers];
    //If this becomes a performance problem, we can do this reloading more selectively...
    [self.tableView reloadData];
}

- (void) addPlayer{
    USSPlayerViewController *playerViewController = [[USSPlayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [playerViewController configureWithNewPlayerForTeam:self.team];
    //Push onto navigation controller stack.
    [self.navigationController pushViewController:playerViewController animated:YES];
}

- (void) toggleEditing {
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPlayer)];
    } else {
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(toggleEditing)];

    }
}

- (void) viewDidLoad
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
    return [[self.team players] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RosterCell";
    USSRosterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUInteger row = indexPath.row;
    // Configure the cell...
    [cell.numberLabel setText:[[self.team.players objectAtIndex:row] number]];
    [cell.nameLabel setText:[[self.team.players objectAtIndex:row] name]];
    
    return cell;
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
        USSPlayer *playerToRemove = [self.team.players objectAtIndex:indexPath.section];
        [playerToRemove delete];
        [self.team reloadPlayers];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    USSPlayer *selectedPlayer = [self.team.players objectAtIndex:[indexPath row]];
    USSPlayerViewController *playerViewController = [[USSPlayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [playerViewController configureWithPlayer:selectedPlayer];
    
    //Push onto navigation controller stack.
    [self.navigationController pushViewController:playerViewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}


- (void)dealloc
{
    //Unregister for FCModel notifications
    [NSNotificationCenter.defaultCenter removeObserver:self name:FCModelInsertNotification object:USSPlayer.class];
    [NSNotificationCenter.defaultCenter removeObserver:self name:FCModelUpdateNotification object:USSPlayer.class];

}


@end
