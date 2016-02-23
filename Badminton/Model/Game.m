//
//  Game.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/25.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "Game.h"
#import "Player.h"
@interface Game()


@end

@implementation Game

@dynamic gameScheduleArray; // array of Games

@dynamic team1Array; // of team1 players
@dynamic team2Array; // of team2 players
@dynamic winTeamArray; // of win team players
@dynamic loseTeamArray; // of win team players

@dynamic winScore;
@dynamic loseScore;
@dynamic winTieBreakScore;
@dynamic loseTieBreakScore;

@dynamic gameType;
@dynamic place;

@dynamic gameDate;
@dynamic team1Score;
@dynamic team2Score;
@dynamic team1TieBreakScore;
@dynamic team2TieBreakScore;
@dynamic sportsType;
@dynamic isFinished;

@dynamic playerArray;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
    //return @"Parse";
}

- (NSMutableArray *) createSinglePlayerGames: (NSMutableArray *)malePlayerArray femalePlayer:(NSMutableArray *) femalePlayerArray{
    
    self.gameScheduleArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.team1Array = [[NSMutableArray alloc]initWithCapacity:0];
    self.team2Array = [[NSMutableArray alloc]initWithCapacity:0];
    self.team1Score = @"";
    self.team2Score = @"";
    self.team1TieBreakScore = @"";
    self.team2TieBreakScore = @"";
    self.isFinished = [NSNumber numberWithBool:NO];
    
    self.playerArray = [[NSMutableArray alloc]initWithArray:malePlayerArray];
    [self.playerArray addObjectsFromArray:femalePlayerArray];
    
    if ((malePlayerArray.count + femalePlayerArray.count) == 2 ) {
        self.team1Array[0] = [NSMutableArray arrayWithObjects:self.playerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:
                              self.playerArray[1], nil];
        self.gameScheduleArray[0] = [NSMutableArray arrayWithObjects:self.team1Array[0],self.team2Array[0],self.team1Score, self.team2Score,self.isFinished,self.team1TieBreakScore, self.team2TieBreakScore, nil];
    }else if ((malePlayerArray.count + femalePlayerArray.count) == 3 ){
        self.team1Array[0] = [NSMutableArray arrayWithObject:self.playerArray[0]];
        self.team2Array[0] = [NSMutableArray arrayWithObject:self.playerArray[1]];
        self.team1Array[1] = [NSMutableArray arrayWithObject:self.playerArray[1]];
        self.team2Array[1] = [NSMutableArray arrayWithObject:self.playerArray[2]];
        self.team1Array[2] = [NSMutableArray arrayWithObject:self.playerArray[2]];
        self.team2Array[2] = [NSMutableArray arrayWithObject:self.playerArray[0]];
        
        for (int i = 0 ; i < 3 ; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }
    }
    
    
    return self.gameScheduleArray;
}

