//
//  Player.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Player : NSObject
@property (strong, nonatomic) NSString * firstName;
@property (strong, nonatomic) UIButton * button;
@property (strong, nonatomic) UIImage * photo;
@property BOOL isChosen;
@property UIView *view;

@end
