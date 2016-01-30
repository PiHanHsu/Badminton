//
//  GameScheduleTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "GameScheduleTableViewController.h"
#import "GameScheduleTableViewCell.h"
#import "PlayListDataSource.h"
#import "Game.h"
#import "ScoreBoard.h"
#import "DataSource.h"
#import "GameMatches.h"



@interface GameScheduleTableViewController ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) ScoreBoard * scoreboard;
@property(nonatomic,strong) UIDynamicAnimator *animator;
@property(strong, nonatomic) UIView * scoreBoardDestinationView;
@property (strong, nonatomic) Game *game;
@property (strong, nonatomic) NSArray * tempTeam1Array;
@property (strong, nonatomic) NSArray * tempTeam2Array;
@property (strong, nonatomic) NSString * gameType;
@property (strong, nonatomic) NSMutableArray * playersArray;

@end

@implementation GameScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 62;
    
    [self.tabBarController.tabBar setHidden:YES];
    self.playersArray = [DataSource sharedInstance].selectedPlayersArray;
    self.playersArray = [[DataSource sharedInstance]sheffleList:self.playersArray];
    
    //self.game.gameScheduleArray = [[GameMatches new] createMatches:self.playersArray];
    
    
    [self shuffleList];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==3) {
//    }else if (self.malePlaylistArrayNew.count == 4 && self.femalePlaylistArrayNew.count ==3){
//    }else if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==2){
//    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) == 0){
//        NSString * title = @"沒人是要打個鬼啊！";
//        [self alertViewWithTitle:title withMessage:nil];
//    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) == 1){
//        NSString * title = @"1個人？ 在開玩笑吧！";
//        [self alertViewWithTitle:title withMessage:nil];
//    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) == 2){
//        NSString * title = @"請不要污辱程式設計師的智商！";
//        [self alertViewWithTitle:title withMessage:nil];
//    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) == 3){
//        NSString * title = @"3個人? 有點複雜，要花點時間算一下，不如你們先開打吧！";
//        [self alertViewWithTitle:title withMessage:nil];
//    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) ==4 ){
//        NSString * title = @"雙打打累打單打\n單打打累打雙打";
//        NSString * message = @"請大聲唸10遍！！";
//        [self alertViewWithTitle:title withMessage:message];
//    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) ==5 ){
//        NSString * title = @"大哥大姐～\n 人這麼少自己輪一下好唄！";
//        [self alertViewWithTitle:title withMessage:nil];
//    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count)==6){
//        NSString * title = @"動點腦，6個人很好排，腦子久不動可是會生鏽滴～";
//        [self alertViewWithTitle:title withMessage:nil];
//    }else{
//        NSString * title = @"Oops! Sorry!";
//        NSString * message = @"Please reselect again!";
//        [self alertViewWithTitle:title withMessage:message];
//
//    }
    if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count)>8) {
        NSString * title = @"Oops! Sorry!";
        NSString * message = @"Please reselect again!";
        [self alertViewWithTitle:title withMessage:message];

    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark init MutableArray

//lazy init array

- (NSMutableArray *) playersArray {
    if(!_playersArray)
        _playersArray = [@[] mutableCopy];
    return _playersArray;
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


#pragma mark AlertView Delegate

- (void)alertViewWithTitle:(NSString *)title withMessage:(NSString *)mesg {
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:title
                                                        message:mesg
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                               nil];
    alertView.tag =0;
    [alertView show];
}


- (IBAction)refreshButtonPressed:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Games", @"Refresh Game", nil];
    alertView.tag = 1;
    [alertView show];
    
}
- (IBAction)backButtonPressed:(id)sender {
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"Notice!"
                                                        message:@"This schedule won't be saved if you exit now."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK",
                               nil];
    alertView.tag =2;
    [alertView show];
}

