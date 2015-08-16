//
//  PlayList.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PlayList.h"

@implementation PlayList

+ (PlayList *)sharedInstance{
    static PlayList *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PlayList alloc] init];
    });
    return sharedInstance;
}

//Lazy init

- (NSMutableArray *) scheduledListArray {
    if(!_scheduledListArray)
        _scheduledListArray = [@[] mutableCopy];
    return _scheduledListArray;
}

- (NSMutableArray *) gameListArray {
    if(!_gameListArray)
        _gameListArray = [@[] mutableCopy];
    return _gameListArray;
}

- (NSMutableArray *) femaleListArray {
    if(!_femaleListArray)
        _femaleListArray = [@[] mutableCopy];
    return _femaleListArray;
}

- (NSMutableArray *) maleListArray {
    if(!_maleListArray)
        _maleListArray = [@[] mutableCopy];
    return _maleListArray;
}

#pragma mark methods

- (NSMutableArray *)addPlayerToMaleList:(NSObject *)player{
 
    [self.maleListArray addObject:player];
    return self.maleListArray;
}

- (NSMutableArray *)addPlayerToFemaleList:(NSObject *)player{
    
    [self.femaleListArray addObject:player];
    return self.femaleListArray;
}

@end
