//
//  Team.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/25.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "Team.h"
#import "Standing.h"

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
    [self createPlayerStanding:player];
    
}

- (void)deletePlayer: (Player *)player{
    [self.players removeObject:player];
    self.players = [self.players mutableCopy];
    
    [self saveInBackground];
    //[self removePlayerStanding:player];
}

- (void)deleteTeam{
    self[@"isDeleted"] = [NSNumber numberWithBool:YES];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"YES");
        }
    }];
}

- (void) removePlayerStanding: (Player *) player{
    
}
- (void) createPlayerStanding: (Player *) player{
    
    NSString * playerId = player.objectId;
    if (![self.teamPlayerStandingArray containsObject:playerId]) {
        Standing * standingObject = [Standing createPlayerStanding];
        standingObject[@"player"] = player;
        standingObject[@"playerId"] = player.objectId;
        standingObject[@"team"] = self;
        standingObject[@"wins"] = [NSNumber numberWithInt:0];
        standingObject[@"singleWins"] = [NSNumber numberWithInt:0];
        standingObject[@"doubleWins"] = [NSNumber numberWithInt:0];
        standingObject[@"mixWins"] = [NSNumber numberWithInt:0];
        standingObject[@"loses"] = [NSNumber numberWithInt:0];
        standingObject[@"singleLoses"] = [NSNumber numberWithInt:0];
        standingObject[@"doubleLoses"] = [NSNumber numberWithInt:0];
        standingObject[@"mixLoses"] = [NSNumber numberWithInt:0];
        
        [standingObject saveInBackground];
    }
}

-(void) loadTeamPlayerStandingArrayWithDone:(void (^)(NSArray * teamPlayerStandingArray))doneHandle{
    self.teamPlayerStandingArray = [@[] mutableCopy];
    
    PFQuery * query = [PFQuery queryWithClassName:@"Standing"];
    [query whereKey:@"team" equalTo:[PFObject objectWithoutDataWithClassName:@"Team" objectId:self.objectId]];
    //self.teamPlayerStandingArray = [[NSMutableArray alloc]initWithArray:[query findObjects]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * array, NSError * error){
        if (!error){
            self.teamPlayerStandingArray = array;
//            for (PFObject * standing in array) {
//                [standing pinInBackground];
//            }
            if (doneHandle) {
                doneHandle (self.teamPlayerStandingArray);
            }
        }else{
            NSLog(@"error:%@ ", error);
        }
    }];
    //return self.teamPlayerStandingArray;
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
