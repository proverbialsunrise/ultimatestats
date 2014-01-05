//
//  USSLineupViewController.h
//  SimpleStats
//
//  Created by Daniel Johnson on 1/3/14.
//  Copyright (c) 2014 Daniel Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "USSLineupViewControllerDelegate.h"

@class USSTeam;
@class USSPoint;

@interface USSLineupViewController : UITableViewController


@property (nonatomic, unsafe_unretained) id <USSLineupViewControllerDelegate> delegate;

@property (nonatomic, readonly) NSArray *playersInLineup;



- (void) configureWithTeam:(USSTeam *)team andPoint:(USSPoint *)point;



@end
