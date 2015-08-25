//
//  Game.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/25.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "Game.h"

@implementation Game
+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
    //return @"Parse";
}
@end
