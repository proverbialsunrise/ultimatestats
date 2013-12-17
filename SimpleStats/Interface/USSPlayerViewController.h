//
//  USSPlayerViewController.h
//  SimpleStats
//
//  Created by Daniel Johnson on 12/6/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class USSPlayer;
@class USSTeam;

@interface USSPlayerViewController : UITableViewController

- (void) configureWithPlayer:(USSPlayer *)aPlayer;

- (void) configureWithNewPlayerForTeam:(USSTeam *)team;


@end
