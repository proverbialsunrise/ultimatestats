//
//  USSTeamScoreView.h
//  SimpleStats
//
//  Created by Daniel Johnson on 12/19/2013.
//  Copyright (c) 2013 Daniel Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface USSTeamScoreView : UIView


@property (nonatomic, strong) IBOutlet UIView *topLevelSubView;
@property (nonatomic, strong) IBOutlet UILabel *teamLabel;
@property (nonatomic, strong) IBOutlet UILabel *scoreLabel;
@property (nonatomic, strong) IBOutlet UIButton *button;

+(id) teamScoreView;

@end
