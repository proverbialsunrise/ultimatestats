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

#import "USSGame.h"
#import "USSTeam.h"
#import "USSPoint.h"
#import "USSPossession.h"

#define ToolbarAndNavBarHeight 64

@interface USSGameTrackingViewController ()

@property (nonatomic, strong) USSGame *game;

- (void) updateUI;

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
    // Do any additional setup after loading the view from its nib.
    USSTeamScoreView *hScoreView = [USSTeamScoreView teamScoreView];
    CGSize hSViewSize = hScoreView.frame.size;
    #pragma mark TODO fix the frame sizing here...Should be 80, but 20 is better
    [hScoreView setFrame:CGRectMake(0, ToolbarAndNavBarHeight, hSViewSize.width, 16)];
    self.homeTeamScoreView = hScoreView;
    [self.view addSubview:self.homeTeamScoreView];
    [self.homeTeamScoreView.scoreLabel setText:@"25"];
    [self.homeTeamScoreView.teamLabel setText:self.game.team.name];
    
    USSTeamScoreView *oScoreView = [USSTeamScoreView teamScoreView];
    CGSize oSViewSize = oScoreView.frame.size;
    [oScoreView setFrame:CGRectMake(hSViewSize.width, ToolbarAndNavBarHeight, oSViewSize.width, 16)];
    self.opponentTeamScoreView = oScoreView;
    [self.view addSubview:self.opponentTeamScoreView];
    [self.opponentTeamScoreView.scoreLabel setText:@"5"];
    [self.opponentTeamScoreView.teamLabel setText:self.game.opponent];
    
    
   
    [[self tableView] registerNib:[UINib nibWithNibName:@"RosterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RosterCell"];
    
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

}

- (IBAction) undoButtonPoshed:(id)sender {
    NSLog(@"UndoButton");
    [self.undoManager undo];
    [self updateUI];

}


- (IBAction) substituteButtonPushed:(id)sender{
    NSLog(@"subButton");
}


# pragma mark UITableViewDelegate






# pragma mark UITableViewDataSource

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    #pragma TODO make this return the right number according to the current lineup
    return 7;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RosterCell";
    USSRosterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSUInteger row = indexPath.row;
    // Configure the cell...
    [cell.numberLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
    [cell.nameLabel setText:[NSString stringWithFormat:@"Player %lu", (unsigned long)row]];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
    
}


@end
