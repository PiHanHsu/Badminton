//
//  AddPlayerViewController.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/26.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Player.h"
#import "Team.h"

@interface AddPlayerViewController : UIViewController
@property (strong, nonatomic) Team * teamObject;

@end
