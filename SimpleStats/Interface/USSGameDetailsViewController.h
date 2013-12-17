//
//  USSGameDetailsViewController.h
//  SimpleStats
//
//  Created by Daniel Johnson on 12/14/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USSTeam;
@class USSGame;

@interface USSGameDetailsViewController : UITableViewController <UITextFieldDelegate>

- (void) configureWithNewGameForTeam:(USSTeam *)team;


- (void) configureWithGame:(USSGame *)game;

@end
