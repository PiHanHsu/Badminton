//
//  DataSource.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/4.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "DataSource.h"

@interface DataSource()

//@property (nonatomic,strong) NSMutableArray *teamArray;
@property (nonatomic,strong) NSMutableArray *playerArray;
@property (nonatomic,strong) NSMutableArray *gameArray;

@property (strong, nonatomic) Player * currentPlayer;

@end


@implementation DataSource
+ (DataSource *)sharedInstance {
    static DataSource *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - user object
-(PFUser *) userObject {
    
    if(!_userObject) {
        _userObject = [PFUser currentUser];
        
        if(!_userObject) {
            NSLog(@"Error! should never occur!");
        }
    }
    return _userObject;
}


#pragma mark - players
-(NSMutableArray *) playerArray{
    if(!_playerArray)
        _playerArray = [@[] mutableCopy];
    return _playerArray;
}
- (void) loadPlayersFromServer{
    
}

-(void) addPlayer:(Player *) playerObject toTeam:(Team *)teamObject{
    [teamObject[@"players"] addObject:playerObject];
}


-(void) deletePlayer:(Player *) playerObject fromTeam:(Team *)teamObject{
    [teamObject[@"players"] removeObject:playerObject];
}

#pragma mark - teams

-(NSMutableArray *) teamArray{
    if(!_teamArray)
        _teamArray = [@[] mutableCopy];
    return _teamArray;
}

- (void) loadTeamsFromServer{
    PFUser * user = [PFUser currentUser];
    PFQuery * getUserId = [Player query];
    [getUserId whereKey:@"user" equalTo:user.objectId];
    [getUserId findObjectsInBackgroundWithBlock:^(NSArray * players, NSError * error){
        self.currentPlayer = players[0];
    }];
    
    //this query doesn't work!!
//    PFQuery * queryFromPlayers = [Team query];
//    [queryFromPlayers whereKey:@"malePlayers" equalTo:[PFObject objectWithoutDataWithClassName:@"Player" objectId:self.currentPlayer.objectId]];
    //PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryForCreatedBy,queryForNotDeleted]];
    
    PFQuery * query = [Team query];
    [query whereKey:@"createBy" equalTo:user.objectId];
    [query whereKey:@"isDeleted" equalTo:[NSNumber numberWithBool:NO]];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * teams, NSError * error){
       
        self.teamArray = [teams mutableCopy];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadingDataFinished" object:self];
    }];
    
}

-(void) addTeam:(Team *) teamObject{
    [self.teamArray addObject:teamObject];
    
}
-(void) deleteTeam:(Team *) teamObject{
    [self.teamArray removeObject:teamObject];
    
}


- (void) loadGamesFromServer{
    
}

-(void) saveGame:(Game *) gameObject{
    
}

@end
