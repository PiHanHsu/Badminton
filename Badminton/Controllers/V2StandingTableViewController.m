//
//  V2StandingTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/29.
//  Copyright © 2015年 PiHan Hsu. All rights reserved.
//

#import "V2StandingTableViewController.h"
#import "StandingTableViewCell.h"
#import "Standing.h"
#import "StandingTableViewController.h"

@interface V2StandingTableViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) NSArray * playerArray;
@property (strong, nonatomic) NSArray * teamPlayersStandingArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentedControl;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSString * selectedPlayerId;
@property (weak, nonatomic) IBOutlet UIButton *teamButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (strong, nonatomic) UIPickerView * pickerView;
@property (strong, nonatomic) NSArray * pickerData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterBarButton;
@property (strong, nonatomic) NSMutableArray * teamNameList;
@property (strong, nonatomic) NSArray * yearList;
@property (strong, nonatomic) NSMutableArray * teamPlayers;
@property (strong, nonatomic) NSArray * teamPlayersArray;

@end

@implementation V2StandingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView startAnimating];
    [self.view addSubview:self.activityIndicatorView];
    
    self.teamButton.layer.borderWidth = 1.0f;
    self.teamButton.layer.borderColor = [UIColor colorWithRed:130.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    self.teamButton.layer.cornerRadius = 5.0;
    self.teamButton.clipsToBounds = YES;
    
    self.yearButton.layer.borderWidth = 1.0f;
    self.yearButton.layer.borderColor = [UIColor colorWithRed:130.0/255.0 green:180.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    self.yearButton.layer.cornerRadius = 5.0;
    self.yearButton.clipsToBounds = YES;
    
    self.teamArray = [DataSource sharedInstance].teamArray;
    if (self.teamArray.count == 0) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"目前尚未有排名資訊" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self.activityIndicatorView stopAnimating];
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        self.teamObject = self.teamArray[0];
        self.teamNameList = [@[] mutableCopy];
        for (Team * teamObject in self.teamArray){
            NSString * teamName = teamObject[@"name"];
            [self.teamNameList addObject:teamName];
        }
        self.yearList = @[@"All", @"2015", @"2016"];

        [self.teamButton setTitle:self.teamObject[@"name"] forState:UIControlStateNormal];
        [self.yearButton setTitle:@"Year: All" forState:UIControlStateNormal];

    }
    
    [self createPlayerStats];
}


#pragma mark - IBAction

- (IBAction)fliterBarButtonPressed:(id)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"選擇球隊及年份" message:@"\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    
    self.pickerData = @[self.teamNameList,self.yearList];
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(10, 20, 250, 120)];
    //self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    [alert.view addSubview:self.pickerView];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - PickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return self.teamNameList.count;
            break;
        case 1:
            return self.yearList.count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[component][row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    switch (component) {
        case 0:
            pickerLabel.text=[self.teamNameList objectAtIndex:row];
            break;
        case 1:
            pickerLabel.text=[self.yearList objectAtIndex:row];
            break;
        default:
            break;
    }
    
    
    return pickerLabel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teamPlayersArray.count;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    //headerView.backgroundColor = [UIColor greenColor];
    //tableView.sectionHeaderHeight = 44;
    
    UILabel *winslabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 125, 0, 30, 30)];
    winslabel.text = @"勝";
    winslabel.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    winslabel.backgroundColor = [UIColor clearColor];
    winslabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    UILabel *loseslabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90, 0, 30, 30)];
    loseslabel.text = @"敗";
    loseslabel.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    loseslabel.backgroundColor = [UIColor clearColor];
    loseslabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    UILabel *winsRatelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 55, 0, 45, 30)];
    winsRatelabel.text = @"勝率";
    winsRatelabel.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    winsRatelabel.backgroundColor = [UIColor clearColor];
    winsRatelabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    [headerView addSubview:winslabel];
    [headerView addSubview:loseslabel];
    [headerView addSubview:winsRatelabel];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StandingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandingTableViewCell" forIndexPath:indexPath];
    
    Player * player = self.teamPlayersArray[indexPath.row];
    cell.playerNameLabel.text = player.userName;

    
    if (self.gameTypeSegmentedControl.selectedSegmentIndex == 0) {
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", player.totalWins];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", player.totalLosses];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", player.totalWinRate.floatValue];
        
    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 1) {
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", player.mixWins];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", player.mixLosses];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", player.mixWinRate.floatValue];
        
    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 2) {
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", player.doubleWins];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", player.doubleLosses];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", player.doubleWinRate.floatValue];
        
    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 3) {
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", player.singleWins];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", player.singleLosses];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", player.singleWinRate.floatValue];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedPlayerId = self.teamPlayersStandingArray[indexPath.row][@"playerId"];
    NSLog(@"id: %@", self.selectedPlayerId);
    [self performSegueWithIdentifier:@"Go To Stats" sender:nil];
    
}

