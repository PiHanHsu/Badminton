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

- (NSMutableArray *) addToMalePlayerList:(Player *)player{
    [self.maleSelectedArray addObject:player];
    return self.maleSelectedArray;
}

- (NSMutableArray *) addToFemalePlayerList:(Player *)player{
    [self.femaleSelectedArray addObject:player];
    return self.femaleSelectedArray;
}

- (NSMutableArray *) removeFromMalePlayerList:(Player *)player{
    [self.maleSelectedArray removeObject:player];
    return self.maleSelectedArray;
}
- (NSMutableArray *) removeFromFemalePlayerList:(Player *)player{
    [self.femaleSelectedArray removeObject:player];
    return self.femaleSelectedArray;
}

//- (NSMutableArray *) addToMalePlayerArray:(Player *)player{
//    [self.malePlayerArray addObject:player];
//    return self.malePlayerArray;
//}
//
//- (NSMutableArray *) addToFemalePlayerArray:(Player *)player{
//    [self.femalePlayerArray addObject:player];
//    return self.femalePlayerArray;
//}
//
//- (NSMutableArray *) removeFromMalePlayerArray:(Player *)player{
//    [self.malePlayerArray removeObject:player];
//    return self.malePlayerArray;
//}
//- (NSMutableArray *) removeFromFemalePlayerArray:(Player *)player{
//    [self.femalePlayerArray removeObject:player];
//    return self.femalePlayerArray;
//}

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

- (void) loadingTeamDataFromParse{
    
    PFUser * user = [PFUser currentUser];
    PFQuery * getUserId = [PFQuery queryWithClassName:@"Player"];
    [getUserId whereKey:@"user" equalTo:user.objectId];
    NSLog(@"userId:%@", user.objectId);
    
    PFObject * currentPlayer = [getUserId getFirstObject];
    
    PFQuery * queryForCreatedBy = [PFQuery queryWithClassName:@"Team"];
    [queryForCreatedBy whereKey:@"createBy" equalTo:user.objectId];
    
    PFQuery * queryforMale = [PFQuery queryWithClassName:@"Team"];
    
    [queryforMale whereKey:@"malePlayers" equalTo:[PFObject objectWithoutDataWithClassName:@"Player" objectId:currentPlayer.objectId]];
    
    PFQuery * queryforFemale = [PFQuery queryWithClassName:@"Team"];
    [queryforFemale whereKey:@"femalePlayers" equalTo:[PFObject objectWithoutDataWithClassName:@"Player" objectId:currentPlayer.objectId]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryForCreatedBy,queryforMale,queryforFemale]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * teams, NSError * error){
            [self.teamArray removeAllObjects];
            [self.teamArray addObjectsFromArray:teams];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadingDataFinished" object:self];
            
    }];
}



@end
