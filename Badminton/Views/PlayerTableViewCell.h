//
//  PlayerTableViewCell.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Player.h"
#import "PlayerSwitch.h"

@interface PlayerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@property (weak, nonatomic) IBOutlet PlayerSwitch *playerSwitch;

@end
