//
//  USSTeam.h
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "FCModel.h"

@interface USSTeam : FCModel

//FCModel properties
@property (nonatomic, assign) int64_t id;
@property (nonatomic, copy) NSString *name;

//Other properties
@property (nonatomic, retain) NSArray * players;
@property (nonatomic, retain) NSArray * games;


- (void) reloadPlayers;

- (void) reloadGames;

@end
