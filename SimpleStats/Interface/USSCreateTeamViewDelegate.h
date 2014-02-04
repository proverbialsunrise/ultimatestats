//
//  USSCreateTeamViewDelegateProtocol.h
//  SimpleStats
//
//  Created by Daniel Johnson on 1/7/14.
//  Copyright (c) 2014 Daniel Johnson. All rights reserved.
//


#import <Foundation/Foundation.h>

@class USSTeam;

@protocol USSCreateTeamViewDelegate<NSObject>


@optional

- (void) configureWithTeam:(USSTeam *)team;

@end
