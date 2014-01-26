//
//  USSPoint.m
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSPoint.h"
#import "USSPossession.h"
#import "USSPlayer.h"
#import "USSPlayerPointLink.h"

@interface USSPoint ()

@property (nonatomic, retain) NSMutableArray *possessionStack;

@property (nonatomic, retain) NSMutableArray *mutablePlayers;

@end


@implementation USSPoint

+ (USSPoint *) newWithGameID:(int64_t) gameID {
    USSPoint *newPoint = [USSPoint new];
    if (newPoint) {
        newPoint.gameID = gameID;
        newPoint.outcome = NOOUTCOME;
        newPoint.startTime = [NSDate date];
        [newPoint save];

        //Now make associated objects.
        newPoint.possessionStack = [NSMutableArray array];
        //Add the first possession to the stack so that we are ready to start tracking.
        USSPossession *possession = [USSPossession newWithPointID:newPoint.id];
        [newPoint.possessionStack addObject:possession];
        
        //Create the mutablePlayers array.
        newPoint.mutablePlayers = [NSMutableArray array];
    }
    return newPoint;
}

- (NSMutableArray *) possessionStack {
    if (!_possessionStack) {
        _possessionStack = [NSMutableArray arrayWithArray:[USSPossession instancesWhere:@"pointID = ? ORDER BY startTime ASC", @(self.id)]];
    }
    return _possessionStack;
}

- (NSMutableArray *) mutablePlayers {
    if (!_mutablePlayers) {
        _mutablePlayers = [NSMutableArray array];
        //get the list of playerIDs for this point from the DB.
        //Load the players into the players array.
        NSArray *playerPointLinks = [USSPlayerPointLink instancesWhere:@"pointID = ?", @(self.id)];
        for (USSPlayerPointLink *playerPointLink in playerPointLinks) {
            [_mutablePlayers addObject:playerPointLink.player];
        }
    }
    return _mutablePlayers;
}

- (USSPossession *) currentPossession {
    return (USSPossession * )[self.possessionStack lastObject];
}

- (NSInteger) possessionCount {
    return [self.possessionStack count];
}


- (void) turnoverDisc {
    //End the current possession and set its outcome.
    [self.currentPossession endPossessionWithOutcome:TURNOVER];
    //Create a new possession.  Set it's offense/defense status. Push onto possession stack.
    USSPossession *newPossession = [USSPossession newWithPointID:self.id];
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

- (void) addPlayer:(USSPlayer *)player {
    //Create a new PlayerPointLink object and save it to database.
    USSPlayerPointLink *playerPointLink = [USSPlayerPointLink newWithPlayerID:player.id PointID:self.id];
    [playerPointLink save];
    //Add the player to the players array.
    [self.mutablePlayers addObject:player];
}

- (void) addPlayers:(NSArray *)players {
    for (USSPlayer * p in players) {
        [self addPlayer:p];
    }
}

- (void) removePlayer:(USSPlayer *)player {
    if ([self.mutablePlayers containsObject:player]) {
        [self.mutablePlayers removeObject:player];
        USSPlayerPointLink *playerPointLink =[USSPlayerPointLink firstInstanceWhere:@"playerID = ? AND pointID = ?", @(player.id), @(self.id)];
        [playerPointLink delete];
    } else {
        NSLog(@"Player is not part of the point...doing nothing here");
        //TODO I should add some error returns to these methods...but for now...
    }
}

- (void) removePlayers:(NSArray *)players {
    for (USSPlayer* p in players) {
        [self removePlayer:p];
    }
}

- (void) removeAllPlayers{
    [self.mutablePlayers removeAllObjects];
    [USSPlayerPointLink executeUpdateQuery:@"DELETE FROM $T WHERE pointID = ?", @(self.id)];
}

- (NSArray *)players {
    return self.mutablePlayers;
}


@end