- (void) countUnfinishGames{
    
    for (int i = 0; i < self.game.gameScheduleArray.count ; i ++) {
        NSLog(@"finish: %d, %@", i,self.game.gameScheduleArray[i][4] );
        if (![self.game.gameScheduleArray[i][4] boolValue]) {
            return;
        }
    }
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"All Finished!!" message:@"Press OK to restart a series" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertView.tag = 3;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 0:
            if (buttonIndex == 0) {
                
            }
            break;
        case 1:
            if (buttonIndex == 1) {
                
            }else if (buttonIndex ==2){
                [self refreshGames];
            }
            break;
        case 2:
            if (buttonIndex == 1) {
                [self.navigationController popViewControllerAnimated:YES];
                [[PlayListDataSource sharedInstance].maleSelectedArray removeAllObjects];
                [[PlayListDataSource sharedInstance].femaleSelectedArray removeAllObjects];
            }
            break;
        case 3:
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
                [[PlayListDataSource sharedInstance].maleSelectedArray removeAllObjects];
                [[PlayListDataSource sharedInstance].femaleSelectedArray removeAllObjects];
            }
            break;

        default:
            break;
    }
    
}

- (void) refreshGames{
    [self.malePlaylistArrayNew removeAllObjects];
    [self.femalePlaylistArrayNew removeAllObjects];
    [self shuffleList];
}

- (void) createGameSchedule{
//    if ((self.malePlaylistArray.count + self.femalePlaylistArray.count) < 4) {
//        self.game.gameScheduleArray = [self.game createSinglePlayerGames:self.malePlaylistArrayNew femalePlayer:self.femalePlaylistArrayNew];
//    }else{
//        self.game.gameScheduleArray = [self.game createGameScheduleWithMalePlayers:self.malePlaylistArrayNew femalePlayer:self.femalePlaylistArrayNew];
//    }
    
    [self.tableView reloadData];
}

