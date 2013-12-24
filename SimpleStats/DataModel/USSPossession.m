//
//  USSPossession.m
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSPossession.h"

@implementation USSPossession

+ (USSPossession *) newWithPointID:(int64_t) pointID{
    USSPossession *newPossession = [USSPossession new];
    if (newPossession) {
        newPossession.pointID = pointID;
        newPossession.outcome = UNFINISHED;
        newPossession.startTime = [NSDate date];
        newPossession.passCount = 0;
    }
    return newPossession;
}

- (void) increasePassCount {
    self.passCount++;
    //idea, set the startTime based on the time the passCount goes from 0 to 1
    [self save];
}

- (void) decreasePassCount {
    self.passCount--;
    [self save];
}

- (void) endPossessionWithOutcome:(possessionOutcome)outcome{
    self.outcome = outcome;
    self.endTime = [NSDate date];
    [self save];
}


@end
