//
//  GameMatches.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/5.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "GameMatches.h"
#import <Parse/Parse.h>

@implementation GameMatches
@dynamic matchesArray;


+(void)load {
    [self registerSubclass];
}

+(NSString *)parseClassName {
    return NSStringFromClass([self class]);
    //return @"Parse";
}

- (NSMutableArray *) createMatches: (NSMutableArray *) playersArray {
    
    int n = (int)playersArray.count;
    
    
    if (playersArray.count >4) {
        NSMutableArray * team1 = [@[] mutableCopy];
        NSMutableArray * team2 = [@[] mutableCopy];
        
        int remaining = 4;
        
        while (remaining > 0) {
            Player * player = playersArray[arc4random_uniform(n)];
            
            
                if (![team1 containsObject:player] || ![team2 containsObject:player]) {
                    if (remaining >2) {
                        [team1 addObject:player];
                        remaining--;
                    }else{
                        [team2 addObject:player];
                        remaining--;
                    }
                    
                }
        }
    
        
        for (int i; i < 10000 ; i ++) {
            int r1 = arc4random_uniform(n);
            int r2 = arc4random_uniform(n);
            if (r1 != r2) {
                [team1 addObject:playersArray[r1]];
                [team1 addObject:playersArray[r2]];
            }
            
            
            
            
        }
        
        
        
    }
    
    self.matchesArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    
    return self.matchesArray;
}


@end
