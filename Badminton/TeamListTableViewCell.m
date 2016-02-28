//
//  TeamListTableViewCell.m
//  Badminton
//
//  Created by PiHan Hsu on 2016/1/29.
//  Copyright © 2016年 PiHan Hsu. All rights reserved.
//

#import "TeamListTableViewCell.h"

@implementation TeamListTableViewCell
- (void)awakeFromNib {
    // Initialization code
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.cellView.bounds];
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cellView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.cellView.layer.shadowOpacity = 0.3f;
    self.cellView.layer.shadowPath = shadowPath.CGPath;
}
@end