- (void) shuffleList{
    
    self.malePlaylistArray = [PlayListDataSource sharedInstance].maleSelectedArray;
    self.femalePlaylistArray =[PlayListDataSource sharedInstance].femaleSelectedArray;
    self.malePlaylistArrayNew = [[PlayListDataSource sharedInstance]sheffleList:self.malePlaylistArray];
    self.femalePlaylistArrayNew = [[PlayListDataSource sharedInstance]sheffleList:self.femalePlaylistArray];
    self.game = [Game new];
    if ((self.malePlaylistArray.count + self.femalePlaylistArray.count) < 4) {
        self.game.gameScheduleArray = [self.game createSinglePlayerGames:self.malePlaylistArrayNew femalePlayer:self.femalePlaylistArrayNew];
    }else{
         self.game.gameScheduleArray = [self.game createGameScheduleWithMalePlayers:self.malePlaylistArrayNew femalePlayer:self.femalePlaylistArrayNew];
    }
   
    
    [self.tableView reloadData];
 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.game.gameScheduleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GameScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playListCell" forIndexPath:indexPath];
    
     if ([self.game.gameScheduleArray[indexPath.row][0] count] == 1) {
         cell.player1Label.frame = CGRectMake(8, 20, 80, 21);
         cell.player2Label.frame = CGRectMake(232, 20, 80, 21);
         cell.player1Label.text = self.game.gameScheduleArray[indexPath.row][0][0][@"userName"];
         cell.player2Label.text = self.game.gameScheduleArray[indexPath.row][1][0][@"userName"];
         cell.player3Label.text = @"";
         cell.player4Label.text =@"";
     }else{
         if ([self.game.gameScheduleArray[indexPath.row][0][1][@"isMale"] boolValue]) {
             cell.player3Label.textColor = [UIColor blueColor];
             cell.player4Label.textColor = [UIColor blueColor];
         }else{
             cell.player3Label.textColor = [UIColor orangeColor];
             cell.player4Label.textColor = [UIColor orangeColor];
         }
         cell.player1Label.text = self.game.gameScheduleArray[indexPath.row][0][0][@"userName"];
         cell.player3Label.text = self.game.gameScheduleArray[indexPath.row][0][1][@"userName"];
         cell.player2Label.text = self.game.gameScheduleArray[indexPath.row][1][0][@"userName"];
         cell.player4Label.text = self.game.gameScheduleArray[indexPath.row][1][1][@"userName"];
     }
    
    cell.team1ScoreLabel.text = self.game.gameScheduleArray[indexPath.row][2];
    cell.team2ScoreLabel.text = self.game.gameScheduleArray[indexPath.row][3];
    cell.team1TieBreakScoreLabel.text = self.game.gameScheduleArray[indexPath.row][5];
    cell.team2TieBreakScoreLabel.text = self.game.gameScheduleArray[indexPath.row][6];
    
    if ([self.game.gameScheduleArray[indexPath.row][2] intValue] > 0){
        if ([cell.team1ScoreLabel.text intValue] > [cell.team2ScoreLabel.text intValue]) {
            cell.team1ScoreLabel.textColor = [UIColor redColor];
        }else{
            cell.team2ScoreLabel.textColor = [UIColor redColor];
        }
    }
   
    
    
    cell.gameNumberLabel.text = [NSString stringWithFormat:@"Game %li",indexPath.row+1];
    
    if ([self.game.gameScheduleArray[indexPath.row][4] boolValue]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.player1Label.textColor = [UIColor lightGrayColor];
        cell.player2Label.textColor = [UIColor lightGrayColor];
        cell.player3Label.textColor = [UIColor lightGrayColor];
        cell.player4Label.textColor = [UIColor lightGrayColor];
        cell.gameNumberLabel.textColor = [UIColor lightGrayColor];
    }else
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    
    cell.tag = 0;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.scoreboard removeFromSuperview];
    
    if ([self.game.gameScheduleArray[indexPath.row][4] boolValue]) {
        return;
    }
    [self.scoreboard.team1ScoreTextField becomeFirstResponder];

    self.scoreboard = [[[NSBundle mainBundle] loadNibNamed:@"ScoreBoard" owner:self options:nil] objectAtIndex:0];
    self.scoreBoardDestinationView = [[UIView alloc]init];
    
    if (indexPath.row > 3) {
        self.scoreBoardDestinationView.center =CGPointMake(self.view.center.x, 64 +62*indexPath.row - 130 -5);
    }else{
        self.scoreBoardDestinationView.center = CGPointMake(self.view.center.x, 64+62*indexPath.row + 62 + 5);
    }
    
    self.scoreboard.team1ScoreTextField.delegate =self;
    self.scoreboard.team2ScoreTextField.delegate =self;
    
    [self.scoreboard.cancelButton addTarget:self action:@selector(cancelScoreBoard:) forControlEvents:UIControlEventTouchUpInside];
    [self.scoreboard.saveButton addTarget:self action:@selector(saveScoreBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tempTeam1Array = self.game.gameScheduleArray[indexPath.row][0];
    self.tempTeam2Array = self.game.gameScheduleArray[indexPath.row][1];
    
    self.scoreboard.saveButton.tag = indexPath.row;
    
    [self.view addSubview:self.scoreboard];
    [self willShow];
}

- (void) saveScoreBoard: (id) sender {
    [self.tabBarController.tabBar setHidden:YES];
    UIButton *saveButton = (UIButton *) sender;
    
    BOOL isTieBreak = NO;
    
    if (self.tempTeam1Array.count == 1) {
       self.gameType = @"single";
    }else if ([self.tempTeam1Array[0][@"isMale"] boolValue] == [self.tempTeam1Array[1][@"isMale"] boolValue]) {
        self.gameType = @"double";
    }else{
        self.gameType = @"mix";
    }
    
    //TODO Save Game to Parse
    PFObject * gameObject = [PFObject objectWithClassName:@"Game"];
    if ([self.scoreboard.team1ScoreTextField.text intValue] >
        [self.scoreboard.team2ScoreTextField.text intValue]) {
        int winTeamScore = [self.scoreboard.team1ScoreTextField.text intValue];
        int loseTeamScore = [self.scoreboard.team2ScoreTextField.text intValue];
        gameObject[@"winTeamScore"] = [NSNumber numberWithInt:winTeamScore];
        gameObject[@"loseTeamScore"] = [NSNumber numberWithInt:loseTeamScore];
        if ([self.teamObject[@"sportsType"] isEqualToString:@"網    球"]) {
            if (winTeamScore == 7 && loseTeamScore == 6) {
                isTieBreak = YES;
                gameObject[@"winTieBreakScore"] = [NSNumber numberWithInt:[self.scoreboard.team1TieBreakScoreTextField.text intValue]];
                gameObject[@"loseTieBreakScore"] = [NSNumber numberWithInt:[self.scoreboard.team2TieBreakScoreTextField.text intValue]];
            }
        }
        NSMutableArray * winTeam = [@[] mutableCopy];
        NSMutableArray * loseTeam = [@[] mutableCopy];
        for (int i = 0 ; i < self.tempTeam1Array.count ; i++) {
            Player * winner = self.tempTeam1Array[i];
            Player * loser = self.tempTeam2Array[i];
            [winTeam addObject:winner.objectId];
            [loseTeam addObject:loser.objectId];
        }
        gameObject[@"winTeam"] = winTeam;
        gameObject[@"loseTeam"] = loseTeam;

       
    }else{
        int winTeamScore = [self.scoreboard.team2ScoreTextField.text intValue];
        int loseTeamScore = [self.scoreboard.team1ScoreTextField.text intValue];
        gameObject[@"winTeamScore"] = [NSNumber numberWithInt:winTeamScore];
        gameObject[@"loseTeamScore"] = [NSNumber numberWithInt:loseTeamScore];
        
        if ([self.teamObject[@"sportsType"] isEqualToString:@"網    球"]) {
            if (winTeamScore == 7 && loseTeamScore == 6) {
                isTieBreak = YES;
                gameObject[@"winTieBreakScore"] = [NSNumber numberWithInt:[self.scoreboard.team1TieBreakScoreTextField.text intValue]];
                gameObject[@"loseTieBreakScore"] = [NSNumber numberWithInt:[self.scoreboard.team2TieBreakScoreTextField.text intValue]];
            }
        }
        NSMutableArray * winTeam = [@[] mutableCopy];
        NSMutableArray * loseTeam = [@[] mutableCopy];
        for (int i = 0 ; i < self.tempTeam1Array.count ; i++) {
            Player * winner = self.tempTeam2Array[i];
            Player * loser = self.tempTeam1Array[i];
            [winTeam addObject:winner.objectId];
            [loseTeam addObject:loser.objectId];
        }
        gameObject[@"winTeam"] = winTeam;
        gameObject[@"loseTeam"] = loseTeam;
    }
    NSDate * date = [NSDate date];
    gameObject[@"date"] = date;
    gameObject[@"team"] = [NSString stringWithFormat:@"%@", self.teamObject.objectId];
    gameObject[@"gameType"] = self.gameType;
    gameObject[@"sportsType"] = self.teamObject[@"sportsType"];
    
    
    [gameObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error){
        if (succeeded) {
            self.game.gameScheduleArray[saveButton.tag][2]=self.scoreboard.team1ScoreTextField.text;
            self.game.gameScheduleArray[saveButton.tag][3]=self.scoreboard.team2ScoreTextField.text;
            self.game.gameScheduleArray[saveButton.tag][4] = [NSNumber numberWithBool:YES];
            if (isTieBreak) {
                self.game.gameScheduleArray[saveButton.tag][5]=self.scoreboard.team1TieBreakScoreTextField.text;
                self.game.gameScheduleArray[saveButton.tag][6]=self.scoreboard.team2TieBreakScoreTextField.text;
            }
            
            [self.tableView reloadData];
            [self countUnfinishGames];
            
        }
    }];
    
    [self updateStangingWithWinTeam:gameObject[@"winTeam"] loseTeam:gameObject[@"loseTeam"] gameType:gameObject[@"gameType"] team:self.teamObject.objectId];
    
    [self viewDismiss];
    [self.scoreboard.team1ScoreTextField resignFirstResponder];
    [self.scoreboard.team2ScoreTextField resignFirstResponder];

}