- (NSMutableArray *) createGameScheduleWithMalePlayers:(NSMutableArray *) malePlayerArray femalePlayer:(NSMutableArray *) femalePlayerArray{
    
    if (femalePlayerArray.count > malePlayerArray.count){
        NSMutableArray * tempArray = [femalePlayerArray mutableCopy];
        [femalePlayerArray removeAllObjects];
        femalePlayerArray = [malePlayerArray mutableCopy];
        [malePlayerArray removeAllObjects];
        malePlayerArray = [tempArray mutableCopy];
    }
    
    self.gameScheduleArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.team1Array = [[NSMutableArray alloc]initWithCapacity:0];
    self.team2Array = [[NSMutableArray alloc]initWithCapacity:0];
    self.team1Score =@"";
    self.team2Score =@"";
    self.team1TieBreakScore = @"";
    self.team2TieBreakScore = @"";
    self.isFinished = [NSNumber numberWithBool:NO];
    
    self.playerArray = [[NSMutableArray alloc]initWithArray:malePlayerArray];
    [self.playerArray addObjectsFromArray:femalePlayerArray];
    
    if (malePlayerArray.count == 5 && femalePlayerArray.count ==3) {
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[2], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[1], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[4],femalePlayerArray[0], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[2], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[1],malePlayerArray[2], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[3],malePlayerArray[4], nil];
        
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[1], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[2], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[4],femalePlayerArray[1], nil];
        
        self.team1Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        self.team2Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[2], nil];
        
        self.team1Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[3], nil];
        self.team2Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[4], nil];
        
        for (int i = 0 ; i <8; i++) {
             self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }
    }else if (malePlayerArray.count == 4 && femalePlayerArray.count ==3){
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[2], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[1], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[2], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[1], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[3], nil];
        
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[1], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[0], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[2], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        self.team1Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        self.team2Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[2], nil];
        
        self.team1Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[3], nil];
        self.team2Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[1], nil];
        
        for (int i = 0 ; i <8; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }
    }else if (malePlayerArray.count == 5 && femalePlayerArray.count ==2){
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[1],malePlayerArray[2], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[3],malePlayerArray[4], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[0], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[1], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[1], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[4], nil];
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[1], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[3], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[1],malePlayerArray[4], nil];
        
        self.team1Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        self.team2Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[4],femalePlayerArray[1], nil];
        
        for (int i = 0 ; i <7; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }
    }else if (malePlayerArray.count == 6 && femalePlayerArray.count ==2){
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[3], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[4],malePlayerArray[5], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[4], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[1],malePlayerArray[5], nil];
        
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[4],femalePlayerArray[0], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[5],femalePlayerArray[1], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[2], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[1],malePlayerArray[3], nil];
        
        for (int i = 0 ; i < 6; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }

    }else if (malePlayerArray.count == 4 && femalePlayerArray.count ==4){
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[2], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[3], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[2], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[3], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[1], nil];
        
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[3], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[0], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[2], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        for (int i = 0 ; i <6; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }
    }else if (malePlayerArray.count == 4 && femalePlayerArray.count ==2){
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[1], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[1], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[3], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[1], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[0], nil];
        
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[3], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[1],malePlayerArray[2], nil];
        
        for (int i = 0 ; i <6; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }
    }else if (malePlayerArray.count == 3 && femalePlayerArray.count ==3){
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[2], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[2], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[1], nil];
        
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[2], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[2], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        
        for (int i = 0 ; i <6; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }

    }else if (malePlayerArray.count == 3 && femalePlayerArray.count ==2){
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[1], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[1], nil];
        
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[0], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[2], nil];
        
        self.team1Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        self.team2Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[1], nil];
        
        self.team1Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[0], nil];
        self.team2Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[1], nil];
        
        self.team1Array[8] = [NSMutableArray arrayWithObjects:malePlayerArray[1], nil];
        self.team2Array[8] = [NSMutableArray arrayWithObjects:malePlayerArray[2], nil];
        
        for (int i = 0 ; i < 9 ; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }

    }else{
       
        NSArray * array = [self.playerArray mutableCopy];
        for (int i = 0 ; i < array.count ; i ++) {
            self.gameScheduleArray = [self randomCreateBymalePlayers: malePlayerArray  femaleplayers:femalePlayerArray gameIndex:i];
        }
    }

    return self.gameScheduleArray;
    
}

