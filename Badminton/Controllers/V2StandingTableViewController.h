//
//  V2StandingTableViewController.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/29.
//  Copyright © 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"
#import "Player.h"
#import "DataSource.h"
#import <Parse/Parse.h>

@interface V2StandingTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray * teamArray;
@property (strong, nonatomic) Team * teamObject;

@end
