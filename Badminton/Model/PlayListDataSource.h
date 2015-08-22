//
//  PlayListDataSource.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/17.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PlayListDataSource : NSObject
@property (strong, nonatomic) NSMutableArray * maleSelectedArray;
@property (strong, nonatomic) NSMutableArray * femaleSelectedArray;
@property (strong, nonatomic) NSMutableArray * malePlayerArray;
@property (strong, nonatomic) NSMutableArray * femalePlayerArray;
@property (strong, nonatomic) NSString * teamName;
@property (strong, nonatomic) NSMutableArray * teamArray;

+ (PlayListDataSource *)sharedInstance;
- (NSMutableArray *) addToMalePlayerList:(NSString *)name;
- (NSMutableArray *) addToFemalePlayerList:(NSString *)name;
- (NSMutableArray *) removeFromMalePlayerList:(NSString *)name;
- (NSMutableArray *) removeFromFemalePlayerList:(NSString *)name;
- (NSMutableArray *) sheffleList:(NSMutableArray *)originalArray;

- (NSMutableArray *) addToMalePlayerArray:(NSString *)name;
- (NSMutableArray *) addToFemalePlayerArray:(NSString *)name;
- (NSMutableArray *) removeFromMalePlayerArray:(NSString *)name;
- (NSMutableArray *) removeFromFemalePlayerArray:(NSString *)name;
- (NSMutableArray *) addToTeamArray:(NSString *)name;

- (void) updateTeamPlayersToParse;

@end
