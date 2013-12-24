//
//  USSGame.h
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "FCModel.h"

@class USSTeam;
@class USSPoint;
@class USSPossession;

@interface USSGame : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) int64_t teamID;
@property (nonatomic, retain) NSString *opponent;

@property (nonatomic, readonly) USSTeam *team;
@property (nonatomic, readonly) USSPoint *currentPoint;
@property (nonatomic, readonly) USSPossession *currentPosssession;


+ (USSGame *) newWithTeamID:(int64_t)teamID;

- (void) scorePoint;

- (void) revertPoint;



@end
