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
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * createBy;
@property (strong, nonatomic) NSMutableArray * malePlayers;
@property (strong, nonatomic) NSMutableArray * femalePlayers;
@property (strong, nonatomic) NSMutableArray * players;
@property (strong, nonatomic) NSArray * teamPlayerStandingArray; // of each player standing
@property (assign, nonatomic) BOOL isDeleted;
@property (strong, nonatomic) PFFile * photo;
@property (strong, nonatomic) NSString * sportsType;

+(Team *) createTeam;
- (void)addPlayer: (Player *)player;
- (void)deletePlayer: (Player *)player;
- (void)deleteTeam;
//- (NSMutableArray *) loadTeamPlayerStandingArray;



@end
