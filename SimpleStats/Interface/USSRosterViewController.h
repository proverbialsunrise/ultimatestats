//
//  USSRosterViewController.h
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class USSTeam;

@interface USSRosterViewController : UITableViewController
- (void) configureWithTeam:(USSTeam *) team;

@end
