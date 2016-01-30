//
//  Game.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/25.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PFObject.h"
#import <Parse.h>

typedef enum {
    F3M5  = 0, // the general and initial orientation
    F3M4, // rotate 90 degree
    F2M5,
    F2M6,
    F4M4,
    F2M4,
    F3M3,
    OTHER
}PLAYER_COMBINATION;


@interface Game : PFObject<PFSubclassing>

@property (strong, nonatomic) NSMutableArray * gameScheduleArray; // array of Games

@property (strong, nonatomic) NSMutableArray * team1Array; // of team1 players
@property (strong, nonatomic) NSMutableArray * team2Array; // of team2 players
@property (strong, nonatomic) NSArray * winTeamArray; // of win team players
@property (strong, nonatomic) NSArray * loseTeamArray; // of win team players

@property (strong, nonatomic) NSNumber * winScore;
@property (strong, nonatomic) NSNumber * loseScore;
@property (strong, nonatomic) NSNumber * winTieBreakScore;
@property (strong, nonatomic) NSNumber * loseTieBreakScore;

@property (strong, nonatomic) NSString * gameType;
@property (strong, nonatomic) NSString * place;

@property (strong, nonatomic) NSDate * gameDate;

@property (strong, nonatomic) NSString * team1Score;
@property (strong, nonatomic) NSString * team2Score;
@property (strong, nonatomic) NSString * team1TieBreakScore;
@property (strong, nonatomic) NSString * team2TieBreakScore;
@property (strong, nonatomic) NSString * sportsType;

@property (strong, nonatomic) NSNumber * isFinished;

@property (strong, nonatomic) NSMutableArray * playerArray;

- (NSMutableArray *) createGameScheduleWithMalePlayers:(NSMutableArray *) malePlayerArray femalePlayer:(NSMutableArray *) femalePlayerArray;
- (NSMutableArray *) createSinglePlayerGames: (NSMutableArray *)malePlayerArray femalePlayer:(NSMutableArray *) femalePlayerArray;

@end
