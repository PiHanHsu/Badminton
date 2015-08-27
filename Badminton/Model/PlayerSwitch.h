//
//  PlayerSwitch.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/27.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import <Parse/Parse.h>

@interface PlayerSwitch : UISwitch
@property (strong, nonatomic) Player * player;


@end