#pragma mark - TextField Delegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([self.teamObject[@"sportsType"] isEqualToString:@"網    球"]){
        if ([newString isEqualToString:@"7"] || [newString isEqualToString:@"6"]) {
            //show tiebreak
            if (textField == self.scoreboard.team1ScoreTextField) {
                if ([self.scoreboard.team2ScoreTextField.text isEqualToString:@"7"] || [self.scoreboard.team2ScoreTextField.text isEqualToString:@"6"]) {
                    self.scoreboard.team1TieBreakScoreTextField.hidden = NO;
                    self.scoreboard.team2TieBreakScoreTextField.hidden = NO;
                }
            }else if (textField == self.scoreboard.team2ScoreTextField) {
                if ([self.scoreboard.team1ScoreTextField.text isEqualToString:@"7"] || [self.scoreboard.team1ScoreTextField.text isEqualToString:@"6"]) {
                    self.scoreboard.team1TieBreakScoreTextField.hidden = NO;
                    self.scoreboard.team2TieBreakScoreTextField.hidden = NO;
                }
            }
        }else{
            self.scoreboard.team1TieBreakScoreTextField.hidden = YES;
            self.scoreboard.team2TieBreakScoreTextField.hidden = YES;
        }
        
    }
    
    
    return YES;
    
}


