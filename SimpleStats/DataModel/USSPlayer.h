//
//  USSPlayer.h
//  SimpleStats
//
//  Created by Daniel Johnson on 11/23/13.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "FCModel.h"

@interface USSPlayer : FCModel

@property (nonatomic, assign) int64_t id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, assign) int64_t teamID;


@end
