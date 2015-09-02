//
//  StandingTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/9/1.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "StandingTableViewController.h"
#import <Parse/Parse.h>

@interface StandingTableViewController ()
@property (strong, nonatomic) NSArray * winGames;
@property (strong, nonatomic) NSArray * loseGames;
@property (strong, nonatomic) NSString * totalStandingStr;
@property (strong, nonatomic) NSString * doubleStandingStr;
@property (strong, nonatomic) NSString * singleStandingStr;
@property (strong, nonatomic) NSString * mixStandingStr;

@property (strong, nonatomic) NSString * bestMaleTeammate;
@property (strong, nonatomic) NSString * bestFemaleTeammate;
@property (weak, nonatomic) IBOutlet UILabel *overallStandingLabel;
@property (weak, nonatomic) IBOutlet UILabel *doubleStandingLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleStandingLabel;
@property (weak, nonatomic) IBOutlet UILabel *mixStandingLabel;

@end

@implementation StandingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [self getStandings];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self getStandings];
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

    return 4;
}


- (void) getStandings{
    
    PFUser * user = [PFUser currentUser];
    PFQuery * getUserId = [PFQuery queryWithClassName:@"Player"];
    [getUserId whereKey:@"user" equalTo:user.objectId];
    PFObject * currentPlayer = [getUserId getFirstObject];
    
    
    PFQuery * query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"WinTeam" equalTo:[PFObject objectWithoutDataWithClassName:@"Player" objectId:currentPlayer.objectId]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * winGames, NSError * error){
        self.winGames = winGames;
        [self createStrings];
    }];
    
    PFQuery * queryLoseGames = [PFQuery queryWithClassName:@"Game"];
    [queryLoseGames whereKey:@"LoseTeam" equalTo:[PFObject objectWithoutDataWithClassName:@"Player" objectId:currentPlayer.objectId]];
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
        if ([self.winGames[i][@"GameType"] isEqualToString:@"single"])
            singleWins ++;
    }
    
    int doulbeWins = 0;
    for (int i = 0; i < self.winGames.count ; i ++) {
        if ([self.winGames[i][@"GameType"] isEqualToString:@"double"])
            doulbeWins ++;
    }
    int mixWins = 0;
    for (int i = 0; i < self.winGames.count ; i ++) {
        if ([self.winGames[i][@"GameType"] isEqualToString:@"mix"])
            mixWins ++;
    }
    
    int singleLoses = 0;
    for (int i = 0; i < self.loseGames.count ; i ++) {
        if ([self.loseGames[i][@"GameType"] isEqualToString:@"single"])
        singleLoses ++;
    }
    int doulbeLoses = 0;
    for (int i = 0; i < self.loseGames.count ; i ++) {
        if ([self.loseGames[i][@"GameType"] isEqualToString:@"double"])
            doulbeLoses ++;
    }
   
    int mixLoses = 0;
    for (int i = 0; i < self.loseGames.count ; i ++) {
        if ([self.loseGames[i][@"GameType"] isEqualToString:@"mix"])
            mixLoses ++;
    }

    self.overallStandingLabel.text = [NSString stringWithFormat:@"%luW %luL",(unsigned long)self.winGames.count, (unsigned long)self.loseGames.count];
    self.singleStandingLabel.text = [NSString stringWithFormat:@"%dW %dL",singleWins, singleLoses];
    self.doubleStandingLabel.text = [NSString stringWithFormat:@"%dW %dL",doulbeWins, doulbeLoses];
    self.mixStandingLabel.text = [NSString stringWithFormat:@"%dW %dL",mixWins, mixLoses];
    [self.tableView reloadData];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseCell" forIndexPath:indexPath];
//    
////    switch (indexPath.row) {
////        case 0:
////            cell.textLabel.text = self.totalStandingStr;
////            break;
////        case 1:
////            cell.textLabel.text = self.mixStandingStr;
////            break;
////        case 2:
////            cell.textLabel.text = self.doubleStandingStr;
////            break;
////        case 3:
////            cell.textLabel.text = self.singleStandingStr;
////            break;
////            
////        default:
////            break;
////    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
