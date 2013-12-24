//
//  USSTeamScoreView.m
//  SimpleStats
//
//  Created by Daniel Johnson on 12/19/2013.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import "USSTeamScoreView.h"

@implementation USSTeamScoreView


+ (id) teamScoreView {
 
    USSTeamScoreView *teamScoreView = [[[NSBundle mainBundle] loadNibNamed:@"USSTeamScoreView" owner:nil options:nil] lastObject];
    
    if ([teamScoreView isKindOfClass:[USSTeamScoreView class]]) {
        return teamScoreView;
    }

    NSAssert(0, @"Initialized teamScoreView but did not receive the corerct class from Nib. Fatal error.");
    return nil;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
