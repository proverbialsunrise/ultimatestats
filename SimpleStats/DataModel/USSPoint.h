//
//  USSLineup.h
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "FCModel.h"

@interface USSPoint : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, assign) int64_t gameID;
@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic, assign) BOOL onOffense;
@property (nonatomic, assign) BOOL scored;


@end
