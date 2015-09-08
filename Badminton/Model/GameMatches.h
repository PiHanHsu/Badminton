//
//  GameMatches.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/5.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import "Team.h"
#import "Game.h"
#import "Player.h"


@interface GameMatches : PFObject<PFSubclassing>

@property (strong, nonatomic) NSMutableArray * matchesArray; //of all matches

- (NSMutableArray *) createMatches: (NSMutableArray *) playersArray;


@end
