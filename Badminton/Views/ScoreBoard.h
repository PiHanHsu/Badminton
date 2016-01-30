//
//  ScoreBoard.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/30.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreBoard : UIView
@property (weak, nonatomic) IBOutlet UITextField *team1ScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *team2ScoreTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *team1TieBreakScoreTextField;
@property (weak, nonatomic) IBOutlet UITextField *team2TieBreakScoreTextField;

@end
