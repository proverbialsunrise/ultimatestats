//
//  USSGameTrackingViewController.h
//  SimpleStats
//
//  Created by Daniel Johnson on 12/19/2013.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USSTeamScoreView;
@class USSGame;

@interface USSGameTrackingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) USSTeamScoreView *homeTeamScoreView;
@property (nonatomic, strong) USSTeamScoreView *opponentTeamScoreView;

- (void) configureWithGame:(USSGame *)game;

/*
@property (nonatomic, strong) UIButton *passButton;
@property (nonatomic, strong) UIButton *turnoverButton;
@property (nonatomic, strong) UIButton *scoreButton;
@property (nonatomic, strong) UIButton *undoButton;
*/

- (IBAction) passButtonPushed:(id)sender;
- (IBAction) turnoverButtonPushed:(id)sender;
- (IBAction) scoreButtonPushed:(id)sender;
- (IBAction) undoButtonPoshed:(id)sender;
- (IBAction) substituteButtonPushed:(id)sender;


@property (nonatomic, strong) IBOutlet UIView *buttonContainerView;

@property (nonatomic, strong) IBOutlet UILabel *passCountLabel;

@property (nonatomic, strong) IBOutlet UITableView *tableView;


@end
