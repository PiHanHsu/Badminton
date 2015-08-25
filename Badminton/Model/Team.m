//
//  Team.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/25.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "Team.h"

@implementation Team

@dynamic objectId;
@dynamic teamName;
@dynamic createdBy;
@dynamic malePlayers;
@dynamic femalePlayers;

+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
    //return @"Parse";
}

+(Team *) createTeam {
    Team *teamObject = [Team object];
    
    
    return teamObject;
}

@end
