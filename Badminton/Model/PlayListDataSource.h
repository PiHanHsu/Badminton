//
//  PlayListDataSource.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/17.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "Player.h"

@interface PlayListDataSource : NSObject
@property (strong, nonatomic) NSMutableArray * maleSelectedArray;
@property (strong, nonatomic) NSMutableArray * femaleSelectedArray;
@property (strong, nonatomic) NSMutableArray * malePlayerArray;
@property (strong, nonatomic) NSMutableArray * femalePlayerArray;
@property (strong, nonatomic) NSString * teamName;
@property (strong, nonatomic) NSMutableArray * teamArray;

+ (PlayListDataSource *)sharedInstance;
- (NSMutableArray *) addToMalePlayerList:(Player *)player;
- (NSMutableArray *) addToFemalePlayerList:(Player *)player;
- (NSMutableArray *) removeFromMalePlayerList:(Player *)player;
- (NSMutableArray *) removeFromFemalePlayerList:(Player *)player;
- (NSMutableArray *) sheffleList:(NSMutableArray *)originalArray;

- (NSMutableArray *) addToMalePlayerArray:(Player *)player;
- (NSMutableArray *) addToFemalePlayerArray:(Player *)player;
- (NSMutableArray *) removeFromMalePlayerArray:(Player *)player;
- (NSMutableArray *) removeFromFemalePlayerArray:(Player *)player;
- (NSMutableArray *) addToTeamArray:(NSString *)name;

- (void) loadingTeamDataFromParse;
- (void) updateTeamPlayersToParse;

@end
