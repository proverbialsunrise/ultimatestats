//
//  USSPossession.h
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "FCModel.h"

typedef enum possessionOutcome {
    SCORE = 0,
    TURNOVER,
    UNFINISHED
} possessionOutcome;


@interface USSPossession : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, assign) int64_t pointID;
@property (nonatomic, assign) NSUInteger passCount;
@property (nonatomic, assign) BOOL onOffense;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic, assign) possessionOutcome outcome;

+ (USSPossession *) newWithPointID:(int64_t) pointID;

- (void) increasePassCount;

- (void) decreasePassCount;

- (void) endPossessionWithOutcome:(possessionOutcome)outcome;

@end
