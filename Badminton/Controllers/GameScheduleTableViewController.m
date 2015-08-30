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



@interface GameScheduleTableViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) ScoreBoard * scoreboard;
@property(nonatomic,strong) UIDynamicAnimator *animator;
@property(strong, nonatomic) UIView * scoreBoardDestinationView;
@property (strong, nonatomic) Game *game;

@end

@implementation GameScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 62;
    
    [self.tabBarController.tabBar setHidden:YES];
    [self shuffleList];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==3) {
    }else if (self.malePlaylistArrayNew.count == 4 && self.femalePlaylistArrayNew.count ==3){
    }else if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==2){
    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) == 0){
        NSString * title = @"沒人是要打個鬼啊！";
        [self alertViewWithTitle:title withMessage:nil];
    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) == 1){
        NSString * title = @"1個人？ 在開玩笑吧！";
        [self alertViewWithTitle:title withMessage:nil];
    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) == 2){
        NSString * title = @"請不要污辱程式設計師的智商！";
        [self alertViewWithTitle:title withMessage:nil];
    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) == 3){
        NSString * title = @"3個人? 有點複雜，要花點時間算一下，不如你們先開打吧！";
        [self alertViewWithTitle:title withMessage:nil];
    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) ==4 ){
        NSString * title = @"雙打打累打單打\n單打打累打雙打";
        NSString * message = @"請大聲唸10遍！！";
        [self alertViewWithTitle:title withMessage:message];
    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count) ==5 ){
        NSString * title = @"大哥大姐～\n 人這麼少自己輪一下好唄！";
        [self alertViewWithTitle:title withMessage:nil];
    }else if ((self.malePlaylistArrayNew.count + self.femalePlaylistArrayNew.count)==6){
        NSString * title = @"動點腦，6個人很好排，腦子久不動可是會生鏽滴～";
        [self alertViewWithTitle:title withMessage:nil];
    }else{
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
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Games", @"Refresh Game", @"Logout", nil];
    alertView.tag = 1;
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
            }else if (buttonIndex ==3){
                [PFUser logOut];
                //[PFUser unpinAllObjects];
                //[PFObject unpinAllObjects];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            break;
        case 2:
            if (buttonIndex == 1) {
                [self.navigationController popViewControllerAnimated:YES];
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

- (void) shuffleList{
    
    self.malePlaylistArray = [PlayListDataSource sharedInstance].maleSelectedArray;
    self.femalePlaylistArray =[PlayListDataSource sharedInstance].femaleSelectedArray;
    self.malePlaylistArrayNew = [[PlayListDataSource sharedInstance]sheffleList:self.malePlaylistArray];
    self.femalePlaylistArrayNew = [[PlayListDataSource sharedInstance]sheffleList:self.femalePlaylistArray];
    self.game = [Game new];
    self.game.gameScheduleArray = [self.game createGameScheduleWithMalePlayers:self.malePlaylistArrayNew femalePlayer:self.femalePlaylistArrayNew];
    
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
    //not work?
//    if (self.game.gameScheduleArray[indexPath.row][0][1][@"isMale"]) {
//        cell.player3Label.textColor = [UIColor blueColor];
//    }else{
//        cell.player3Label.textColor = [UIColor orangeColor];
//    }
    
    cell.player1Label.text = self.game.gameScheduleArray[indexPath.row][0][0][@"userName"];
    cell.player3Label.text = self.game.gameScheduleArray[indexPath.row][0][1][@"userName"];
    cell.player2Label.text = self.game.gameScheduleArray[indexPath.row][1][0][@"userName"];
    cell.player4Label.text = self.game.gameScheduleArray[indexPath.row][1][1][@"userName"];
    
    cell.gameNumberLabel.text = [NSString stringWithFormat:@"Game %li",indexPath.row+1];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.scoreboard removeFromSuperview];
    
    self.scoreboard = [[[NSBundle mainBundle] loadNibNamed:@"ScoreBoard" owner:self options:nil] objectAtIndex:0];
    self.scoreBoardDestinationView = [[UIView alloc]init];
    
    if (indexPath.row > 4) {
        //self.scoreboard.frame = CGRectMake(5, 64 +62*(indexPath.row-1) - 135, 310, 130);
        self.scoreBoardDestinationView.center =CGPointMake(160, 64 +62*indexPath.row - 130 -5);
        
    }else
    self.scoreBoardDestinationView.center = CGPointMake(160, 64+62*indexPath.row + 62 + 5);
    
    
    self.scoreboard.layer.cornerRadius = 10.0;
    self.scoreboard.clipsToBounds = YES;
    self.scoreboard.cancelButton.layer.cornerRadius = 5.0;
    self.scoreboard.cancelButton.clipsToBounds = YES;
    self.scoreboard.saveButton.layer.cornerRadius = 5.0;
    self.scoreboard.saveButton.clipsToBounds = YES;
    [self.scoreboard.cancelButton addTarget:self action:@selector(cancelScoreBoard:) forControlEvents:UIControlEventTouchUpInside];
    [self.scoreboard.saveButton addTarget:self action:@selector(saveScoreBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.scoreboard];
    [self willShow];
}

- (void) saveScoreBoard: (id) sedder {
    [self.tabBarController.tabBar setHidden:YES];
    //TODO Save Game to Parse
    PFObject * gameObject = [PFObject objectWithClassName:@"Game"];
    
    
    
    [self viewDismiss];
    //TODO count unfinish Games
    // if unfinish Game == 0 , show alrerview and back to Time VC
}

- (void) cancelScoreBoard: (id) sender {
    
    [self.scoreboard removeFromSuperview];
}

#pragma mark Animation
-(void)willShow {
    // Use UIKit Dynamics to make the alertView appear.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
     UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.scoreboard snapToPoint:self.scoreBoardDestinationView.center];
    
//    UISnapBehavior *snapBehaviour = [[UISnapBehavior alloc] initWithItem:self.scoreboard snapToPoint:CGPointMake(self.scoreboard.center.x, self.scoreboard.center.y)];
    NSLog(@"x: %f, y:%f",self.scoreboard.center.x, self.scoreboard.center.y);
    NSLog(@"Dx: %f, Dy:%f",self.scoreBoardDestinationView.center.x, self.scoreBoardDestinationView.center.y);

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
