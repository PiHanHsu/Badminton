//
//  TeamPlayersTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/22.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "TeamPlayersTableViewController.h"
#import "GameScheduleTableViewController.h"
#import "PlayerTableViewCell.h"
#import "Player.h"
#import "AddPlayerViewController.h"
#import "PlayerSwitch.h"
#import "DataSource.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface TeamPlayersTableViewController ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray * malePlayerArray;
@property (strong, nonatomic) NSMutableArray * femalePlayerArray;
@property (strong, nonatomic) NSMutableArray * playerArray;
@property (strong, nonatomic) UIButton * playBallButton;

@end

@implementation TeamPlayersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self.tabBarController.tabBar setHidden:YES];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.malePlayerArray removeAllObjects];
    [self.femalePlayerArray removeAllObjects];
    
    NSDate * time1 = [NSDate date];
    
    for (Player * player in self.teamObject[@"players"]) {
        [player fetchIfNeededInBackgroundWithBlock:^(PFObject *playerObject, NSError * error){
            if ([player[@"isMale"] boolValue]) {
                [self.malePlayerArray addObject:player];
            }else{
                [self.femalePlayerArray addObject:player];
            }
            [self.tableView reloadData];
            NSDate * time2 = [NSDate date];
            NSTimeInterval loadingTime = [time2 timeIntervalSinceDate:time1];
            NSLog(@"Loading players: %f", loadingTime);
        }];
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) playBallPressed: (id)sender{
    [self performSegueWithIdentifier:@"Show Schedule" sender:nil];
    //    GameScheduleTableViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameScheduleVC"];
    //    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Lazy init for NSMutableArray

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.malePlayerArray.count > 0 && self.femalePlayerArray.count >0) {
        return 2;
    }else if (self.malePlayerArray.count > 0 && self.femalePlayerArray.count == 0){
        return 1;
    }else if (self.malePlayerArray.count == 0 && self.femalePlayerArray.count > 0){
        return 1;
    }else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (self.malePlayerArray.count > 0) {
                return self.malePlayerArray.count;
            }else if (self.malePlayerArray.count == 0 && self.femalePlayerArray.count > 0){
                return self.femalePlayerArray.count;
            }else{
                return 0;
            }
            
            break;
            
        case 1:
            return self.femalePlayerArray.count;
            break;
            
        default:
            break;
    }
    
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 288, 44)];
    if(section == 0 && self.malePlayerArray.count > 0){
        label.text = @"Male Player";
        self.playBallButton = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.frame.size.width - 100, 7, 80, 30)];
        [self.playBallButton setTitle:@"PlayBall" forState:UIControlStateNormal];
        [self.playBallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
         [self.playBallButton setTitleColor:[UIColor colorWithRed:74.0/255.0 green:203.0/255.0 blue:53.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        self.playBallButton.layer.borderWidth = 1.0f;
        self.playBallButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.playBallButton.layer.cornerRadius = 5.0;
        self.playBallButton.clipsToBounds = YES;
        
        self.playBallButton.enabled = NO;
        [self.playBallButton addTarget:self action:@selector(playBallPressed:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:self.playBallButton];

    }else{
        label.text = @"Female Player";
    }
    
    label.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    [headerView addSubview:label];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"forIndexPath:indexPath];
    NSURL * imageUrl;
    
    switch (indexPath.section) {
        case 0:{
            if (self.malePlayerArray.count > 0) {
                Player * player = self.malePlayerArray[indexPath.row];
                cell.playerLabel.text = player.userName;
                imageUrl = [NSURL URLWithString:player.pictureUrl];
                cell.playerImageView.layer.cornerRadius = 18.0f;
                cell.playerImageView.clipsToBounds = YES;
                [cell.playerImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"player_image_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                cell.playerSwitch.player = player;
                if ([[PlayListDataSource sharedInstance].maleSelectedArray containsObject:player]){
                    cell.playerSwitch.on = YES;
                }else{
                    cell.playerSwitch.on = NO;
                }
            }else {
                Player * player = self.femalePlayerArray[indexPath.row];
                cell.playerLabel.text = player.userName;
                imageUrl = [NSURL URLWithString:player.pictureUrl];
                cell.playerImageView.layer.cornerRadius = 18.0f;
                cell.playerImageView.clipsToBounds = YES;
                [cell.playerImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"player_image_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                cell.playerSwitch.player = player;
                if ([[PlayListDataSource sharedInstance].femaleSelectedArray containsObject:player]){
                    cell.playerSwitch.on = YES;
                }else{
                    cell.playerSwitch.on = NO;
                }
            }
            
            break;

        }
        case 1:{
            Player * player = self.femalePlayerArray[indexPath.row];
            cell.playerLabel.text = player.userName;
            imageUrl = [NSURL URLWithString:player.pictureUrl];
            cell.playerImageView.layer.cornerRadius = 18.0f;
            cell.playerImageView.clipsToBounds = YES;
            [cell.playerImageView setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"player_image_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            cell.playerSwitch.player = player;
            
            if ([[PlayListDataSource sharedInstance].femaleSelectedArray containsObject:player]){
                cell.playerSwitch.on = YES;
            }else{
                cell.playerSwitch.on = NO;
            }
            break;
        }
            
        default:
            break;
    }
    
    [cell.playerSwitch addTarget:self action:@selector(selectPlayers:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void) selectPlayers: (UISwitch *) sender{
    PlayerSwitch * playerSwitch = (PlayerSwitch *) sender;
    
    //[[DataSource sharedInstance]addPlayerToPlayList:playerSwitch.player];
    
    
    if ([playerSwitch.player[@"isMale"] boolValue]) {
        if ([sender isOn]) {
            [[PlayListDataSource sharedInstance]addToMalePlayerList:playerSwitch.player];
        }else {
            [[PlayListDataSource sharedInstance]removeFromMalePlayerList:playerSwitch.player];
        }
    }else{
        if ([sender isOn]) {
            [[PlayListDataSource sharedInstance]addToFemalePlayerList:playerSwitch.player];
        }else {
            [[PlayListDataSource sharedInstance]removeFromFemalePlayerList:playerSwitch.player];
        }
    }
    [self checkPlayBallButtonEnable];
    
}

// Override to support editing the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        if (indexPath.section == 1) {
            Player * playerToBeDeleted = self.femalePlayerArray[indexPath.row];
            [self.teamObject deletePlayer:playerToBeDeleted];
            [self.teamObject[@"players"] removeObject: playerToBeDeleted];
            [self.teamObject saveEventually];
            
            [self.femalePlayerArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else if (indexPath.section == 0){
            Player * playerToBeDeleted = self.malePlayerArray[indexPath.row];
            [self.teamObject deletePlayer:playerToBeDeleted];
            [self.teamObject[@"players"] removeObject: playerToBeDeleted];
            [self.teamObject saveEventually];
            
            [self.malePlayerArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Check play Ball Button enable

- (void)checkPlayBallButtonEnable{
    if (([PlayListDataSource sharedInstance].maleSelectedArray.count +[PlayListDataSource sharedInstance].femaleSelectedArray.count) > 1 ) {
        self.playBallButton.enabled = YES;
        self.playBallButton.layer.borderColor = [UIColor colorWithRed:74.0/255.0 green:203.0/255.0 blue:53.0/255.0 alpha:1.0].CGColor;
    }else{
        self.playBallButton.enabled = NO;
        self.playBallButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[AddPlayerViewController class]]) {
        AddPlayerViewController * vc = segue.destinationViewController;
        vc.teamObject = self.teamObject;
    }else if ([segue.destinationViewController isKindOfClass:[GameScheduleTableViewController class]]) {
        GameScheduleTableViewController * vc = segue.destinationViewController;
        vc.teamObject = self.teamObject;
    }
    
}


@end
