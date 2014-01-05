//
//  USSLineupViewControllerDelegate.h
//  SimpleStats
//
//  Created by Daniel Johnson on 1/3/14.
//  Copyright (c) 2014 Daniel Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class USSLineupViewController;

@protocol USSLineupViewControllerDelegate <NSObject>

- (void) loadLineupFromLineupViewController:(USSLineupViewController *) lineupController;

@end
