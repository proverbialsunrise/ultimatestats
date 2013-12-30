//
//  USSPlayerPoint.h
//  SimpleStats
//
//  Created by Daniel Johnson on 12/30/2013.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "FCModel.h"

@class USSPlayer;
@class USSPoint;

@interface USSPlayerPointLink : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, assign) int64_t playerID;
@property (nonatomic, assign) int64_t pointID;

@property (nonatomic, readonly) USSPlayer *player;
@property (nonatomic, readonly) USSPoint *point;

+ (USSPlayerPointLink *) newWithPlayerID:(int64_t)playerID PointID:(int64_t)pointID;

@end
