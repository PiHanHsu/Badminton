//
//  Team.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/25.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import "Player.h"

@interface Team : PFObject<PFSubclassing>
@property (strong, nonatomic) NSString * objectId;
@property (strong, nonatomic) NSString * teamName;
@property (strong, nonatomic) NSString * createdBy;
@property (strong, nonatomic) NSMutableArray * malePlayers;
@property (strong, nonatomic) NSMutableArray * femalePlayers;
@property (strong, nonatomic) NSMutableArray * players;

+(Team *) createTeam;
- (void)addPlayer: (Player *)player;

@end
