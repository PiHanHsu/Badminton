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
