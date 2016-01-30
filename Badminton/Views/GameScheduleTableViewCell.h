//
//  GameScheduleTableViewCell.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *player1Label;
@property (weak, nonatomic) IBOutlet UILabel *player2Label;
@property (weak, nonatomic) IBOutlet UILabel *player3Label;
@property (weak, nonatomic) IBOutlet UILabel *player4Label;
@property (weak, nonatomic) IBOutlet UILabel *gameNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *team1ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *team2ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *team1TieBreakScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *team2TieBreakScoreLabel;

@end
