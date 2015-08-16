//
//  GameScheduleTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "GameScheduleTableViewController.h"
#import "GameScheduleTableViewCell.h"
@interface GameScheduleTableViewController ()

@end

@implementation GameScheduleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    [self shuffleList];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==3) {
        
    }else if (self.malePlaylistArrayNew.count == 4 && self.femalePlaylistArrayNew.count ==3){
        
    }else if (self.malePlaylistArrayNew.count == 5 && self.femalePlaylistArrayNew.count ==2){
    }else{
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Oops Sorry！" message:@"Please reselcet the players." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * okAlertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:okAlertAction];
        [self presentViewController:alert animated:YES completion:nil];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender {

[self.navigationController popViewControllerAnimated:YES];
}

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
- (IBAction)refreshButtonPressed:(id)sender {
    [self.malePlaylistArrayNew removeAllObjects];
    [self.femalePlaylistArrayNew removeAllObjects];
    [self shuffleList];
}

- (void) shuffleList{
    
    int n1 = (int)self.malePlaylistArray.count;
    
    for (int i = 0;  i < n1 ; i++) {
        int m = (int)self.malePlaylistArray.count;
        int r = arc4random_uniform(m);
        [self.malePlaylistArrayNew addObject:self.malePlaylistArray[r]];
        [self.malePlaylistArray removeObject:self.malePlaylistArray[r]];
        if (i == n1-1) {
            [self.malePlaylistArray addObjectsFromArray:self.malePlaylistArrayNew];
            [self.tableView reloadData];
        }
    }
    
    int n2 = (int)self.femalePlaylistArray.count;
    
    for (int i = 0;  i < n2 ; i++) {
        int m = (int)self.femalePlaylistArray.count;
        int r = arc4random_uniform(m);
        [self.femalePlaylistArrayNew addObject:self.femalePlaylistArray[r]];
        [self.femalePlaylistArray removeObject:self.femalePlaylistArray[r]];
        if (i == n2-1) {
            [self.femalePlaylistArray addObjectsFromArray:self.femalePlaylistArrayNew];
            [self.tableView reloadData];

        }
    }
 
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
                break;
                
            default:
                break;
        }
    }else if (self.malePlaylistArrayNew.count == 4 && self.femalePlaylistArrayNew.count ==3) {
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
                    cell.player4Label.text = self.malePlaylistArrayNew[2];
                    break;
                case 3:
                    cell.player1Label.text = self.malePlaylistArrayNew[0];
                    cell.player2Label.text = self.malePlaylistArrayNew[1];
                    cell.player3Label.text = self.malePlaylistArrayNew[2];
                    cell.player4Label.text = self.malePlaylistArrayNew[3];
                    break;
                case 4:
                    cell.player1Label.text = self.femalePlaylistArrayNew[0];
                    cell.player2Label.text = self.femalePlaylistArrayNew[1];
                    cell.player3Label.text = self.malePlaylistArrayNew[2];
                    cell.player4Label.text = self.malePlaylistArrayNew[3];
                    break;
                case 5:
                    cell.player1Label.text = self.femalePlaylistArrayNew[1];
                    cell.player2Label.text = self.femalePlaylistArrayNew[2];
                    cell.player3Label.text = self.malePlaylistArrayNew[0];
                    cell.player4Label.text = self.malePlaylistArrayNew[1];
                    break;
                case 6:
                    cell.player1Label.text = self.femalePlaylistArrayNew[0];
                    cell.player2Label.text = self.femalePlaylistArrayNew[2];
                    cell.player3Label.text = self.malePlaylistArrayNew[1];
                    cell.player4Label.text = self.malePlaylistArrayNew[3];
                    break;
                case 7:
                    cell.player1Label.text = self.malePlaylistArrayNew[0];
                    cell.player2Label.text = self.malePlaylistArrayNew[1];
                    cell.player3Label.text = self.malePlaylistArrayNew[2];
                    cell.player4Label.text = self.malePlaylistArrayNew[3];
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
                break;
                
            default:
                break;
        }

    }
    
    
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
