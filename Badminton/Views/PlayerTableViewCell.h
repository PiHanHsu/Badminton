//
//  PlayerTableViewCell.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *playerLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@end
