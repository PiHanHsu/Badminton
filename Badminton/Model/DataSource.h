//
//  DataSource.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/4.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Team.h"
#import "Player.h"
#import "Game.h"

@interface DataSource : NSObject

@property (nonatomic,strong) PFUser *userObject;
@property (nonatomic,strong) NSMutableArray *teamArray;
@property (nonatomic,strong, readonly) NSMutableArray *playerArray;
@property (nonatomic,strong, readonly) NSMutableArray *gameArray;
@property (nonatomic, strong) NSArray * currentPlayerGamesArray;
@property (nonatomic, strong) NSMutableArray * currentPlayerStatsArray;
@property (nonatomic, strong) NSNumber * currentStreakWins;
@property (nonatomic, strong) NSNumber * maxStreakWins;
@property (nonatomic, strong) NSMutableArray *selectedPlayersArray;
@property (nonatomic, strong) NSMutableArray *statsWithTeammatesArray;
@property (nonatomic, strong) NSArray *statsWithTeammatesByDoubleGameArray;
@property (nonatomic, strong) NSArray *statsWithTeammatesByMixGameArray;
@property (strong, nonatomic) PFObject * currentPlayer;
@property (strong, nonatomic) UIImage * currentPlayerImage;



+ (DataSource *)sharedInstance ;

- (void) loadTeamsFromServer;
- (void) loadPlayersFromServer;
- (void) loadGamesFromServer: (NSString *) playerId;

-(void) addTeam:(Team *) teamObject;
-(void) deleteTeam:(Team *) teamObject;

-(void) addPlayer:(Player *) playerObject toTeam: (Team *) teamObject;
-(void) deletePlayer:(Player *) playerObject fromTeam:(Team *)teamObject;
- (NSMutableArray *) addPlayerToPlayList:(Player *)player;

- (NSMutableArray *) createStatsArray:(NSArray *) playerGameArray;
- (NSMutableArray *) sheffleList:(NSMutableArray *)originalArray;

-(void) saveGame:(Game *) gameObject;


@end
