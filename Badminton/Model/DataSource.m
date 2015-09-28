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

@property (strong, nonatomic) PFObject * currentPlayer;

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
    PFQuery * getUserId = [PFQuery queryWithClassName:@"Player"];
    [getUserId whereKey:@"user" equalTo:user.objectId];
    self.currentPlayer = [getUserId getFirstObject];
    
//    [getUserId findObjectsInBackgroundWithBlock:^(NSArray * players, NSError * error){
//        if (!error) {
//            self.currentPlayer = players[0];
//            NSLog(@"currentPlayer: %@", self.currentPlayer);
//        }else{
//            NSLog(@"error: %@", error);
//        }
//       
//    }];
    
    //this query doesn't work!!
    PFQuery * queryFromPlayers = [Team query];
    [queryFromPlayers whereKey:@"players" equalTo:[PFObject objectWithoutDataWithClassName:@"Player" objectId:self.currentPlayer.objectId]];
    
    PFQuery * query = [Team query];
    [query whereKey:@"createBy" equalTo:user.objectId];
    [query whereKey:@"isDeleted" equalTo:[NSNumber numberWithBool:NO]];
    
    PFQuery *queryAll = [PFQuery orQueryWithSubqueries:@[query,queryFromPlayers]];
    
    [queryAll findObjectsInBackgroundWithBlock:^(NSArray * teams, NSError * error){
       
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
    PFUser * user = [PFUser currentUser];
    PFQuery * getUserId = [PFQuery queryWithClassName:@"Player"];
    [getUserId whereKey:@"user" equalTo:user.objectId];
    PFObject * currentPlayer = [getUserId getFirstObject];
    PFQuery * queryWinGames = [PFQuery queryWithClassName:@"Game"];
    [queryWinGames whereKey:@"winTeam" equalTo:currentPlayer.objectId];
    PFQuery * queryLoseGames = [PFQuery queryWithClassName:@"Game"];
    [queryLoseGames whereKey:@"loseTeam" equalTo:currentPlayer.objectId];

    PFQuery *queryBoth = [PFQuery orQueryWithSubqueries:@[queryWinGames , queryLoseGames]];
    
    [queryBoth findObjectsInBackgroundWithBlock:^(NSArray *gamesArray, NSError * error){
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        
        self.currentPlayerGamesArray = [gamesArray sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]];
        [self createStatsArray:self.currentPlayerGamesArray];

    }];
    
}

- (NSMutableArray *) createStatsArray:(NSArray *) playerGameArray{
    self.currentPlayerStatsArray = [@[] mutableCopy];
    
    // taking too long to calculate, need a better algorithm
    
    for (int i = 0 ; i < playerGameArray.count; i++) {
        NSDictionary * statsDict = [[NSDictionary alloc] init];
        NSMutableArray * winTeam = playerGameArray[i][@"winTeam"];
        NSMutableArray * loseTeam = playerGameArray[i][@"loseTeam"];

        if ([winTeam containsObject:self.currentPlayer.objectId]) {
            [winTeam removeObject:self.currentPlayer];
            Player * teamMate = winTeam[0];
            
            statsDict = @{@"winOrLose" : @"Win",
                          @"teammate" : teamMate,
                          @"opponent" : loseTeam,
                          @"gameType" : playerGameArray[i][@"gameType"],
                          @"date" : playerGameArray[i][@"date"]};
            
        }else if ([loseTeam containsObject:self.currentPlayer.objectId]){
            [loseTeam removeObject:self.currentPlayer];
            Player * teamMate = loseTeam[0];
            statsDict = @{@"winOrLose" : @"Lose",
                          @"teammate" : teamMate,
                          @"opponent" : winTeam,
                          @"gameType" : playerGameArray[i][@"gameType"],
                          @"date" : playerGameArray[i][@"date"]};
        }
        [self.currentPlayerStatsArray addObject:statsDict];
    }
    
    [self getSteakWins:self.currentPlayerStatsArray];
    return self.currentPlayerStatsArray;
}

-(void) getSteakWins:(NSMutableArray *) playerStatsArray{
    // Calculate StrakWins
    int streakWins = 0;
    int maxStreakWins = 0;
    int streakLoses = 0;
    int maxStreakLoses = 0;
    
    for (int i = 0 ; i < playerStatsArray.count; i++) {
        
        if ([playerStatsArray[i][@"winOrLose"] isEqualToString:@"Win"]) {
            streakWins ++;
            if (streakLoses > maxStreakLoses) {
                maxStreakLoses = streakLoses;
                streakLoses = 0;
            }
            streakLoses = 0;
        }else if ([playerStatsArray[i][@"winOrLose"] isEqualToString:@"Lose"]){
            streakLoses ++;
            if (streakWins > maxStreakWins) {
                maxStreakWins = streakWins;
                streakWins = 0;
            }
            streakWins = 0;
        }
    }
    
    NSLog(@"Max streakWins: %d", maxStreakWins);
    NSLog(@"current Streak wins: %d", streakWins);
    NSLog(@"Max streakLoses: %d", maxStreakLoses);
    NSLog(@"current Streak Loses: %d", streakLoses);
    
}

-(void) saveGame:(Game *) gameObject{
    
}

@end
