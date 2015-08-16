//
//  player.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/15.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface player : NSObject
@property (strong, nonatomic) NSString * firstName;
@property (strong, nonatomic) NSString * lastName;
@property (strong, nonatomic) UIButton * playerButton;
@property (strong, nonatomic) UIImage * photo;

@end

