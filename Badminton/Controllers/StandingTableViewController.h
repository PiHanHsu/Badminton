//
//  StandingTableViewController.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/1.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Team.h"

@interface StandingTableViewController : UITableViewController
@property (strong, nonatomic) NSString * playerId;
@property (strong, nonatomic) Player * currentPlayerForStats;
@property (strong, nonatomic) Team * teamObject;

@end
