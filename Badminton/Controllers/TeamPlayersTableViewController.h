//
//  TeamPlayersTableViewController.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/22.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayListDataSource.h"

@interface TeamPlayersTableViewController : UITableViewController
@property (strong, nonatomic) NSString * teamName;
@property (strong, nonatomic) PFObject * teamObject;

@end
