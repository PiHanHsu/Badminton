//
//  Standing.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/19.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PFObject.h"
#import "Player.h"
#import "Team.h"

@interface Standing : PFObject <PFSubclassing>

@property (strong, nonatomic) Player * player;
@property (strong, nonatomic) Team * team;


@property (strong, nonatomic) NSNumber * wins;
@property (strong, nonatomic) NSNumber * loses;
@property (strong, nonatomic) NSNumber * singleWins;
@property (strong, nonatomic) NSNumber * singleLoses;
@property (strong, nonatomic) NSNumber * mixWins;
@property (strong, nonatomic) NSNumber * mixLoses;
@property (strong, nonatomic) NSNumber * doubleWins;
@property (strong, nonatomic) NSNumber * doubleLoses;

@property (strong, nonatomic) Player * bestMaleMatePlayer;
@property (strong, nonatomic) Player * bestFemaleMatePlayer;

@property (strong, nonatomic) NSNumber * longestWins;
@property (strong, nonatomic) NSString * longestLoses;

+(Standing *) createPlayerStanding;

@end