- (NSMutableArray *) randomCreateByPlayers: (NSMutableArray *) playersArray{
    
    switch (playersArray.count) {
        case 4:{
            self.team1Array[0] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[1], nil];
            self.team2Array[0] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[3], nil];
            self.team1Array[1] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[2], nil];
            self.team2Array[1] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[3], nil];
            self.team1Array[2] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[3], nil];
            self.team2Array[2] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[2], nil];
        break;
        }
        case 5:{
            self.team1Array[0] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[1], nil];
            self.team2Array[0] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[3], nil];
            self.team1Array[1] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[2], nil];
            self.team2Array[1] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[4], nil];
            self.team1Array[2] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[3], nil];
            self.team2Array[2] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[4], nil];
            self.team1Array[3] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[4], nil];
            self.team2Array[3] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[3], nil];
            self.team1Array[4] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[2], nil];
            self.team2Array[4] = [NSMutableArray arrayWithObjects:playersArray[3],playersArray[4], nil];
        break;
        }
        case 6:{
            self.team1Array[0] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[1], nil];
            self.team2Array[0] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[3], nil];
            self.team1Array[1] = [NSMutableArray arrayWithObjects:playersArray[4],playersArray[0], nil];
            self.team2Array[1] = [NSMutableArray arrayWithObjects:playersArray[5],playersArray[1], nil];
            self.team1Array[2] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[4], nil];
            self.team2Array[2] = [NSMutableArray arrayWithObjects:playersArray[3],playersArray[5], nil];
            self.team1Array[3] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[2], nil];
            self.team2Array[3] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[3], nil];
            self.team1Array[4] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[5], nil];
            self.team2Array[4] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[4], nil];
            self.team1Array[5] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[5], nil];
            self.team2Array[5] = [NSMutableArray arrayWithObjects:playersArray[3],playersArray[4], nil];
            break;
        }
        case 7:{
            self.team1Array[0] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[1], nil];
            self.team2Array[0] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[3], nil];
            self.team1Array[1] = [NSMutableArray arrayWithObjects:playersArray[4],playersArray[5], nil];
            self.team2Array[1] = [NSMutableArray arrayWithObjects:playersArray[6],playersArray[0], nil];
            self.team1Array[2] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[2], nil];
            self.team2Array[2] = [NSMutableArray arrayWithObjects:playersArray[3],playersArray[4], nil];
            self.team1Array[3] = [NSMutableArray arrayWithObjects:playersArray[5],playersArray[0], nil];
            self.team2Array[3] = [NSMutableArray arrayWithObjects:playersArray[6],playersArray[1], nil];
            self.team1Array[4] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[4], nil];
            self.team2Array[4] = [NSMutableArray arrayWithObjects:playersArray[3],playersArray[5], nil];
            self.team1Array[5] = [NSMutableArray arrayWithObjects:playersArray[6],playersArray[2], nil];
            self.team2Array[5] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[0], nil];
            self.team1Array[6] = [NSMutableArray arrayWithObjects:playersArray[3],playersArray[4], nil];
            self.team2Array[6] = [NSMutableArray arrayWithObjects:playersArray[5],playersArray[6], nil];
            break;
        }
        case 8:{
            self.team1Array[0] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[1], nil];
            self.team2Array[0] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[3], nil];
            self.team1Array[1] = [NSMutableArray arrayWithObjects:playersArray[4],playersArray[5], nil];
            self.team2Array[1] = [NSMutableArray arrayWithObjects:playersArray[6],playersArray[7], nil];
            self.team1Array[2] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[6], nil];
            self.team2Array[2] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[7], nil];
            self.team1Array[3] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[4], nil];
            self.team2Array[3] = [NSMutableArray arrayWithObjects:playersArray[3],playersArray[5], nil];
            self.team1Array[4] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[4], nil];
            self.team2Array[4] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[5], nil];
            self.team1Array[5] = [NSMutableArray arrayWithObjects:playersArray[2],playersArray[6], nil];
            self.team2Array[5] = [NSMutableArray arrayWithObjects:playersArray[3],playersArray[7], nil];
            self.team1Array[6] = [NSMutableArray arrayWithObjects:playersArray[0],playersArray[2], nil];
            self.team2Array[6] = [NSMutableArray arrayWithObjects:playersArray[4],playersArray[6], nil];
            self.team1Array[7] = [NSMutableArray arrayWithObjects:playersArray[1],playersArray[3], nil];
            self.team2Array[7] = [NSMutableArray arrayWithObjects:playersArray[5],playersArray[7], nil];

            break;
        }
        default:
            break;
    }
    
    if (playersArray.count == 4) {
        for (int i = 0 ; i < 3 ; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }
    }else{
        for (int i = 0 ; i < playersArray.count ; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
        }
    }
    
    return self.gameScheduleArray;
}

- (NSMutableArray *) randomCreateBymalePlayers:(NSMutableArray *) malePlayerArray  femaleplayers:(NSMutableArray *) femalePlayerArray gameIndex: (int)i {
    
    //TODO: BUG, same player in one Game
    
    int remaining = 4;
    NSMutableArray * oneMatch = [@[] mutableCopy];
    
    while (remaining > 0) {
        
        int n = (int)self.playerArray.count;
        NSMutableArray * team = [@[] mutableCopy];
       
        Player * player1 = self.playerArray[arc4random_uniform(n)];
        Player * player2 = self.playerArray[arc4random_uniform(n)];
        
        int loop = 0;
        loop ++;
        
        if (player1 != player2) {
            team = [NSMutableArray arrayWithObjects:player1,player2, nil];
           
            if (![self.gameScheduleArray containsObject:team]) {
                [oneMatch addObject:team];
                [self.playerArray removeObject:player1];
                [self.playerArray removeObject:player2];
                if (self.playerArray.count <=1) {
                    [self.playerArray addObjectsFromArray:malePlayerArray];
                    [self.playerArray addObjectsFromArray:femalePlayerArray];
                }
            }
            if (oneMatch.count ==2) {
                self.team1Array[i] = oneMatch[0];
                self.team2Array[i] = oneMatch[1];
                remaining = 0;
                NSLog(@"loop: %d", loop);
            }
        }
    }
   
    //NSMutableArray * randomArray = [@[] mutableCopy];
    self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, self.team1TieBreakScore, self.team2TieBreakScore, nil];
    return self.gameScheduleArray;
}

@end
