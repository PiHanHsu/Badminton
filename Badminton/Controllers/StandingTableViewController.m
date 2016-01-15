//
//  StandingTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/1.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "StandingTableViewController.h"
#import "StandingWithTeammateTableViewController.h"
#import <Parse/Parse.h>
#import "DataSource.h"

@interface StandingTableViewController ()
@property (strong, nonatomic) NSArray * winGames;
@property (strong, nonatomic) NSArray * loseGames;
@property (strong, nonatomic) NSString * totalStandingStr;
@property (strong, nonatomic) NSString * doubleStandingStr;
@property (strong, nonatomic) NSString * singleStandingStr;
@property (strong, nonatomic) NSString * mixStandingStr;

@property (weak, nonatomic) IBOutlet UILabel *overAllWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *overallLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *mixWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *mixLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubleWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubleLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleWinLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleLoseLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxStreakWinsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStreakWinsLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) NSMutableArray * playerStatsWithTeammateArray;
@property (strong, nonatomic) NSArray * playerStatsWithDoubleGameArray;
@property (strong, nonatomic) NSArray * playerStatsWithMixGameArray;
@property (strong, nonatomic) NSString * gameType;

@property (strong, nonatomic) NSArray * currentPlayerGamesArray;
@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@property (weak, nonatomic) IBOutlet UILabel *bestTeammateForDoubleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestTeammateForMixLabel;

@end

@implementation StandingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [self getStandings];
    [[DataSource sharedInstance] loadGamesFromServer:self.playerId];
    PFQuery * query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"objectId" equalTo:self.playerId];
    self.currentPlayerForStats = [query getFirstObject];
    self.title = self.currentPlayerForStats[@"userName"];
    
//    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    self.indicator.center = self.view.center;
    
    [self.activityIndicatorView startAnimating];
   // [self.view addSubview:self.indicator];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"calculateStreakWinsFinished"
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *notification) {
         if ([notification.name isEqualToString:@"calculateStreakWinsFinished"]) {
             int maxStreakWins = [[DataSource sharedInstance].maxStreakWins intValue];
             int currentStreakWins = [[DataSource sharedInstance].currentStreakWins intValue];
             self.maxStreakWinsLabel.text = [NSString stringWithFormat:@"%d連勝", maxStreakWins];
             self.currentStreakWinsLabel.text = [NSString stringWithFormat:@"%d連勝", currentStreakWins];
             [self.tableView reloadData];
             [self.activityIndicatorView stopAnimating];
             
         }
     }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"getBestTeammateFinished"
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *notification) {
         if ([notification.name isEqualToString:@"getBestTeammateFinished"]) {
             self.playerStatsWithDoubleGameArray = [DataSource sharedInstance].statsWithTeammatesByDoubleGameArray;
             self.playerStatsWithMixGameArray = [DataSource sharedInstance].statsWithTeammatesByMixGameArray;
             
             NSString * bestTeammateForDouble = @"--";
             NSString * bestTeammateForMix = @"";
             if (self.playerStatsWithDoubleGameArray.count > 0) {
                 bestTeammateForDouble = self.playerStatsWithDoubleGameArray[0][@"player"][@"userName"];
             }
             
             bestTeammateForMix = self.playerStatsWithMixGameArray[0][@"player"][@"userName"];
             self.bestTeammateForDoubleLabel.text = bestTeammateForDouble;
             self.bestTeammateForMixLabel.text = bestTeammateForMix;
             
         }
     }];

    //[self getStandings];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 9;
}



- (void) getStandings{
    
//    PFUser * user = [PFUser currentUser];
//    PFQuery * getUserId = [PFQuery queryWithClassName:@"Player"];
//    [getUserId whereKey:@"user" equalTo:user.objectId];
//    PFObject * currentPlayer = [getUserId getFirstObject];
    
    
    PFQuery * query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"winTeam" equalTo:self.playerId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * winGames, NSError * error){
        self.winGames = winGames;
        [self createStrings];
    }];
    
    PFQuery * queryLoseGames = [PFQuery queryWithClassName:@"Game"];
    [queryLoseGames whereKey:@"loseTeam" equalTo:self.playerId];
    [queryLoseGames findObjectsInBackgroundWithBlock:^(NSArray * loseGames, NSError * error){
        self.loseGames = loseGames;
        [self createStrings];
    }];
    
}

- (void) createStrings{
    
    if (self.winGames == nil || self.loseGames == nil) {
        return;
    }
    
    int singleWins = 0;
    for (int i = 0; i < self.winGames.count ; i ++) {
        if ([self.winGames[i][@"gameType"] isEqualToString:@"single"])
            singleWins ++;
    }
    
    int doulbeWins = 0;
    for (int i = 0; i < self.winGames.count ; i ++) {
        if ([self.winGames[i][@"gameType"] isEqualToString:@"double"])
            doulbeWins ++;
    }
    int mixWins = 0;
    for (int i = 0; i < self.winGames.count ; i ++) {
        if ([self.winGames[i][@"gameType"] isEqualToString:@"mix"])
            mixWins ++;
    }
    
    int singleLoses = 0;
    for (int i = 0; i < self.loseGames.count ; i ++) {
        if ([self.loseGames[i][@"gameType"] isEqualToString:@"single"])
        singleLoses ++;
    }
    int doulbeLoses = 0;
    for (int i = 0; i < self.loseGames.count ; i ++) {
        if ([self.loseGames[i][@"gameType"] isEqualToString:@"double"])
            doulbeLoses ++;
    }
   
    int mixLoses = 0;
    for (int i = 0; i < self.loseGames.count ; i ++) {
        if ([self.loseGames[i][@"gameType"] isEqualToString:@"mix"])
            mixLoses ++;
    }

    self.overAllWinLabel.text = [NSString stringWithFormat:@"%lu", self.winGames.count];
    self.overallLoseLabel.text = [NSString stringWithFormat:@"%lu", self.loseGames.count];
    self.doubleWinLabel.text =[NSString stringWithFormat:@"%d", doulbeWins];
    self.doubleLoseLabel.text = [NSString stringWithFormat:@"%d", doulbeLoses];
    self.mixWinLabel.text = [NSString stringWithFormat:@"%d", mixWins];
    self.mixLoseLabel.text= [NSString stringWithFormat:@"%d", mixLoses];
    self.singleWinLabel.text = [NSString stringWithFormat:@"%d", singleWins];
    self.singleLoseLabel.text = [NSString stringWithFormat:@"%d", singleLoses];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    self.selectedPlayerId = self.teamPlayersStandingArray[indexPath.row][@"playerId"];
//    NSLog(@"id: %@", self.selectedPlayerId);
    if (indexPath.row == 6){
        self.gameType = @"Double";
        if (![self.bestTeammateForDoubleLabel.text isEqualToString:@"--"]) {
            [self performSegueWithIdentifier:@"Show Stats with Teammates" sender:nil];
        }
    }else if (indexPath.row == 7) {
        self.gameType = @"Mix";
        [self performSegueWithIdentifier:@"Show Stats with Teammates" sender:nil];
    }
    
}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}


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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[StandingWithTeammateTableViewController class]]) {
        StandingWithTeammateTableViewController * vc = segue.destinationViewController;
        vc.currentPlayerForStats = self.currentPlayerForStats;
        vc.playerStatsWithDoubleGameArray = self.playerStatsWithDoubleGameArray;
        vc.playerStatsWithMixGameArray = self.playerStatsWithMixGameArray;
        vc.gameType = self.gameType;
    }

}



@end
