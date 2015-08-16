//
//  ViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/7/31.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    NSMutableArray * mulArray1 = [[NSMutableArray alloc]initWithObjects:@"CEJ", @"Eric", @"Ryan", @"PiHan", @"YiTing", nil];
    int n = (int)mulArray1.count;
    NSMutableArray * mulArray2 = [[NSMutableArray alloc]initWithCapacity:n];
   
        for (int i = 0;  i < n ; i++) {
            int m = (int)mulArray1.count;
            //NSLog(@"m = %i", m);
            int r = arc4random_uniform(m);
            [mulArray2 addObject:mulArray1[r]];
            [mulArray1 removeObject:mulArray1[r]];
        }
        NSLog(@"list: %@", mulArray2);
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
