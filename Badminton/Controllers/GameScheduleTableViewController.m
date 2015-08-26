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

@interface GameScheduleTableViewController ()<UIAlertViewDelegate>

@end

@implementation GameScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 62;
    
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
    [self.tableView reloadData];
 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==3) {
      
        return 8;
    }else if (self.malePlaylistArrayNew.count == 4 && self.femalePlaylistArrayNew.count ==3){
       
        return 8;
    }else if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==2){
        
        return 4;
    }else{
        return 0;
    }
   
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playListCell" forIndexPath:indexPath];
    if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==3) {
        switch (indexPath.row) {
            case 0:
                cell.player1Label.text = self.femalePlaylistArrayNew[0];
                cell.player2Label.text = self.femalePlaylistArrayNew[1];
                cell.player3Label.text = self.malePlaylistArrayNew[0];
                cell.player4Label.text = self.malePlaylistArrayNew[1];
                break;
            case 1:
                cell.player1Label.text = self.femalePlaylistArrayNew[1];
                cell.player2Label.text = self.femalePlaylistArrayNew[2];
                cell.player3Label.text = self.malePlaylistArrayNew[2];
                cell.player4Label.text = self.malePlaylistArrayNew[3];
                break;
            case 2:
                cell.player1Label.text = self.femalePlaylistArrayNew[0];
                cell.player2Label.text = self.femalePlaylistArrayNew[2];
                cell.player3Label.text = self.malePlaylistArrayNew[0];
                cell.player4Label.text = self.malePlaylistArrayNew[4];
                break;
            case 3:
                cell.player1Label.text = self.malePlaylistArrayNew[1];
                cell.player2Label.text = self.malePlaylistArrayNew[2];
                cell.player3Label.text = self.malePlaylistArrayNew[3];
                cell.player4Label.text = self.malePlaylistArrayNew[4];
                cell.player1Label.textColor = [UIColor blueColor];
                cell.player2Label.textColor = [UIColor blueColor];
                cell.player3Label.textColor = [UIColor blueColor];
                cell.player4Label.textColor = [UIColor blueColor];
                break;
            case 4:
                cell.player1Label.text = self.femalePlaylistArrayNew[0];
                cell.player2Label.text = self.femalePlaylistArrayNew[1];
                cell.player3Label.text = self.malePlaylistArrayNew[1];
                cell.player4Label.text = self.malePlaylistArrayNew[2];
               
                break;
            case 5:
                cell.player1Label.text = self.femalePlaylistArrayNew[1];
                cell.player2Label.text = self.femalePlaylistArrayNew[2];
                cell.player3Label.text = self.malePlaylistArrayNew[0];
                cell.player4Label.text = self.malePlaylistArrayNew[3];
                break;
            case 6:
                cell.player1Label.text = self.femalePlaylistArrayNew[0];
                cell.player2Label.text = self.femalePlaylistArrayNew[2];
                cell.player3Label.text = self.malePlaylistArrayNew[4];
                cell.player4Label.text = self.malePlaylistArrayNew[1];
                break;
            case 7:
                cell.player1Label.text = self.malePlaylistArrayNew[0];
                cell.player2Label.text = self.malePlaylistArrayNew[2];
                cell.player3Label.text = self.malePlaylistArrayNew[3];
                cell.player4Label.text = self.malePlaylistArrayNew[4];
                cell.player1Label.textColor = [UIColor blueColor];
                cell.player2Label.textColor = [UIColor blueColor];
                cell.player3Label.textColor = [UIColor blueColor];
                cell.player4Label.textColor = [UIColor blueColor];
                break;
                
            default:
                break;
        }
    }else if (self.malePlaylistArrayNew.count == 4 && self.femalePlaylistArrayNew.count ==3) {
            switch (indexPath.row) {
                case 0:
                    cell.player1Label.text = self.femalePlaylistArrayNew[0][@"userName"];
                    cell.player2Label.text = self.femalePlaylistArrayNew[1][@"userName"];
                    cell.player3Label.text = self.malePlaylistArrayNew[0][@"userName"];
                    cell.player4Label.text = self.malePlaylistArrayNew[1][@"userName"];
                    break;
                case 1:
                    cell.player1Label.text = self.femalePlaylistArrayNew[1][@"userName"];
                    cell.player2Label.text = self.femalePlaylistArrayNew[2][@"userName"];
                    cell.player3Label.text = self.malePlaylistArrayNew[2][@"userName"];
                    cell.player4Label.text = self.malePlaylistArrayNew[3][@"userName"];
                    break;
                case 2:
                    cell.player1Label.text = self.femalePlaylistArrayNew[0][@"userName"];
                    cell.player2Label.text = self.femalePlaylistArrayNew[2][@"userName"];
                    cell.player3Label.text = self.malePlaylistArrayNew[0][@"userName"];
                    cell.player4Label.text = self.malePlaylistArrayNew[2][@"userName"];
                    break;
                case 3:
                    cell.player1Label.text = self.malePlaylistArrayNew[0][@"userName"];
                    cell.player2Label.text = self.malePlaylistArrayNew[1][@"userName"];
                    cell.player3Label.text = self.malePlaylistArrayNew[2][@"userName"];
                    cell.player4Label.text = self.malePlaylistArrayNew[3][@"userName"];
                    cell.player1Label.textColor = [UIColor blueColor];
                    cell.player2Label.textColor = [UIColor blueColor];
                    cell.player3Label.textColor = [UIColor blueColor];
                    cell.player4Label.textColor = [UIColor blueColor];
                    break;
                case 4:
                    cell.player1Label.text = self.femalePlaylistArrayNew[0][@"userName"];
                    cell.player2Label.text = self.femalePlaylistArrayNew[1][@"userName"];
                    cell.player3Label.text = self.malePlaylistArrayNew[2][@"userName"];
                    cell.player4Label.text = self.malePlaylistArrayNew[3][@"userName"];
                    break;
                case 5:
                    cell.player1Label.text = self.femalePlaylistArrayNew[1][@"userName"];
                    cell.player2Label.text = self.femalePlaylistArrayNew[2][@"userName"];
                    cell.player3Label.text = self.malePlaylistArrayNew[0][@"userName"];
                    cell.player4Label.text = self.malePlaylistArrayNew[1][@"userName"];
                    break;
                case 6:
                    cell.player1Label.text = self.femalePlaylistArrayNew[0][@"userName"];
                    cell.player2Label.text = self.femalePlaylistArrayNew[2][@"userName"];
                    cell.player3Label.text = self.malePlaylistArrayNew[1][@"userName"];
                    cell.player4Label.text = self.malePlaylistArrayNew[3][@"userName"];
                    break;
                case 7:
                    cell.player1Label.text = self.malePlaylistArrayNew[0][@"userName"];
                    cell.player2Label.text = self.malePlaylistArrayNew[1][@"userName"];
                    cell.player3Label.text = self.malePlaylistArrayNew[2][@"userName"];
                    cell.player4Label.text = self.malePlaylistArrayNew[3][@"userName"];
                    cell.player1Label.textColor = [UIColor blueColor];
                    cell.player2Label.textColor = [UIColor blueColor];
                    cell.player3Label.textColor = [UIColor blueColor];
                    cell.player4Label.textColor = [UIColor blueColor];
                    break;
                    
                default:
                    break;
            }
    }else if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==2) {
        switch (indexPath.row) {
            case 0:
                cell.player1Label.text = self.femalePlaylistArrayNew[0];
                cell.player2Label.text = self.femalePlaylistArrayNew[1];
                cell.player3Label.text = self.malePlaylistArrayNew[0];
                cell.player4Label.text = self.malePlaylistArrayNew[1];
                break;
            case 1:
                cell.player1Label.text = self.femalePlaylistArrayNew[0];
                cell.player2Label.text = self.femalePlaylistArrayNew[1];
                cell.player3Label.text = self.malePlaylistArrayNew[2];
                cell.player4Label.text = self.malePlaylistArrayNew[3];
                break;
            case 2:
                cell.player1Label.text = self.femalePlaylistArrayNew[0];
                cell.player2Label.text = self.femalePlaylistArrayNew[1];
                cell.player3Label.text = self.malePlaylistArrayNew[0];
                cell.player4Label.text = self.malePlaylistArrayNew[4];
                break;
            case 3:
                cell.player1Label.text = self.malePlaylistArrayNew[1];
                cell.player2Label.text = self.malePlaylistArrayNew[2];
                cell.player3Label.text = self.malePlaylistArrayNew[3];
                cell.player4Label.text = self.malePlaylistArrayNew[4];
                cell.player1Label.textColor = [UIColor blueColor];
                cell.player2Label.textColor = [UIColor blueColor];
                cell.player3Label.textColor = [UIColor blueColor];
                cell.player4Label.textColor = [UIColor blueColor];
                break;
                
            default:
                break;
        }

    }
    
    cell.gameNumberLabel.text = [NSString stringWithFormat:@"Game %li",indexPath.row+1];
    
    return cell;
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
