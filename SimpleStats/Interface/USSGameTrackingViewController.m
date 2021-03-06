//
//  USSGameTrackingViewController.m
//  SimpleStats
//
//  Created by Daniel Johnson on 12/19/2013.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSGameTrackingViewController.h"
#import "USSTeamScoreView.h"
#import "USSRosterCell.h"
#import "USSLineupViewController.h"

#import "USSGame.h"
#import "USSTeam.h"
#import "USSPoint.h"
#import "USSPossession.h"
#import "USSPlayer.h"

#define ToolbarAndNavBarHeight 64

#define hasDiscColour [UIColor colorWithRed:197.0/255.0 green:237.0/255.0 blue:198.0/255.0 alpha:1.0];
#define noDiscColour [UIColor whiteColor];

@interface USSGameTrackingViewController ()

@property (nonatomic, strong) USSGame *game;


- (void) updateUI;

- (void) homeTeamScoreViewTapped;
- (void) opponentTeamScoreViewTapped;


@end

@implementation USSGameTrackingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"RosterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RosterCell"];

    

    [self.view addSubview:self.homeTeamScoreView];
    [self.homeTeamScoreView.teamLabel setText:self.game.team.name];
    [self.homeTeamScoreView.button addTarget:self action:@selector(homeTeamScoreViewTapped) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.opponentTeamScoreView];
    [self.opponentTeamScoreView.teamLabel setText:self.game.opponent];
    [self.opponentTeamScoreView.button addTarget:self action:@selector(opponentTeamScoreViewTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.instructionView  setAlpha:0.0];
   
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureWithGame:(USSGame *)game {
    self.game = game;
}

- (void) updateUI {
    [self.homeTeamScoreView.scoreLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.game.teamScore]];
    [self.opponentTeamScoreView.scoreLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.game.opponentScore]];
    
    [self.passCountLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)self.game.passCount]];
    if (self.game.currentPossession.onOffense) {
        self.homeTeamScoreView.backgroundColor = hasDiscColour;
        self.opponentTeamScoreView.backgroundColor = noDiscColour;
    } else {
        self.homeTeamScoreView.backgroundColor = noDiscColour;
        self.opponentTeamScoreView.backgroundColor = hasDiscColour;
    }
    
    if (self.undoManager.canUndo) {
        [self.undoButton setEnabled:YES];
    } else {
        [self.undoButton setEnabled:NO];
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    if ([self.game.currentPoint.players count] < 1) {
        //If there are no players...Display the pre-pull message.
        [self.instructionView setAlpha:1.0];
        [self.instructionLabel setAlpha:1.0];
    } else {
        //else hide the pre-pull message.
        [self.instructionView setAlpha:0.0];
        [self.instructionLabel setAlpha:0.0];
    }
    [UIView commitAnimations];
}


- (void) homeTeamScoreViewTapped {
    [self.game.currentPossession setOnOffense:YES];
    if (self.game.currentPoint.possessionCount == 1){
        [self.game.currentPoint setOnOffense:YES];
    }
    [self updateUI];
}

- (void) opponentTeamScoreViewTapped {
    [self.game.currentPossession setOnOffense:NO];
    if (self.game.currentPoint.possessionCount == 1){
        [self.game.currentPoint setOnOffense:NO];
    }
    [self updateUI];
}


- (IBAction) passButtonPushed:(id)sender {
    NSLog(@"PassButton");
    [self.game increasePassCount];
    [self.undoManager registerUndoWithTarget:self.game selector:@selector(decreasePassCount) object:nil];
    [self updateUI];

}

- (IBAction) turnoverButtonPushed:(id)sender {
    NSLog(@"TurnoverButton");
    [self.game turnoverDisc];
    [self.undoManager registerUndoWithTarget:self.game selector:@selector(revertTurnover) object:nil];
    [self updateUI];

}

- (IBAction) scoreButtonPushed:(id)sender {
    NSLog(@"ScoreButton");
    [self.game scorePoint];
    [self.undoManager registerUndoWithTarget:self.game selector:@selector(revertPoint) object:nil];
    [self updateUI];
    [self.tableView reloadData];

}

- (IBAction) undoButtonPoshed:(id)sender {
    NSLog(@"UndoButton");
    [self.undoManager undo];
    [self updateUI];
    [self.tableView reloadData];

}


- (IBAction) substituteButtonPushed:(id)sender{
    NSLog(@"subButton");
    USSLineupViewController *lineupViewController = [[USSLineupViewController alloc] initWithStyle:UITableViewStylePlain];
    [lineupViewController configureWithTeam:self.game.team andPoint:self.game.currentPoint];
    lineupViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lineupViewController];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void) loadLineupFromLineupViewController:(USSLineupViewController *)lineupController {
    [self.game.currentPoint removeAllPlayers];
    [self.game.currentPoint addPlayers:lineupController.playersInLineup];
    [self.tableView reloadData];
    [self updateUI];
}


# pragma mark UITableViewDelegate






# pragma mark UITableViewDataSource

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    return [self.game.currentPoint.players count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RosterCell";
    USSRosterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    USSPlayer *player = [self.game.currentPoint.players objectAtIndex:indexPath.row];
    [cell.numberLabel setText:player.number];
    [cell.nameLabel setText:player.name];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
    
}


@end
