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
@property (strong, nonatomic) NSArray * playerStatsWithDoubleGameArray;
@property (strong, nonatomic) NSArray * playerStatsWithMixGameArray;
@property (strong, nonatomic) NSString * gameType;

@property (strong, nonatomic) NSArray * currentPlayerGamesArray;
@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@property (weak, nonatomic) IBOutlet UILabel *bestTeammateForDoubleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bestTeammateForMixLabel;
@property (strong, nonatomic) NSMutableArray * currentPlayerStatsArray;

@property (assign, nonatomic) int maxStreakWins;
@property (assign, nonatomic) int currentStreakWins;

@property (assign, nonatomic) BOOL hasStreakWinsData;
@property (assign, nonatomic) BOOL hasBestTeammateData;

@end

@implementation StandingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    self.title = self.currentPlayerForStats[@"userName"];
    self.playerId = self.currentPlayerForStats.objectId;
    self.hasStreakWinsData = NO;
    self.hasBestTeammateData = NO;
    [self createStatsArray:self.gameArray player:self.playerId];
    
    [self.activityIndicatorView startAnimating];
    [self displayData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

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

#pragma mark - calculate Data

- (NSMutableArray *) createStatsArray:(NSArray *) playerGameArray player: (NSString *) playerId{
    self.currentPlayerStatsArray = [@[] mutableCopy];
    
    NSLog(@"n = %lu", (unsigned long)playerGameArray.count);
    
    for (int i = 0 ; i < playerGameArray.count; i++) {
        NSDictionary * statsDict = [[NSDictionary alloc] init];
        NSMutableArray * winTeam = playerGameArray[i][@"winTeam"];
        NSMutableArray * loseTeam = playerGameArray[i][@"loseTeam"];
        
        NSString * teamMate = [[NSString alloc]init];
        if ([winTeam containsObject:playerId]) {
            
            if (winTeam.count > 1) {
                [winTeam removeObject:playerId];
                teamMate = winTeam[0];
            }else{
                teamMate = @"";
            }
            statsDict = @{@"winOrLose" : @"Win",
                          @"teammate" : teamMate,
                          @"opponent" : loseTeam,
                          @"gameType" : playerGameArray[i][@"gameType"],
                          @"date" : playerGameArray[i][@"date"]};
            [self.currentPlayerStatsArray addObject:statsDict];
        }else if ([loseTeam containsObject:playerId]){
            
            if (loseTeam.count > 1) {
                [loseTeam removeObject:playerId];
                teamMate = loseTeam[0];
            }else{
                teamMate = @"";
            }
            NSString * teamMate = loseTeam[0];
            statsDict = @{@"winOrLose" : @"Lose",
                          @"teammate" : teamMate,
                          @"opponent" : winTeam,
                          @"gameType" : playerGameArray[i][@"gameType"],
                          @"date" : playerGameArray[i][@"date"]};
            [self.currentPlayerStatsArray addObject:statsDict];
        }
        
        
    }
    
    //NSLog(@"playerStatsArray: %@", self.currentPlayerStatsArray);
    [self getSteakWins:self.currentPlayerStatsArray];
    [self getBestTeammate:self.currentPlayerStatsArray player:playerId];
    return self.currentPlayerStatsArray;
}
-(void) getBestTeammate:(NSMutableArray *) playerStatsArray player:(NSString *) playerId{
    NSMutableArray * winTeammates = [@[] mutableCopy];
    NSMutableArray * loseTeammates = [@[] mutableCopy];
    NSMutableArray * statsWithDoubleGame = [@[] mutableCopy];
    NSMutableArray * statsWithMixGame = [@[] mutableCopy];
    
    PFQuery * query = [PFQuery queryWithClassName:@"Player"];
    [query whereKey:@"objectId" equalTo:playerId];
    Player * playerForStats = [query getFirstObject];
    
    for (NSDictionary * stats in playerStatsArray) {
        
        if ([stats[@"winOrLose"] isEqualToString:@"Win"]){
            [winTeammates addObject: stats[@"teammate"]];
        }else{
            [loseTeammates addObject: stats[@"teammate"]];
        }
    }
    
    [winTeammates removeObject:@""];
    NSCountedSet * winSet =[[NSCountedSet alloc] initWithArray:winTeammates];
    NSCountedSet * loseSet =[[NSCountedSet alloc] initWithArray:loseTeammates];
    
    
    //TODO, if player has 0 win, s/he will not show in winSet
    for (id item in winSet)
    {
        PFQuery * query = [PFQuery queryWithClassName:@"Player"];
        [query whereKey:@"objectId" equalTo:item];
        Player * player = [query getFirstObject];
        
        NSNumber * wins = [NSNumber numberWithUnsignedLong:[winSet countForObject:item]];
        NSNumber * loses = [NSNumber numberWithUnsignedLong:[loseSet countForObject:item]];
        float rate = wins.floatValue / (wins.floatValue + loses.floatValue) * 100;
        NSNumber * winRate = [NSNumber numberWithFloat:rate];
        
        NSDictionary * statsDict = @{@"player" : player,
                                     @"wins" : wins,
                                     @"loses" : loses,
                                     @"winRate" : winRate};
        
        if ([playerForStats[@"isMale"]boolValue] && [player[@"isMale"] boolValue]){
            [statsWithDoubleGame addObject:statsDict];
        }else if (![playerForStats[@"isMale"]boolValue] && ![player[@"isMale"] boolValue] ){
            [statsWithDoubleGame addObject:statsDict];
        }else{
            [statsWithMixGame addObject:statsDict];
        }
    }
    
    self.playerStatsWithDoubleGameArray = [[NSArray alloc]initWithArray:statsWithDoubleGame];
    self.playerStatsWithMixGameArray = [[NSArray alloc]initWithArray:statsWithMixGame];
    
    NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"winRate" ascending:NO];
    self.playerStatsWithDoubleGameArray = [self.playerStatsWithDoubleGameArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    self.playerStatsWithMixGameArray = [self.playerStatsWithMixGameArray sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    self.hasBestTeammateData = YES;
    [self displayData];
   
}
-(void) getSteakWins:(NSMutableArray *) playerStatsArray{
    // Calculate StrakWins
    int streakWins = 0;
    int maxStreakWins = 0;
    int streakLoses = 0;
    int maxStreakLoses = 0;
    
    for (int i = 0 ; i < playerStatsArray.count; i++) {
        
        if ([playerStatsArray[i][@"winOrLose"] isEqualToString:@"Win"]) {
            streakWins ++;
            if (streakLoses > maxStreakLoses) {
                maxStreakLoses = streakLoses;
                streakLoses = 0;
            }
            streakLoses = 0;
        }else if ([playerStatsArray[i][@"winOrLose"] isEqualToString:@"Lose"]){
            streakLoses ++;
            if (streakWins > maxStreakWins) {
                maxStreakWins = streakWins;
                streakWins = 0;
            }
            streakWins = 0;
        }
    }
    
    //TODO: sometimes, the number is wrong
    self.currentStreakWins = streakWins;
    self.maxStreakWins = maxStreakWins;
//    NSLog(@"Max streakWins: %d", maxStreakWins);
//    NSLog(@"current Streak wins: %d", streakWins);
//    NSLog(@"Max streakLoses: %d", maxStreakLoses);
//    NSLog(@"current Streak Loses: %d", streakLoses);
    
    self.hasStreakWinsData = YES;

    [self displayData];
   
}

#pragma mark - Display Data

-(void) displayData{
    
    // games stats
    self.overAllWinLabel.text = [NSString stringWithFormat:@"%@", self.currentPlayerForStats.totalWins];
    self.overallLoseLabel.text = [NSString stringWithFormat:@"%@", self.currentPlayerForStats.totalLosses];
    self.doubleWinLabel.text =[NSString stringWithFormat:@"%@", self.currentPlayerForStats.doubleWins];
    self.doubleLoseLabel.text = [NSString stringWithFormat:@"%@", self.currentPlayerForStats.doubleLosses];
    self.mixWinLabel.text = [NSString stringWithFormat:@"%@", self.currentPlayerForStats.mixWins];
    self.mixLoseLabel.text= [NSString stringWithFormat:@"%@", self.currentPlayerForStats.mixLosses];
    self.singleWinLabel.text = [NSString stringWithFormat:@"%@", self.currentPlayerForStats.singleWins];
    self.singleLoseLabel.text = [NSString stringWithFormat:@"%@", self.currentPlayerForStats.singleLosses];
    
    //wins in a row
    
    self.maxStreakWinsLabel.text = [NSString stringWithFormat:@"%d連勝", self.maxStreakWins];
    self.currentStreakWinsLabel.text = [NSString stringWithFormat:@"%d連勝", self.currentStreakWins];

    //best teammate
    NSString * bestTeammateForDouble = @"--";
    NSString * bestTeammateForMix = @"--";
    if (self.playerStatsWithDoubleGameArray.count > 0) {
        bestTeammateForDouble = self.playerStatsWithDoubleGameArray[0][@"player"][@"userName"];
    }
    
    if (self.playerStatsWithMixGameArray.count > 0) {
       bestTeammateForMix = self.playerStatsWithMixGameArray[0][@"player"][@"userName"];
    }
    
    self.bestTeammateForDoubleLabel.text = bestTeammateForDouble;
    self.bestTeammateForMixLabel.text = bestTeammateForMix;
    
    if (self.hasBestTeammateData && self.hasStreakWinsData) {
         [self.activityIndicatorView stopAnimating];
    }
}

#pragma mark - Navigation

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
