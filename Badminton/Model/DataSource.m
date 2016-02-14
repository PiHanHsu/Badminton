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
@property (nonatomic,strong) NSArray *teamGamesArray;



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

-(NSMutableArray *) selectedPlayersArray{
    if(!_selectedPlayersArray)
        _selectedPlayersArray = [@[] mutableCopy];
    return _selectedPlayersArray;
}

- (void) loadPlayersFromServer{
    
}

- (NSMutableArray *) addPlayerToPlayList:(Player *)player{
    [self.selectedPlayersArray addObject:player];
    return self.selectedPlayersArray;
}

- (NSMutableArray *) sheffleList:(NSMutableArray *)originalArray{
    NSMutableArray * newArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    int n = (int)originalArray.count;
    for (int i = 0;  i < n ; i++) {
        int m = (int)originalArray.count;
        int r = arc4random_uniform(m);
        [newArray addObject:originalArray[r]];
        [originalArray removeObject:originalArray[r]];
        if (i == n-1) {
            [originalArray addObjectsFromArray:newArray];
        }
    }
    
    return newArray;
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
    PFFile * photo = self.currentPlayer[@"photo"];
    if (photo) {
        [photo getDataInBackgroundWithBlock:^(NSData * imageData, NSError * error){
            self.currentPlayerImage = [UIImage imageWithData:imageData];
        }];
    }
    
    PFQuery * query = [PFQuery queryWithClassName:@"Team"];
    [query whereKey:@"players" equalTo:[PFObject objectWithoutDataWithClassName:@"Player" objectId:self.currentPlayer.objectId]];
    [query includeKey:@"players"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * teams, NSError * error){
       
        self.teamArray = [teams mutableCopy];
        for (Team * teamObject in self.teamArray) {
            [teamObject pinInBackground];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadingDataFinished" object:self];
    }];
    
}

-(void) addTeam:(Team *) teamObject{
    [self.teamArray addObject:teamObject];
    
}
-(void) deleteTeam:(Team *) teamObject{
    [self.teamArray removeObject:teamObject];
    [teamObject deleteTeam];
}

- (void) loadGamesFromServerWithPlayer:(NSString *)playerId withTeam:(Team *) teamObject{
    PFQuery * queryWinGames = [PFQuery queryWithClassName:@"Game"];
    [queryWinGames whereKey:@"winTeam" equalTo:playerId];
    [queryWinGames whereKey:@"team" equalTo:teamObject.objectId];
    PFQuery * queryLoseGames = [PFQuery queryWithClassName:@"Game"];
    [queryWinGames whereKey:@"team" equalTo:teamObject.objectId];
    [queryLoseGames whereKey:@"loseTeam" equalTo:playerId];
    
    PFQuery *queryBoth = [PFQuery orQueryWithSubqueries:@[queryWinGames , queryLoseGames]];
    [queryBoth findObjectsInBackgroundWithBlock:^(NSArray *gamesArray, NSError * error){
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        
        self.currentPlayerGamesArray = [gamesArray sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]];
        [self createStatsArray:self.currentPlayerGamesArray player:playerId];
        
    }];
}

- (void) loadGamesFromServer: (NSString *) playerId{

    PFQuery * queryWinGames = [PFQuery queryWithClassName:@"Game"];
    [queryWinGames whereKey:@"winTeam" equalTo:playerId];
    PFQuery * queryLoseGames = [PFQuery queryWithClassName:@"Game"];
    [queryLoseGames whereKey:@"loseTeam" equalTo:playerId];

    PFQuery *queryBoth = [PFQuery orQueryWithSubqueries:@[queryWinGames , queryLoseGames]];
    
    [queryBoth findObjectsInBackgroundWithBlock:^(NSArray *gamesArray, NSError * error){
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
        
        self.currentPlayerGamesArray = [gamesArray sortedArrayUsingDescriptors:[NSArray arrayWithObject: descriptor]];
        [self createStatsArray:self.currentPlayerGamesArray player:playerId];

    }];
    
}

