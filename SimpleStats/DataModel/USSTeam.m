//
//  USSTeam.m
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSTeam.h"
#import "USSPlayer.h"
#import "USSGame.h"

@implementation USSTeam




- (void) reloadPlayers {
    self.players = [USSPlayer instancesWhere:@"teamID = ?", @(self.id)];
}


- (void) reloadGames {
    self.games = [USSGame instancesWhere:@"teamID = ?", @(self.id)];
}

- (NSArray *) players {
    if (_players == nil) {
        [self reloadPlayers];
    }
    return _players;
}

- (NSArray *) games {
    if (_games == nil) {
        [self reloadGames];
    }
    return _games;
}


@end
