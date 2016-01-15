//
//  StandingWithTeammateTableViewController.h
//  Badminton
//
//  Created by PiHan Hsu on 2016/1/15.
//  Copyright © 2016年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface StandingWithTeammateTableViewController : UITableViewController
@property (strong, nonatomic) NSArray * playerStatsWithDoubleGameArray;
@property (strong, nonatomic) NSArray * playerStatsWithMixGameArray;
@property (strong, nonatomic) Player * currentPlayerForStats;
@property (strong, nonatomic) NSString * gameType;

@end
