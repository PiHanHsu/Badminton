//
//  StandingTableViewCell.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/29.
//  Copyright © 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *winsLabel;
@property (weak, nonatomic) IBOutlet UILabel *losesLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@end
