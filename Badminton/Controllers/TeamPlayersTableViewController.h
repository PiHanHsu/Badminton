//
//  TeamPlayersTableViewController.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/22.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayListDataSource.h"
#import "Team.h"

@interface TeamPlayersTableViewController : UITableViewController

@property (strong, nonatomic) Team * teamObject;

@end