- (NSMutableArray *) createStatsArray:(NSArray *) playerGameArray player: (NSString *) playerId{
    self.currentPlayerStatsArray = [@[] mutableCopy];
    
    NSLog(@"n = %lu", (unsigned long)playerGameArray.count);
    
    for (int i = 0 ; i < playerGameArray.count; i++) {
        NSDictionary * statsDict = [[NSDictionary alloc] init];
        NSMutableArray * winTeam = playerGameArray[i][@"winTeam"];
        NSMutableArray * loseTeam = playerGameArray[i][@"loseTeam"];

        NSString * teamMate = [[NSString alloc]init];
        if ([winTeam containsObject:playerId]) {
            
            if (winTeam.count > 1) {
                [winTeam removeObject:playerId];
                teamMate = winTeam[0];
            }else{
                teamMate = @"";
            }
            statsDict = @{@"winOrLose" : @"Win",
                          @"teammate" : teamMate,
                          @"opponent" : loseTeam,
                          @"gameType" : playerGameArray[i][@"gameType"],
                          @"date" : playerGameArray[i][@"date"]};
            
        }else if ([loseTeam containsObject:playerId]){
            
            if (loseTeam.count > 1) {
                [loseTeam removeObject:playerId];
                teamMate = loseTeam[0];
            }else{
                teamMate = @"";
            }
            NSString * teamMate = loseTeam[0];
            statsDict = @{@"winOrLose" : @"Lose",
                          @"teammate" : teamMate,
                          @"opponent" : winTeam,
                          @"gameType" : playerGameArray[i][@"gameType"],
                          @"date" : playerGameArray[i][@"date"]};
        }
        
        [self.currentPlayerStatsArray addObject:statsDict];
    }
    
    NSLog(@"playerStatsArray: %@", self.currentPlayerStatsArray);
    [self getSteakWins:self.currentPlayerStatsArray];
    [self getBestTeammate:self.currentPlayerStatsArray player:playerId];
    return self.currentPlayerStatsArray;
}

-(void) getBestTeammate:(NSMutableArray *) playerStatsArray player:(NSString *) playerId{
    NSMutableArray * winTeammates = [@[] mutableCopy];
    NSMutableArray * loseTeammates = [@[] mutableCopy];
    NSMutableArray * statsWithDoubleGame = [@[] mutableCopy];
    NSMutableArray * statsWithMixGame = [@[] mutableCopy];

    self.statsWithTeammatesArray = [@[] mutableCopy];
    
    PFQuery * query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"objectId" equalTo:playerId];
    Player * playerForStats = [query getFirstObject];
    
    for (NSDictionary * stats in playerStatsArray) {
        
        if ([stats[@"winOrLose"] isEqualToString:@"Win"]){
            [winTeammates addObject: stats[@"teammate"]];
        }else{
            [loseTeammates addObject: stats[@"teammate"]];
        }
    }
    
    [winTeammates removeObject:@""];
    NSCountedSet * winSet =[[NSCountedSet alloc] initWithArray:winTeammates];
    NSCountedSet * loseSet =[[NSCountedSet alloc] initWithArray:loseTeammates];
    
    
    //TODO, if player has 0 win, s/he will not show in winSet
    for (id item in winSet)
    {
        PFQuery * query = [PFQuery queryWithClassName:@"Player"];
        [query whereKey:@"objectId" equalTo:item];
        Player * player = [query getFirstObject];
        
        NSNumber * wins = [NSNumber numberWithUnsignedLong:[winSet countForObject:item]];
        NSNumber * loses = [NSNumber numberWithUnsignedLong:[loseSet countForObject:item]];
        float rate = wins.floatValue / (wins.floatValue + loses.floatValue) * 100;
        NSNumber * winRate = [NSNumber numberWithFloat:rate];
                
        NSDictionary * statsDict = @{@"player" : player,
                                     @"wins" : wins,
                                     @"loses" : loses,
                                     @"winRate" : winRate};
        
        if ([playerForStats[@"isMale"]boolValue] && [player[@"isMale"] boolValue]){
            [statsWithDoubleGame addObject:statsDict];
        }else if (![playerForStats[@"isMale"]boolValue] && ![player[@"isMale"] boolValue] ){
            [statsWithDoubleGame addObject:statsDict];
        }else{
            [statsWithMixGame addObject:statsDict];
        }
        
    }
    
    self.statsWithTeammatesByDoubleGameArray = [[NSArray alloc]initWithArray:statsWithDoubleGame];
    self.statsWithTeammatesByMixGameArray = [[NSArray alloc]initWithArray:statsWithMixGame];
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"winRate" ascending:NO];
    self.statsWithTeammatesByDoubleGameArray = [self.statsWithTeammatesByDoubleGameArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    self.statsWithTeammatesByMixGameArray = [self.statsWithTeammatesByMixGameArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getBestTeammateFinished" object:self];

    
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
    
    //TODO: sometimes, the number is wrong
    self.currentStreakWins = [NSNumber numberWithInt:streakWins];
    self.maxStreakWins = [NSNumber numberWithInt:maxStreakWins];
    NSLog(@"Max streakWins: %d", maxStreakWins);
    NSLog(@"current Streak wins: %d", streakWins);
    NSLog(@"Max streakLoses: %d", maxStreakLoses);
    NSLog(@"current Streak Loses: %d", streakLoses);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"calculateStreakWinsFinished" object:self];
}