//[self.teamObject loadTeamPlayerStandingArray];
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[StandingTableViewController class]]) {
        StandingTableViewController * vc = segue.destinationViewController;
        vc.playerId = self.selectedPlayerId;
    }
    
    
}

#pragma mark SegmentedControlSwitch

- (IBAction)segmentedControlSwitch:(id)sender {
    switch (self.gameTypeSegmentedControl.selectedSegmentIndex) {
        case 0:{
//            NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"winRate" ascending:NO];
//            self.teamPlayersStandingArray = [self.teamPlayersStandingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            
            self.teamPlayersArray = [self.teamPlayersArray sortedArrayUsingComparator:^NSComparisonResult(Player * player1, Player * player2) {
                return [player2.totalWinRate compare:player1.totalWinRate];
            }];
            [self.tableView reloadData];
            break;
        }
        case 1:{
            self.teamPlayersArray = [self.teamPlayersArray sortedArrayUsingComparator:^NSComparisonResult(Player * player1, Player * player2) {
                return [player2.mixWinRate compare:player1.mixWinRate];
            }];
            [self.tableView reloadData];
            break;
            
        }
        case 2:{
            self.teamPlayersArray = [self.teamPlayersArray sortedArrayUsingComparator:^NSComparisonResult(Player * player1, Player * player2) {
                return [player2.doubleWinRate compare:player1.doubleWinRate];
            }];

            [self.tableView reloadData];
            break;
        }
        case 3:{
        
            self.teamPlayersArray = [self.teamPlayersArray sortedArrayUsingComparator:^NSComparisonResult(Player * player1, Player * player2) {
                return [player2.singleWinRate compare:player1.singleWinRate];
            }];

            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - create Data

- (void) createPlayerStats{
    
    self.teamPlayers = [@[] mutableCopy];
    
    PFQuery * query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"team" equalTo:self.teamObject.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        NSMutableArray * singleWinGameArray = [@[] mutableCopy];
        NSMutableArray * singleLossGameArray = [@[] mutableCopy];
        NSMutableArray * doubleWinGameArray = [@[] mutableCopy];
        NSMutableArray * doubleLossGameArray = [@[] mutableCopy];
        NSMutableArray * mixWinGameArray = [@[] mutableCopy];
        NSMutableArray * mixLossGameArray = [@[] mutableCopy];
        
        for (Game * oneGame in objects) {
            
            if ([oneGame[@"gameType"] isEqualToString:@"single"]) {
                for (NSString * player in oneGame[@"winTeam"]) {
                    [singleWinGameArray addObject:player];
                }
                for (NSString * player in oneGame[@"loseTeam"]) {
                    [singleLossGameArray addObject:player];
                }
            }else if ([oneGame[@"gameType"] isEqualToString:@"double"]){
                for (NSString * player in oneGame[@"winTeam"]) {
                    [doubleWinGameArray addObject:player];
                }
                for (NSString * player in oneGame[@"loseTeam"]) {
                    [doubleLossGameArray addObject:player];
                }
            }else if ([oneGame[@"gameType"] isEqualToString:@"mix"]){
                for (NSString * player in oneGame[@"winTeam"]) {
                    [mixWinGameArray addObject:player];
                }
                for (NSString * player in oneGame[@"loseTeam"]) {
                    [mixLossGameArray addObject:player];
                }
            }
        }
        
        NSCountedSet * singleWinGameSet = [NSCountedSet setWithArray:singleWinGameArray];
        NSCountedSet * singleLossGameSet = [NSCountedSet setWithArray:singleLossGameArray];
        NSCountedSet * doubleWinGameSet = [NSCountedSet setWithArray:doubleWinGameArray];
        NSCountedSet * doubleLossGameSet = [NSCountedSet setWithArray:doubleLossGameArray];
        NSCountedSet * mixWinGameSet = [NSCountedSet setWithArray:mixWinGameArray];
        NSCountedSet * mixLossGameSet = [NSCountedSet setWithArray:mixLossGameArray];
        
        for (Player * player in self.teamObject[@"players"]) {
            NSString * playerId = player.objectId;
            player.singleWins = [NSNumber numberWithUnsignedLong:[singleWinGameSet countForObject:playerId]];
            player.singleLosses= [NSNumber numberWithUnsignedLong:[singleLossGameSet countForObject:playerId]];
            if (player.singleWins > 0 || player.singleLosses > 0) {
                float singleWinRate = player.singleWins.floatValue / (player.singleWins.floatValue + player.singleLosses.floatValue) * 100;
                player.singleWinRate = [NSNumber numberWithFloat:singleWinRate];
            }else{
                player.singleWinRate = [NSNumber numberWithFloat:0];
                
            }
            
            player.doubleWins = [NSNumber numberWithUnsignedLong:[doubleWinGameSet countForObject:playerId]];
            player.doubleLosses = [NSNumber numberWithUnsignedLong:[doubleLossGameSet countForObject:playerId]];
            if (player.doubleWins > 0 || player.doubleLosses > 0) {
                float doubleWinRate = player.doubleWins.floatValue / (player.doubleWins.floatValue + player.doubleLosses.floatValue) * 100;
                player.doubleWinRate = [NSNumber numberWithFloat:doubleWinRate];
            }
            
            player.mixWins = [NSNumber numberWithUnsignedLong:[mixWinGameSet countForObject:playerId]];
            player.mixLosses = [NSNumber numberWithUnsignedLong:[mixLossGameSet countForObject:playerId]];
            if ( player.mixWins > 0 || player.mixLosses > 0) {
                float mixWinRate = player.mixWins.floatValue / (player.mixWins.floatValue + player.mixLosses.floatValue) * 100;
                player.mixWinRate = [NSNumber numberWithFloat:mixWinRate];
            }else{
                player.mixWinRate = [NSNumber numberWithFloat:0];
            }
            player.totalWins =[NSNumber numberWithInt:player.singleWins.intValue +player.doubleWins.intValue + player.mixWins.intValue];
            player.totalLosses =[NSNumber numberWithInt:player.singleLosses.intValue +player.doubleLosses.intValue + player.mixLosses.intValue];
            if (player.totalWins > 0 || player.totalLosses > 0) {
                float totalWinRate = player.totalWins.floatValue / (player.totalWins.floatValue + player.totalLosses.floatValue) * 100;
                player.totalWinRate = [NSNumber numberWithFloat:totalWinRate];
            }
            
            [self.teamPlayers addObject:player];
        }
        
        self.teamPlayersArray = [[NSArray alloc]initWithArray:self.teamPlayers];
        self.teamPlayersArray = [self.teamPlayersArray sortedArrayUsingComparator:^NSComparisonResult(Player * player1, Player * player2) {
            return [player2.totalWinRate compare:player1.totalWinRate];
        }];

        [self.activityIndicatorView stopAnimating];
        [self.tableView reloadData];
    }];
    
    
}
@end
