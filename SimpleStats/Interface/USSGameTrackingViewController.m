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

#define ToolbarAndNavBarHeight 64

@interface USSGameTrackingViewController ()

@property (nonatomic, strong) USSGame *game;

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
    
    
    [self.passCountLabel setText:@"27"];
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"RosterTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"RosterCell"];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureWithGame:(USSGame *)game {
    self.game = game;
}


- (IBAction) passButtonPushed:(id)sender {
    NSLog(@"PassButton");
}

- (IBAction) turnoverButtonPushed:(id)sender {
    NSLog(@"TurnoverButton");
}

- (IBAction) scoreButtonPushed:(id)sender {
    NSLog(@"ScoreButton");
}

- (IBAction) undoButtonPoshed:(id)sender {
    NSLog(@"UndoButton");
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
    [cell.numberLabel setText:[NSString stringWithFormat:@"%u",row]];
    [cell.nameLabel setText:[NSString stringWithFormat:@"Player %u", row]];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
    
}


@end
