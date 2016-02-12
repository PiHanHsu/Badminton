//
//  Player.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/26.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "Player.h"

@implementation Player
@dynamic objectId;
@dynamic userName;
@dynamic name;

@dynamic singleWins;
@dynamic singleLosses;
@dynamic singleWinRate;
@dynamic doubleWins;
@dynamic doubleLosses;
@dynamic doubleWinRate;
@dynamic mixWins;
@dynamic mixLosses;
@dynamic mixWinRate;
@dynamic totalWins;
@dynamic totalLosses;
@dynamic totalWinRate;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
    //return @"Parse";
}

+(Player *) createPlayer {
    Player *playerObject = [Player object];
    return playerObject;
}
@end
