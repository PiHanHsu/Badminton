//
//  PlayList.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface PlayList : NSObject
@property (strong, nonatomic) NSMutableArray * scheduledListArray;// array of all games
@property (strong, nonatomic) NSMutableArray * gameListArray; // array of each game players
@property (strong, nonatomic) NSMutableArray * maleListArray;// array of male players

@property (strong, nonatomic) NSMutableArray * femaleListArray; // array of female players
@property (strong, nonatomic) NSNumber * combinationType;
@property (strong, nonatomic) NSObject * player;
+ (PlayList *)sharedInstance;

- (NSMutableArray *)addPlayerToMaleList:(NSObject *)player;
- (NSMutableArray *)addPlayerToFemaleList:(NSObject *)player;
@end