- (void)updateStangingWithWinTeam: (NSMutableArray *) winTeam loseTeam:(NSMutableArray *)loseTeam gameType:(NSString *)gameType team:(NSString *) team{
    for (NSString * winner in winTeam) {
        PFQuery * query = [PFQuery queryWithClassName:@"Standing"];
        [query whereKey:@"playerId" equalTo:winner];
        [query whereKey:@"team" equalTo:[PFObject objectWithoutDataWithClassName:@"Team" objectId:team]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError * error) {
            [object incrementKey:@"wins"];
            
            if ([gameType isEqualToString:@"double"]) {
                [object incrementKey:@"doublewins"];
            }else if ([gameType isEqualToString:@"mix"]){
                [object incrementKey:@"mixWins"];

            }else if ([gameType isEqualToString:@"single"]){
                [object incrementKey:@"singleWins"];
            }

            NSLog(@"newObject: %@", object);
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                
                if (error) {
                    NSLog(@"error: %@", error);
                }else{
                    NSLog(@"Winner Standing updated to Parse");
                }
            }];
        }];
    }
    
    for (NSString * loser in loseTeam) {
        PFQuery * query = [PFQuery queryWithClassName:@"Standing"];
        [query whereKey:@"playerId" equalTo:loser];
        [query whereKey:@"team" equalTo:[PFObject objectWithoutDataWithClassName:@"Team" objectId:team]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject * object, NSError * error) {
            [object incrementKey:@"loses"];

            if ([gameType isEqualToString:@"double"]) {
                [object incrementKey:@"doubleLoses"];
                
            }else if ([gameType isEqualToString:@"mix"]){
                [object incrementKey:@"mixLoses"];

            }else if ([gameType isEqualToString:@"single"]){
                [object incrementKey:@"singleLoses"];

            }
            [object saveInBackground];
         }];
    }    
}

- (void) cancelScoreBoard: (id) sender {
    self.tempTeam1Array = [@[] mutableCopy];
    self.tempTeam2Array = [@[] mutableCopy];
    [self.scoreboard.team1ScoreTextField resignFirstResponder];
    [self.scoreboard.team2ScoreTextField resignFirstResponder];

    [self.scoreboard removeFromSuperview];
}

#pragma mark Animation
-(void)willShow {
    // Use UIKit Dynamics to make the alertView appear.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
     UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.scoreboard snapToPoint:self.scoreBoardDestinationView.center];
    
    //控制下落速度,數字越大越慢
    snapBehaviour.damping = .8f;
    [self.animator addBehavior:snapBehaviour];

}

-(void)viewDismiss {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIGravityBehavior *gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.scoreboard]];
    //控制方向與速度. 0.0f -->正下方, 10.0f 速度 （數字越大越快）
    gravityBehaviour.gravityDirection = CGVectorMake(0.0f, 10.0f);
    [self.animator addBehavior:gravityBehaviour];
    
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.scoreboard]];
    //控制轉動程度,2.0f-->數字越大轉動越大
    [itemBehaviour addAngularVelocity:2.0f forItem:self.scoreboard];
    [self.animator addBehavior:itemBehaviour];
    
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
