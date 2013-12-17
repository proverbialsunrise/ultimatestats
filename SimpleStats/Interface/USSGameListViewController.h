//
//  USSGameListViewController.h
//  SimpleStats
//
//  Created by Daniel Johnson on 12/13/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//


#import <UIKit/UIKit.h>

@class USSTeam;

@interface USSGameListViewController : UITableViewController

- (void) configureWithTeam:(USSTeam *)aTeam;

@end
