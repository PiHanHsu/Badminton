//
//  ScoreBoard.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/30.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "ScoreBoard.h"

@implementation ScoreBoard


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.cornerRadius = 10.0;
    self.clipsToBounds = YES;
    self.cancelButton.layer.cornerRadius = 5.0;
    self.cancelButton.clipsToBounds = YES;
    self.saveButton.layer.cornerRadius = 5.0;
    self.saveButton.clipsToBounds = YES;
    self.team1TieBreakScoreTextField.hidden = YES;
    self.team2TieBreakScoreTextField.hidden = YES;
    
}


@end
