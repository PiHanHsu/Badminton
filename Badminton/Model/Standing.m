//
//  Standing.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/19.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "Standing.h"

@implementation Standing

@dynamic player;
@dynamic team;

@dynamic wins;
@dynamic loses;
@dynamic singleWins;
@dynamic singleLoses;
@dynamic mixWins;
@dynamic mixLoses;
@dynamic doubleWins;
@dynamic doubleLoses;

@dynamic bestMaleMatePlayer;
@dynamic bestFemaleMatePlayer;

@dynamic longestWins;
@dynamic longestLoses;


+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
    //return @"Parse";
}

+(Standing *) createPlayerStanding {
    Standing * standingObject = [Standing object];
    return standingObject;
}

@end
