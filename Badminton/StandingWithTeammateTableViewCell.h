//
//  StandingWithTeammateTableViewCell.h
//  Badminton
//
//  Created by PiHan Hsu on 2016/1/15.
//  Copyright © 2016年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandingWithTeammateTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teammateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *winsLabel;
@property (weak, nonatomic) IBOutlet UILabel *losesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;

@end
