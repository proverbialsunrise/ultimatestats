//
//  USSPossession.h
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "FCModel.h"

@interface USSPossession : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, assign) int64_t pointID;
@property (nonatomic, assign) int64_t passCount;
@property (nonatomic, assign) BOOL onOffense;
@property (nonatomic, assign) NSDate *startTime;
@property (nonatomic, assign) NSDate *endTime;
@property (nonatomic, assign) int64_t outcome;

@end
