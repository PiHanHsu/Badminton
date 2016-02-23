//
//  Player.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/26.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>

@interface Player : PFObject<PFSubclassing>
@property (strong, nonatomic) NSString * objectId;
@property (strong, nonatomic) NSString * userName;
@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSNumber * totalWins;
@property (strong, nonatomic) NSNumber * totalLosses;
@property (strong, nonatomic) NSNumber * totalWinRate;
@property (strong, nonatomic) NSNumber * singleWins;
@property (strong, nonatomic) NSNumber * singleLosses;
@property (strong, nonatomic) NSNumber * singleWinRate;
@property (strong, nonatomic) NSNumber * doubleWins;
@property (strong, nonatomic) NSNumber * doubleLosses;
@property (strong, nonatomic) NSNumber * doubleWinRate;
@property (strong, nonatomic) NSNumber * mixWins;
@property (strong, nonatomic) NSNumber * mixLosses;
@property (strong, nonatomic) NSNumber * mixWinRate;
@property (strong, nonatomic) NSString * pictureUrl;

+(Player *) createPlayer;
@end
