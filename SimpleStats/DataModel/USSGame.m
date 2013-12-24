//
//  USSGame.m
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSGame.h"
#import "USSTeam.h"

@implementation USSGame

- (USSTeam *) team {
    USSTeam *_team = [USSTeam instanceWithPrimaryKey:@(self.teamID)];
    return _team;
}




@end
