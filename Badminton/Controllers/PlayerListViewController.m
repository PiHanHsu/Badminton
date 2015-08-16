//
//  PlayerListViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/15.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PlayerListViewController.h"
#import "PlayerButton.h"
#import "GameScheduleTableViewController.h"

@interface PlayerListViewController ()
@property (strong, nonatomic) NSMutableArray * malePlaylistArray;
@property (strong, nonatomic) NSMutableArray * malePlaylistArrayNew;
@property (strong, nonatomic) NSMutableArray * femalePlaylistArray;
@property (strong, nonatomic) NSMutableArray * femalePlaylistArrayNew;
@property (weak, nonatomic) IBOutlet PlayerButton *ericButton;
@property (weak, nonatomic) IBOutlet PlayerButton *ryanButton;
@property (weak, nonatomic) IBOutlet PlayerButton *YitingButton;
@property (weak, nonatomic) IBOutlet PlayerButton *cejButton;
@property (weak, nonatomic) IBOutlet PlayerButton *pihanButton;
@property (weak, nonatomic) IBOutlet PlayerButton *karenButton;
@property (weak, nonatomic) IBOutlet PlayerButton *gloryButton;
@property (weak, nonatomic) IBOutlet PlayerButton *jenniferButton;

@end

@implementation PlayerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.ericButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.ryanButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.YitingButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cejButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.pihanButton addTarget:self action:@selector(toggleButton:) forControlEvents:UIControlEventTouchUpInside];
     [self.karenButton addTarget:self action:@selector(toggleButton2:) forControlEvents:UIControlEventTouchUpInside];
     [self.gloryButton addTarget:self action:@selector(toggleButton2:) forControlEvents:UIControlEventTouchUpInside];
     [self.jenniferButton addTarget:self action:@selector(toggleButton2:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (IBAction)selectAllPressed:(id)sender {
    [self.malePlaylistArray removeAllObjects];
    [self.femalePlaylistArray removeAllObjects];
    
    [self.ericButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.ericButton.buttonToggled = YES;
    [self.malePlaylistArray addObject:self.ericButton.titleLabel.text];
    [self.ryanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.ryanButton.buttonToggled = YES;
    [self.malePlaylistArray addObject:self.ryanButton.titleLabel.text];
    [self.YitingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.YitingButton.buttonToggled = YES;
    [self.malePlaylistArray addObject:self.YitingButton.titleLabel.text];
    [self.cejButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.cejButton.buttonToggled = YES;
    [self.malePlaylistArray addObject:self.cejButton.titleLabel.text];
    [self.pihanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.pihanButton.buttonToggled = YES;
    [self.malePlaylistArray addObject:self.pihanButton.titleLabel.text];
    [self.karenButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.karenButton.buttonToggled = YES;
    [self.femalePlaylistArray addObject:self.karenButton.titleLabel.text];
    [self.gloryButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.gloryButton.buttonToggled = YES;
    [self.femalePlaylistArray addObject:self.gloryButton.titleLabel.text];
    [self.jenniferButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.jenniferButton.buttonToggled = YES;
    [self.femalePlaylistArray addObject:self.jenniferButton.titleLabel.text];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *) malePlaylistArray {
    if(!_malePlaylistArray)
        _malePlaylistArray = [@[] mutableCopy];
    return _malePlaylistArray;
}

- (NSMutableArray *) malePlaylistArrayNew {
    if(!_malePlaylistArrayNew)
        _malePlaylistArrayNew = [@[] mutableCopy];
    return _malePlaylistArrayNew;
}

- (NSMutableArray *) femalePlaylistArray {
    if(!_femalePlaylistArray)
        _femalePlaylistArray = [@[] mutableCopy];
    return _femalePlaylistArray;
}

- (NSMutableArray *) femalePlaylistArrayNew {
    if(!_femalePlaylistArrayNew)
        _femalePlaylistArrayNew = [@[] mutableCopy];
    return _femalePlaylistArrayNew;
}

-(IBAction)toggleButton:(id)sender {
    PlayerButton * btn = (PlayerButton *) sender;
    
    if (!btn.buttonToggled) {
        //[sender setTitle:@"Unlike" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        NSString * player = btn.titleLabel.text;
        [self.malePlaylistArray addObject:player];
        btn.buttonToggled = YES;
        //NSLog(@"list:%@" , self.malePlaylistArray);
    }
    else {
        //[sender setTitle:@"Like" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        NSString * player = btn.titleLabel.text;
        [self.malePlaylistArray removeObject:player];
        btn.buttonToggled = NO;
        //NSLog(@"list:%@" , self.malePlaylistArray);
    }
}

-(IBAction)toggleButton2:(id)sender {
    PlayerButton * btn = (PlayerButton *) sender;
    
    if (!btn.buttonToggled) {
        //[sender setTitle:@"Unlike" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        NSString * player = btn.titleLabel.text;
        [self.femalePlaylistArray addObject:player];
        btn.buttonToggled = YES;
        //NSLog(@"Female list:%@" , self.femalePlaylistArray);
    }
    else {
        //[sender setTitle:@"Like" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        NSString * player = btn.titleLabel.text;
        [self.femalePlaylistArray removeObject:player];
        btn.buttonToggled = NO;
        //NSLog(@"Female list:%@" , self.femalePlaylistArray);
    }
}

- (IBAction)newGameButtonPressed:(id)sender {
    [self.malePlaylistArray removeAllObjects];
    [self.femalePlaylistArray removeAllObjects];
    
    [self.ericButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.ericButton.buttonToggled = NO;
    [self.ryanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.ryanButton.buttonToggled = NO;
    [self.YitingButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.YitingButton.buttonToggled = NO;
    [self.cejButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.cejButton.buttonToggled = NO;
    [self.pihanButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.pihanButton.buttonToggled = NO;
    [self.karenButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.karenButton.buttonToggled = NO;
    [self.gloryButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.gloryButton.buttonToggled = NO;
    [self.jenniferButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.jenniferButton.buttonToggled = NO;
    
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.destinationViewController isKindOfClass:[GameScheduleTableViewController class]]) {
        GameScheduleTableViewController *vc = segue.destinationViewController;
        vc.malePlaylistArray = self.malePlaylistArray;
        vc.femalePlaylistArray = self.femalePlaylistArray;
        
    }
    
}


@end
