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

@interface TeamPlayersTableViewController ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray * malePlayerArray;
@property (strong, nonatomic) NSMutableArray * femalePlayerArray;
@property (strong, nonatomic) NSMutableArray * playerArray;
@property (strong, nonatomic) UIButton * playBallButton;

@end

@implementation TeamPlayersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set up playball Button
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.tableView.tableFooterView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    self.playBallButton = [[UIButton alloc]initWithFrame:CGRectMake(110, 15, 100, 30)];
    [self.playBallButton setTitle:@"PlayBall" forState:UIControlStateNormal];
    [self.playBallButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.playBallButton addTarget:self action:@selector(playBallPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView.tableFooterView addSubview:self.playBallButton];
    self.tableView.tableFooterView.hidden = NO;
    
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
            return self.malePlayerArray.count;
            break;
            
        case 1:
            return self.femalePlayerArray.count;
            break;
            
        default:
            break;
    }
   
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    //headerView.backgroundColor = [UIColor greenColor];
    //tableView.sectionHeaderHeight = 44;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 288, 21)];
    if(section == 0)
        label.text = @"Male Player";
    else
        label.text = @"Female Player";
    
    label.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    [headerView addSubview:label];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.playerLabel.text = self.malePlayerArray[indexPath.row][@"userName"];
            cell.playerSwitch.player = self.malePlayerArray[indexPath.row];
            break;
        case 1:
            cell.playerLabel.text = self.femalePlayerArray[indexPath.row][@"userName"];
            cell.playerSwitch.player = self.femalePlayerArray[indexPath.row];
            break;
            
        default:
            break;
    }
    
    //TODO can't switch new cell
    cell.playerSwitch.on = NO;
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
    
        
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


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


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
