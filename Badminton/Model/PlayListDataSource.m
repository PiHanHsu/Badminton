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

- (NSMutableArray *) malePlayerArray {
    if(!_malePlayerArray)
        _malePlayerArray = [@[] mutableCopy];
    return _malePlayerArray;
}

- (NSMutableArray *) femalePlayerArray {
    if(!_femalePlayerArray)
        _femalePlayerArray = [@[] mutableCopy];
    return _femalePlayerArray;
}

- (NSMutableArray *) teamArray {
    if(!_teamArray)
        _teamArray = [@[] mutableCopy];
    return _teamArray;
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

- (NSMutableArray *) addToMalePlayerArray:(NSString *)name{
    [self.malePlayerArray addObject:name];
    return self.malePlayerArray;
}

- (NSMutableArray *) addToFemalePlayerArray:(NSString *)name{
    [self.femalePlayerArray addObject:name];
    return self.femalePlayerArray;
}

- (NSMutableArray *) removeFromMalePlayerArray:(NSString *)name{
    [self.malePlayerArray removeObject:name];
    return self.malePlayerArray;
}
- (NSMutableArray *) removeFromFemalePlayerArray:(NSString *)name{
    [self.femalePlayerArray removeObject:name];
    return self.femalePlayerArray;
}

- (NSMutableArray *) addToTeamArray:(NSString *)name{
    [self.teamArray addObject:name];
    return self.teamArray;
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

- (void) updateTeamPlayersToParse{
    
    PFQuery * query = [PFQuery queryWithClassName:@"Team"];
    NSLog(@"name: %@", self.teamName);
    [query whereKey:@"name" equalTo:self.teamName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error){
        obj[@"malePlayers"] = self.malePlayerArray;
        obj[@"femalePlayers"] = self.femalePlayerArray;
        
        [obj saveInBackgroundWithBlock:^(BOOL succeed, NSError * error){
            if (!error) {
                NSLog(@"add in to list");
            }
        }];
        
    }];
    
    
    
}

@end
