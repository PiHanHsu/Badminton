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


+ (DataSource *)sharedInstance ;

- (void) loadTeamsFromServer;
- (void) loadPlayersFromServer;
- (void) loadGamesFromServer;

-(void) addTeam:(Team *) teamObject;
-(void) deleteTeam:(Team *) teamObject;

-(void) addPlayer:(Player *) playerObject toTeam: (Team *) teamObject;
-(void) deletePlayer:(Player *) playerObject fromTeam:(Team *)teamObject;

-(void) saveGame:(Game *) gameObject;


@end
