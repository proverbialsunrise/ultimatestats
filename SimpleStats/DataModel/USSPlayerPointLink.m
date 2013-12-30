//
//  USSPlayerPoint.m
//  SimpleStats
//
//  Created by Daniel Johnson on 12/30/2013.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSPlayerPointLink.h"
#import "USSPlayer.h"
#import "USSPoint.h"

@implementation USSPlayerPointLink

+ (USSPlayerPointLink *) newWithPlayerID:(int64_t)playerID PointID:(int64_t)pointID {
    USSPlayerPointLink *playerPointLink = [USSPlayerPointLink new];
    if (playerPointLink) {
        playerPointLink.playerID = playerID;
        playerPointLink.pointID = pointID;
    }
    return playerPointLink;
}


- (USSPlayer *) player {
    return [USSPlayer instanceWithPrimaryKey:@(self.playerID)];
}

- (USSPoint *) point {
    return [USSPoint instanceWithPrimaryKey:@(self.pointID)];
}


@end
