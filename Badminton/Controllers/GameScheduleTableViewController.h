//
//  GameScheduleTableViewController.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Team.h"

@interface GameScheduleTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray * malePlaylistArray;
@property (strong, nonatomic) NSMutableArray * malePlaylistArrayNew;
@property (strong, nonatomic) NSMutableArray * femalePlaylistArray;
@property (strong, nonatomic) NSMutableArray * femalePlaylistArrayNew;
@property (strong, nonatomic) Team * teamObject;
@property NSInteger * rows;



@end
