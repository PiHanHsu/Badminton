//
//  Player.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/26.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>

@interface Player : PFObject<PFSubclassing>
@property (strong, nonatomic) NSString * objectId;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * name;


+(Player *) createPlayer;
@end
