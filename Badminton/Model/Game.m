//
//  Game.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/25.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "Game.h"

@implementation Game

@dynamic gameScheduleArray; // array of Games

@dynamic team1Array; // of team1 players
@dynamic team2Array; // of team2 players
@dynamic winTeamArray; // of win team players
@dynamic loseTeamArray; // of win team players

@dynamic winScore;
@dynamic loseScore;

@dynamic gameType;
@dynamic place;

@dynamic gameDate;
@dynamic team1Score;
@dynamic team2Score;
@dynamic isFinished;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
    //return @"Parse";
}

- (NSMutableArray *) createGameScheduleWithMalePlayers:(NSMutableArray *) malePlayerArray femalePlayer:(NSMutableArray *) femalePlayerArray{
    self.gameScheduleArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.team1Array = [[NSMutableArray alloc]initWithCapacity:0];
    self.team2Array = [[NSMutableArray alloc]initWithCapacity:0];
    self.team1Score =@"";
    self.team2Score =@"";
    self.isFinished = [NSNumber numberWithBool:NO];
    
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
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[2], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[4],femalePlayerArray[1], nil];
        
        self.team1Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[2], nil];
        
        self.team1Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[3], nil];
        self.team2Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[4], nil];
        
        for (int i = 0 ; i <8; i++) {
             self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, nil];
        }
    }else if (malePlayerArray.count == 4 && femalePlayerArray.count ==3){
        self.team1Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[0] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[1], nil];
        
        self.team1Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[2], nil];
        self.team2Array[1] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[1], nil];
        
        self.team1Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[2] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[2], nil];
        
        self.team1Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[1], nil];
        self.team2Array[3] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[3], nil];
        
        self.team1Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[0],femalePlayerArray[0], nil];
        self.team2Array[4] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[1], nil];
        
        self.team1Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[2], nil];
        self.team2Array[5] = [NSMutableArray arrayWithObjects:malePlayerArray[2],femalePlayerArray[1], nil];
        
        self.team1Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[1],femalePlayerArray[0], nil];
        self.team2Array[6] = [NSMutableArray arrayWithObjects:malePlayerArray[3],femalePlayerArray[2], nil];
        
        self.team1Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[0],malePlayerArray[3], nil];
        self.team2Array[7] = [NSMutableArray arrayWithObjects:malePlayerArray[2],malePlayerArray[1], nil];
        
        for (int i = 0 ; i <8; i++) {
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, nil];
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
            self.gameScheduleArray[i] = [NSMutableArray arrayWithObjects:self.team1Array[i],self.team2Array[i],self.team1Score, self.team2Score,self.isFinished, nil];
        }

      
    }
    
    return self.gameScheduleArray;
    
}
@end
