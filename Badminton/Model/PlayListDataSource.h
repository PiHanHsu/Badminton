//
//  PlayListDataSource.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/17.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayListDataSource : NSObject
@property (strong, nonatomic) NSMutableArray * maleSelectedArray;
@property (strong, nonatomic) NSMutableArray * femaleSelectedArray;
+ (PlayListDataSource *)sharedInstance;
- (NSMutableArray *) addToMalePlayerList:(NSString *)name;
- (NSMutableArray *) addToFemalePlayerList:(NSString *)name;
- (NSMutableArray *) removeFromMalePlayerList:(NSString *)name;
- (NSMutableArray *) removeFromFemalePlayerList:(NSString *)name;
- (NSMutableArray *) sheffleList:(NSMutableArray *)originalArray;
@end
