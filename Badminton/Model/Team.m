//
//  Team.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/25.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "Team.h"

@implementation Team

@dynamic objectId;
@dynamic name;
@dynamic createBy;
@dynamic malePlayers;
@dynamic femalePlayers;
@dynamic players;
@dynamic teamPlayerStandingArray;
@dynamic isDeleted;
@dynamic photo;
@dynamic sportsType;


+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
    //return @"Parse";
}

+(Team *) createTeam {
    Team *teamObject = [Team object];
    teamObject.players = [@[] mutableCopy];
    return teamObject;
}

- (void)addPlayer: (Player *)player{
    
    [self.players addObject:player];
    self.players = [self.players mutableCopy];
    
    [self saveInBackground];
    
}

- (void)deletePlayer: (Player *)player{
    [self.players removeObject:player];
    self.players = [self.players mutableCopy];
    
    [self saveInBackground];
}

- (void)deleteTeam{
    self[@"isDeleted"] = [NSNumber numberWithBool:YES];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"YES");
        }
    }];
}

- (NSArray *) malePlayersArray: (NSArray *) playerArray{
    NSMutableArray * malePlayersArray = [@[] mutableCopy];
    for (Player * player in playerArray) {
        if ([player[@"isMale"] boolValue]){
            [malePlayersArray addObject:player];
        }
    }
    
    return malePlayersArray;
}
@end
