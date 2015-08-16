//
//  PlayListDataSource.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/17.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PlayListDataSource.h"

@implementation PlayListDataSource

+ (PlayListDataSource *)sharedInstance {
    static PlayListDataSource *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSMutableArray *) maleSelectedArray {
    if(!_maleSelectedArray)
        _maleSelectedArray = [@[] mutableCopy];
    return _maleSelectedArray;
}

- (NSMutableArray *) femaleSelectedArray {
    if(!_femaleSelectedArray)
        _femaleSelectedArray = [@[] mutableCopy];
    return _femaleSelectedArray;
}

- (NSMutableArray *) addToMalePlayerList:(NSString *)name{
    [self.maleSelectedArray addObject:name];
    return self.maleSelectedArray;
}

- (NSMutableArray *) addToFemalePlayerList:(NSString *)name{
    [self.femaleSelectedArray addObject:name];
    return self.femaleSelectedArray;
}

- (NSMutableArray *) removeFromMalePlayerList:(NSString *)name{
    [self.maleSelectedArray removeObject:name];
    return self.maleSelectedArray;
}
- (NSMutableArray *) removeFromFemalePlayerList:(NSString *)name{
    [self.femaleSelectedArray removeObject:name];
    return self.femaleSelectedArray;
}

- (NSMutableArray *) sheffleList:(NSMutableArray *)originalArray{
    NSMutableArray * newArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    int n = (int)originalArray.count;
    for (int i = 0;  i < n ; i++) {
        int m = (int)originalArray.count;
        int r = arc4random_uniform(m);
        [newArray addObject:originalArray[r]];
        [originalArray removeObject:originalArray[r]];
        if (i == n-1) {
            [originalArray addObjectsFromArray:newArray];
        }
    }

    return newArray;
}

@end
