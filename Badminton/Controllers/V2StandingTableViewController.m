//
//  V2StandingTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/29.
//  Copyright © 2015年 PiHan Hsu. All rights reserved.
//

#import "V2StandingTableViewController.h"
#import "StandingTableViewCell.h"
#import "StandingTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface V2StandingTableViewController ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentedControl;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) UIPickerView * pickerView;
@property (strong, nonatomic) NSArray * pickerData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterBarButton;
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;


@property (strong, nonatomic) NSMutableArray * teamNameList;
@property (strong, nonatomic) NSArray * yearList;
@property (strong, nonatomic) NSMutableArray * teamPlayers;
@property (strong, nonatomic) NSArray * teamPlayersArray;
@property (strong, nonatomic) Player * selectedPlayer;
@property (strong, nonatomic) NSArray * gamesArray; // array of game records

@end

@implementation V2StandingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.center = self.view.center;
    [self.activityIndicatorView startAnimating];
    [self.view addSubview:self.activityIndicatorView];
    
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
        self.teamNameLabel.text = self.teamObject[@"name"];
        
        [self createPlayerStatsWithYear:9999];
    }
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.activityIndicatorView stopAnimating];

}

#pragma mark - IBAction

- (IBAction)fliterBarButtonPressed:(id)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"選擇球隊及年份" message:@"\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   NSInteger row1 = [self.pickerView selectedRowInComponent:0];
                                                   NSInteger row2 = [self.pickerView selectedRowInComponent:1];
                                                   self.teamObject = self.teamArray[row1];
                                                   self.teamNameLabel.text = self.teamObject[@"name"];

                                                   NSInteger year;
                                                   if (row2 == 0) {
                                                       year = 9999;
                                                       self.yearLabel.text = @"Year : All";
                                                   }else{
                                                       year = [self.yearList[row2] integerValue];
                                                       self.yearLabel.text = [NSString stringWithFormat:@"%ld",(long)year];
                                                   }
                                                   
                                                   [self createPlayerStatsWithYear:year];
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    
    self.pickerData = @[self.teamNameList,self.yearList];
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(10, 20, 250, 150)];
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
        [pickerLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
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
    
    UILabel *winslabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.45 + 62, 0, 30, 30)];
    winslabel.text = @"勝";
    winslabel.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    winslabel.backgroundColor = [UIColor clearColor];
    winslabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    UILabel *loseslabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.45 + 97, 0, 30, 30)];
    loseslabel.text = @"敗";
    loseslabel.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    loseslabel.backgroundColor = [UIColor clearColor];
    loseslabel.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    UILabel *winsRatelabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.45 + 127, 0, 45, 30)];
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
    NSURL * url = [NSURL URLWithString:player.pictureUrl];
    
    cell.playerImageView.layer.cornerRadius = 18.0f;
    cell.playerImageView.clipsToBounds = YES;
    [cell.playerImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"player_image_small"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    if (self.gameTypeSegmentedControl.selectedSegmentIndex == 0) {
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", player.totalWins];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", player.totalLosses];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", fabs(player.totalWinRate.floatValue)];
        
    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 1) {
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", player.mixWins];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", player.mixLosses];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", fabs(player.mixWinRate.floatValue)];
        
    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 2) {
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", player.doubleWins];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", player.doubleLosses];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", fabs(player.doubleWinRate.floatValue)];
        
    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 3) {
        
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", player.singleWins];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", player.singleLosses];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", fabs(player.singleWinRate.floatValue)];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectedPlayer = self.teamPlayersArray[indexPath.row];
    
    [self performSegueWithIdentifier:@"Go To Stats" sender:nil];
    
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

- (void) createPlayerStatsWithYear: (NSInteger) year{
    
    self.teamPlayers = [@[] mutableCopy];
    
    PFQuery * query = [PFQuery queryWithClassName:@"Game"];
    query.limit = 1000;
    [query whereKey:@"team" equalTo:self.teamObject.objectId];
    if (year == 9999) {
        NSDate * now = [NSDate date];
       [query whereKey:@"createdAt" lessThan:now];
    }else{
        NSCalendar *calendar = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:year];
        [components setMonth:1];
        [components setDay:1];
        [components setHour:0];
        [components setMinute:0];
        
        NSDate *startDate = [calendar dateFromComponents:components];
        
        NSCalendar *calendar2 = [[NSCalendar alloc]
                                initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *endComponents = [[NSDateComponents alloc] init];
        [endComponents setYear:year];
        [endComponents setMonth:12];
        [endComponents setDay:31];
        [components setHour:23];
        [components setMinute:59];
        
        NSDate *endDate = [calendar2 dateFromComponents:endComponents];
        [query whereKey:@"createdAt" lessThan:endDate];
        [query whereKey:@"createdAt" greaterThan:startDate];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
        
        self.gamesArray = objects;
        [DataSource sharedInstance].teamGamesArray = self.gamesArray;
        
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
            if ([player.singleWins intValue] > 0 || [player.singleLosses intValue] > 0) {
                float singleWinRate = player.singleWins.floatValue / (player.singleWins.floatValue + player.singleLosses.floatValue) * 100;
                player.singleWinRate = [NSNumber numberWithFloat:singleWinRate];
            }else {
                
                player.singleWinRate = [NSNumber numberWithFloat:-0.00001];
                
            }
            
            player.doubleWins = [NSNumber numberWithUnsignedLong:[doubleWinGameSet countForObject:playerId]];
            player.doubleLosses = [NSNumber numberWithUnsignedLong:[doubleLossGameSet countForObject:playerId]];
            if ([player.doubleWins intValue] > 0 || [player.doubleLosses intValue] > 0) {
                float doubleWinRate = player.doubleWins.floatValue / (player.doubleWins.floatValue + player.doubleLosses.floatValue) * 100;
                player.doubleWinRate = [NSNumber numberWithFloat:doubleWinRate];
            }else{
                player.doubleWinRate = [NSNumber numberWithFloat:0];
            }
            
            player.mixWins = [NSNumber numberWithUnsignedLong:[mixWinGameSet countForObject:playerId]];
            player.mixLosses = [NSNumber numberWithUnsignedLong:[mixLossGameSet countForObject:playerId]];
            if ( [player.mixWins intValue]> 0 || [player.mixLosses intValue] > 0) {
                float mixWinRate = player.mixWins.floatValue / (player.mixWins.floatValue + player.mixLosses.floatValue) * 100;
                player.mixWinRate = [NSNumber numberWithFloat:mixWinRate];
            }else{
                player.mixWinRate = [NSNumber numberWithFloat:-0.00001];
            }
            
            player.totalWins =[NSNumber numberWithInt:player.singleWins.intValue +player.doubleWins.intValue + player.mixWins.intValue];
            player.totalLosses =[NSNumber numberWithInt:player.singleLosses.intValue +player.doubleLosses.intValue + player.mixLosses.intValue];
            if ([player.totalWins intValue] > 0 || [player.totalLosses intValue] > 0) {
                float totalWinRate = player.totalWins.floatValue / (player.totalWins.floatValue + player.totalLosses.floatValue) * 100;
                player.totalWinRate = [NSNumber numberWithFloat:totalWinRate];
            }else{
                player.totalWinRate = [NSNumber numberWithFloat:0];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[StandingTableViewController class]]) {
        StandingTableViewController * vc = segue.destinationViewController;
        vc.currentPlayerForStats = self.selectedPlayer;
        vc.teamObject = self.teamObject;
        //vc.gameArray = self.gamesArray;
        
    }
    
    
}
@end
