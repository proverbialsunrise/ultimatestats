//
//  USSPoint.m
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSPoint.h"
#import "USSPossession.h"

@interface USSPoint ()

@property (nonatomic, retain) NSMutableArray *possessionStack;

@end


@implementation USSPoint

+ (USSPoint *) newWithGameID:(int64_t) gameID {
    USSPoint *newPoint = [USSPoint new];
    if (newPoint) {
        newPoint.gameID = gameID;
        newPoint.outcome = NOOUTCOME;
        newPoint.startTime = [NSDate date];
        newPoint.possessionStack = [NSMutableArray array];
        //Add the first possession to the stack so that we are ready to start tracking.
        USSPossession *possession = [USSPossession newWithPointID:newPoint.id];
        [possession save];
        [newPoint.possessionStack addObject:possession];
    }
    return newPoint;
}

- (NSMutableArray *) possessionStack {
    if (!_possessionStack) {
        _possessionStack = [NSMutableArray arrayWithArray:[USSPossession instancesWhere:@"pointID = ? ORDER BY startTime ASC", self.id]];
    }
    return _possessionStack;
}

- (USSPossession *) currentPossession {
    return (USSPossession * )[self.possessionStack lastObject];
}


- (void) turnoverDisc {
    //End the current possession and set its outcome.
    [self.currentPossession endPossessionWithOutcome:TURNOVER];
    //Create a new possession.  Set it's offense/defense status. Push onto possession stack.
    USSPossession *newPossession = [USSPossession new];
    newPossession.onOffense = !(self.currentPossession.onOffense);
    [newPossession save];
    [self.possessionStack addObject:newPossession];
}

- (void) revertTurnover {
    //Pop the top possession on the stack and delete it
    USSPossession *oldCurrentPossession = (USSPossession *)[self.possessionStack lastObject];
    [self.possessionStack removeLastObject];
    [oldCurrentPossession delete];
    //set the outcome of the current possession back to unknown
    self.currentPossession.outcome = UNFINISHED;
}

- (void) endPointWithOutcome:(pointOutcome)outcome {
    //Determine the outcome.
    [self.currentPossession endPossessionWithOutcome:SCORE];
    self.endTime = [NSDate date];
    self.outcome = outcome;
    [self save];
}



@end
