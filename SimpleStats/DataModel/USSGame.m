//
//  USSGame.m
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSGame.h"
#import "USSTeam.h"
#import "USSPossession.h"
#import "USSPoint.h"

@interface USSGame ()

@property (nonatomic, retain) NSMutableArray *pointStack;

@end


@implementation USSGame


+ (USSGame *) newWithTeamID:(int64_t)teamID {
    USSGame *newGame = [USSGame new];
    if (newGame) {
        newGame.pointStack = [NSMutableArray array];
    }
    return newGame;
}

- (USSTeam *) team {
    USSTeam *_team = [USSTeam instanceWithPrimaryKey:@(self.teamID)];
    return _team;
}


- (NSMutableArray *) pointStack {
    if (!_pointStack) {
        _pointStack = [NSMutableArray arrayWithArray:[USSPoint instancesWhere:@"pointID = ? ORDER BY startTime ASC", self.id]];
    }
    return _pointStack;
}


- (USSPoint *) currentPoint {
    return (USSPoint *)[self.pointStack lastObject];
}

- (USSPossession *) currentPosssession {
    return self.currentPoint.currentPossession;
}


- (void) scorePoint {
    //determine if *team scored or the opponent scored.
    pointOutcome outcome;
    if (self.currentPosssession.onOffense) {
        outcome = TEAMSCORE;
    } else {
        outcome = OPPONENTSCORE;
    }
    //end the current point.  Also ends the current possession.
    [self.currentPoint endPointWithOutcome:outcome];
    //Setup the next point.
    USSPoint *newPoint = [USSPoint newWithGameID:self.id];
    [newPoint save];
    [self.pointStack addObject:newPoint];
}

- (void) revertPoint {
    //revert the last point, pop it from the stack.
    USSPoint *pointToDelete = self.currentPoint;
    [self.pointStack removeLastObject];
    [pointToDelete delete];
    
    self.currentPoint.outcome = NOOUTCOME;
    self.currentPosssession.outcome = UNFINISHED;
}




@end
