//
//  USSPoint.h
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "FCModel.h"


typedef enum pointOutcome {
    TEAMSCORE = 0,
    OPPONENTSCORE,
    NOOUTCOME
} pointOutcome;

@class USSPossession;

@interface USSPoint : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, assign) int64_t gameID;
@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic, assign) BOOL onOffense;
@property (nonatomic, assign) pointOutcome outcome;


@property (nonatomic, readonly) USSPossession *currentPossession;

+ (USSPoint *) newWithGameID:(int64_t)gameID;


- (void) turnoverDisc;

- (void) revertTurnover;

- (void) endPointWithOutcome:(pointOutcome)outcome;

@end
