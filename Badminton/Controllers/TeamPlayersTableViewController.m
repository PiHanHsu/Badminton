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

@interface TeamPlayersTableViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
@property BOOL hasMalePlayer;
@property BOOL hasFemalePlayer;
@property (strong, nonatomic) NSMutableArray * malePlayerArray;
@property (strong, nonatomic) NSMutableArray * femalePlayerArray;
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
    
    [[PlayListDataSource sharedInstance].maleSelectedArray removeAllObjects];
    [[PlayListDataSource sharedInstance].femaleSelectedArray removeAllObjects];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   NSDate * time1 = [NSDate date];
    
    NSArray * playerArray = self.teamObject[@"malePlayers"];
    NSLog(@"players count: %lu", (unsigned long)playerArray.count);
    
    [self.malePlayerArray removeAllObjects];
    [self.femalePlayerArray removeAllObjects];
    
    for (Player * player in self.teamObject[@"malePlayers"]) {
        [player fetchIfNeededInBackgroundWithBlock:^(PFObject *playerObject, NSError * error){
            
                [self.malePlayerArray addObject:player];
                [self.tableView reloadData];
                
                NSDate * time2 = [NSDate date];
                NSTimeInterval loadingTime = [time2 timeIntervalSinceDate:time1];
                NSLog(@"Loading male players: %f", loadingTime);
        }];
        
        if ((self.malePlayerArray.count + self.femalePlayerArray.count) > 2) {
                self.tableView.tableFooterView.hidden = NO;
        }
    }
    
    for (Player * player in self.teamObject[@"femalePlayers"]) {
        [player fetchIfNeededInBackgroundWithBlock:^(PFObject *playerObject, NSError * error){
            
            [self.femalePlayerArray addObject:player];
            [self.tableView reloadData];
            
            NSDate * time3 = [NSDate date];
            NSTimeInterval loadingTime = [time3 timeIntervalSinceDate:time1];
            NSLog(@"Loading female players: %f", loadingTime);
        }];
    }
    
}

- (void) showFooterView{
    if ((self.malePlayerArray.count + self.femalePlayerArray.count) > 2) {
        self.tableView.tableFooterView.hidden = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (IBAction)backButtonPressed:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void) playBallPressed: (id)sender{
    GameScheduleTableViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GameScheduleVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    tableView.sectionHeaderHeight = 44;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 11, 288, 21)];
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
    
    //TODO, can't switch new cell
    //cell.switchButton.tag = indexPath.row;
    if (indexPath.section == 0) {
        //cell.switchButton.tag = indexPath.row;
        [cell.playerSwitch addTarget:self action:@selector(addToMaleList:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.section == 1){
        //cell.switchButton.tag = indexPath.row;
        [cell.playerSwitch addTarget:self action:@selector(addToFemaleList:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

- (void) addToMaleList: (UISwitch *)sender{
    
    PlayerSwitch * playerSwitch = (PlayerSwitch *) sender;
    
    if ([sender isOn]) {
        [[PlayListDataSource sharedInstance]addToMalePlayerList:playerSwitch.player];
    }else {
        [[PlayListDataSource sharedInstance]removeFromMalePlayerList:playerSwitch.player];
    }
    
}

- (void) addToFemaleList: (UISwitch *)sender{
    
    PlayerSwitch * playerSwitch = (PlayerSwitch *) sender;
   
    if ([sender isOn]) {
        [[PlayListDataSource sharedInstance]addToFemalePlayerList:playerSwitch.player];
    }else {
        [[PlayListDataSource sharedInstance]removeFromFemalePlayerList:playerSwitch.player];
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
            //[tableView deleteRowsAtIndexPaths:self.femalePlayerArray[indexPath.row] withRowAnimation:UITableViewRowAnimationFade];
            [self.femalePlayerArray removeObjectAtIndex:indexPath.row];
            [self.teamObject[@"malePlayers"] removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else if (indexPath.section == 0){
            [self.malePlayerArray removeObjectAtIndex:indexPath.row];
            [self.teamObject[@"malePlayers"] removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PlayerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"forIndexPath:indexPath];
//    cell.contentView.backgroundColor = [UIColor yellowColor];
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
        
    }
   
}


@end
