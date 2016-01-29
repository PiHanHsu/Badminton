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

@interface V2StandingTableViewController ()
@property (strong, nonatomic) NSArray * playerArray;
@property (strong, nonatomic) NSArray * teamPlayersStandingArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameTypeSegmentedControl;

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSString * selectedPlayerId;
@property (weak, nonatomic) IBOutlet UIButton *teamButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;

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
        [self.teamObject loadTeamPlayerStandingArrayWithDone:^(NSArray * array){
            self.teamPlayersStandingArray = [self createWinRateWithPlayerStatsArray:array];
            [self.activityIndicatorView stopAnimating];
            [self.tableView reloadData];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *) createWinRateWithPlayerStatsArray: (NSArray *)playerStatsArray{
   
    for (int i = 0 ; i < playerStatsArray.count; i++) {
        float wins = [playerStatsArray[i][@"wins"] floatValue];
        float loses = [playerStatsArray[i][@"loses"] floatValue];
        float winRate = 0;
        if (wins + loses > 0) {
            winRate = wins / (wins + loses) * 100;
        }
        
        float doubleWins = [playerStatsArray[i][@"doubleWins"] floatValue];
        float doubleLoses = [playerStatsArray[i][@"doubleLoses"] floatValue];
        float doubleWinRate = 0;
        if (doubleWins + doubleLoses > 0) {
            doubleWinRate = doubleWins / (doubleWins + doubleLoses) * 100;
        }
        
        float mixWins = [playerStatsArray[i][@"mixWins"] floatValue];
        float mixLoses = [playerStatsArray[i][@"mixLoses"] floatValue];
        float mixWinRate = 0;
        if (mixWins + mixLoses > 0) {
            mixWinRate = mixWins / (mixWins + mixLoses) * 100;
        }
        
        float singleWins = [playerStatsArray[i][@"singleWins"] floatValue];
        float singleLoses = [playerStatsArray[i][@"singleLoses"] floatValue];
        float singlwWinRate = 0;
        if (singleWins + singleLoses > 0) {
            singlwWinRate = singleWins / (singleWins + singleLoses) * 100;
        }
        
        playerStatsArray[i][@"winRate"] = [NSNumber numberWithFloat:winRate];
        playerStatsArray[i][@"doubleWinRate"] = [NSNumber numberWithFloat:doubleWinRate];
          
        playerStatsArray[i][@"mixWinRate"] = [NSNumber numberWithFloat:mixWinRate];
        playerStatsArray[i][@"singleWinRate"] = [NSNumber numberWithFloat:singlwWinRate];

    }
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"winRate" ascending:NO];
    playerStatsArray = [playerStatsArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    return playerStatsArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teamPlayersStandingArray.count;
    
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
    
    if (self.gameTypeSegmentedControl.selectedSegmentIndex == 0) {
        cell.playerNameLabel.text = self.teamPlayersStandingArray[indexPath.row][@"playerName"];
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", self.teamPlayersStandingArray[indexPath.row][@"wins"]];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", self.teamPlayersStandingArray[indexPath.row][@"loses"]];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", [self.teamPlayersStandingArray[indexPath.row][@"winRate"] floatValue]];

    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 1) {
        cell.playerNameLabel.text = self.teamPlayersStandingArray[indexPath.row][@"playerName"];
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", self.teamPlayersStandingArray[indexPath.row][@"mixWins"]];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", self.teamPlayersStandingArray[indexPath.row][@"mixLoses"]];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", [self.teamPlayersStandingArray[indexPath.row][@"mixWinRate"] floatValue]];
        
    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 2) {
        cell.playerNameLabel.text = self.teamPlayersStandingArray[indexPath.row][@"playerName"];
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", self.teamPlayersStandingArray[indexPath.row][@"doubleWins"]];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", self.teamPlayersStandingArray[indexPath.row][@"doubleLoses"]];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", [self.teamPlayersStandingArray[indexPath.row][@"doubleWinRate"] floatValue]];
        
    }else if (self.gameTypeSegmentedControl.selectedSegmentIndex == 3) {
        cell.playerNameLabel.text = self.teamPlayersStandingArray[indexPath.row][@"playerName"];
        cell.winsLabel.text = [NSString stringWithFormat:@"%@", self.teamPlayersStandingArray[indexPath.row][@"singleWins"]];
        cell.losesLabel.text = [NSString stringWithFormat:@"%@", self.teamPlayersStandingArray[indexPath.row][@"singleLoses"]];
        cell.rateLabel.text = [NSString stringWithFormat:@"%.f%%", [self.teamPlayersStandingArray[indexPath.row][@"singleWinRate"] floatValue]];
        
    }
    
    // Configure the cell...
    
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
            NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"winRate" ascending:NO];
            self.teamPlayersStandingArray = [self.teamPlayersStandingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            [self.tableView reloadData];
            break;
        }
        case 1:{
            NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"mixWinRate" ascending:NO];
            self.teamPlayersStandingArray = [self.teamPlayersStandingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            [self.tableView reloadData];
            break;

        }
        case 2:{
            NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"doubleWinRate" ascending:NO];
            self.teamPlayersStandingArray = [self.teamPlayersStandingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            [self.tableView reloadData];
            break;
        }
        case 3:{
            NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"singleWinRate" ascending:NO];
            self.teamPlayersStandingArray = [self.teamPlayersStandingArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            [self.tableView reloadData];
            break;
        }
        default:
            break;
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