- (void) loadingTeamGames:(NSString *) teamId {
    PFQuery * query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"team" equalTo:teamId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * gamesArray, NSError * error){
        if (!error) {
            self.teamGamesArray = gamesArray;
            for (Game * oneGame in self.teamGamesArray) {
                [oneGame pinInBackground];
            }
        }else{
            NSLog(@"loading games error: %@", error);
        }
    }];
}

- (void) createMixStandingWithmalePlayersArray: (NSMutableArray *)maleplayersArray femalePlayersArray: (NSMutableArray *)femaleplayersArray gameArray: (NSArray *) gameArray{

    //TODO: TBD...
    
    NSMutableArray * mixGameStandingArray = [@[] mutableCopy];
    
    for (Player * malePlayer in maleplayersArray) {
        for (Player * femalePlayer in femaleplayersArray) {
            NSArray * teamMatch = @[malePlayer, femalePlayer];
            NSDictionary * teamMatchListScore = [[NSDictionary alloc]init];
            teamMatchListScore = @{@"team" : teamMatch,
                                   @"wins" : [NSNumber numberWithFloat:0],
                                   @"loses" : [NSNumber numberWithFloat:0],
                                   @"winRate" : [NSNumber numberWithFloat:0]};
            [mixGameStandingArray addObject:teamMatchListScore];
        }
    }


    
}


-(NSMutableArray *) calculateBestTeamMate:(NSMutableArray *) playerStatsArray teamMatesArray:(NSMutableArray *) teamMates{
    NSMutableArray * teamMatesStats = [@[] mutableCopy];
    
    for (int i = 0 ; i < teamMates.count ; i++) {
        int wins = 0;
        int loses = 0;
        for (int j = 0 ; j < playerStatsArray.count; j++) {
            
            if ([playerStatsArray[j][@"teamMate"] isEqualToString:teamMates[i]]) {
                if ([playerStatsArray[j][@"winOrLose"] isEqualToString:@"Win"]) {
                    wins++;
                }else if ([playerStatsArray[j][@"winOrLose"] isEqualToString:@"Lose"]){
                    loses++;
                }
            }
        }
        NSDictionary * teamMatesStanding = [[NSDictionary alloc]init];
        float winRate = wins / loses ;
        
        teamMatesStanding = @{@"teamMate" : @"teamMate",
                              @"wins" : [NSNumber numberWithInt:wins],
                              @"loses" : [NSNumber numberWithInt:wins],
                              @"winRate" : [NSNumber numberWithFloat:winRate]};
        
        [teamMatesStats addObject:teamMatesStanding];
    }
    
    return teamMatesStats;
    
}


-(void) saveGame:(Game *) gameObject{
    
}

@end
