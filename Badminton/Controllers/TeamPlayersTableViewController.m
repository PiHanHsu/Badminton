//
//  TeamPlayersTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/22.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "TeamPlayersTableViewController.h"
#import "PlayerTableViewCell.h"

@interface TeamPlayersTableViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
@property BOOL hasMalePlayer;
@property BOOL hasFemalePlayer;
@property (strong, nonatomic) NSMutableArray * malePlayerArray;
@property (strong, nonatomic) NSMutableArray * femalePlayerArray;

@end

@implementation TeamPlayersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.malePlayerArray addObjectsFromArray: self.teamObject[@"malePlayers"]];
    [self.femalePlayerArray addObjectsFromArray: self.teamObject[@"femalePlayers"]];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    PFQuery * query = [PFQuery queryWithClassName:@"Team"];
    [query fromLocalDatastore];
    //[query whereKey:@"objectId" equalTo:self.teamObject.objectId];
    [query getObjectInBackgroundWithId:self.teamObject.objectId
                                 block:^(PFObject * obj, NSError *error) {
                                     
                                     obj[@"malePlayers"] = self.malePlayerArray;
                                     obj[@"femalePlayers"] = self.femalePlayerArray;
                                     [obj saveEventually];
                                     //[[PlayListDataSource sharedInstance] loadingTeamDataFromParse];
                                 }];
//    NSMutableArray * teamArray = [PlayListDataSource sharedInstance].teamArray;
//    for (PFObject * object in teamArray){
//        if ([object.objectId isEqualToString:self.teamObject.objectId]) {
//            object[@"malePlayers"] = self.malePlayerArray;
//            object[@"femalePlayers"] = self.femalePlayerArray;
//        }
//    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *) malePlayerArray {
    if(!_malePlayerArray)
        _malePlayerArray = [@[] mutableCopy];
    return _malePlayerArray;
}

- (NSMutableArray *) femalePlayerArray {
    if(!_femalePlayerArray)
        _femalePlayerArray = [@[] mutableCopy];
    return _femalePlayerArray;
}

- (IBAction)AddPlayer:(UIBarButtonItem *)sender {
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"請輸入新增球員姓名" delegate:self cancelButtonTitle:@"女子球員" otherButtonTitles:@"男子球員", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
        [self.femalePlayerArray addObject:[alertView textFieldAtIndex:0].text];
        self.teamObject[@"femalePlayers"] = self.femalePlayerArray;
        [self.tableView reloadData];
        
    }if (buttonIndex ==1) {
        [self.malePlayerArray addObject:[alertView textFieldAtIndex:0].text];
        self.teamObject[@"malePlayers"] = self.malePlayerArray;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.malePlayerArray.count > 0 && self.femalePlayerArray.count >0) {
        return 2;
    }else if (self.malePlayerArray.count > 0 && self.femalePlayerArray.count == 0){
        return 1;
    }else if (self.malePlayerArray.count == 0 && self.femalePlayerArray.count > 0){
        return 1;
    }else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.malePlayerArray.count;
            break;
            
        case 1:
            return self.femalePlayerArray.count;
            break;
            
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    tableView.sectionHeaderHeight = 44;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 288, 21)];
    if(section == 0)
        label.text = @"男子選手";
    else
        label.text = @"女子選手";
    
    label.font = [UIFont fontWithName:@"GraphikApp-Regular" size:13]; //[UIFont systemFontOfSize:13.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:142.0/255.0 green:142.0/255.0 blue:142.0/255.0 alpha:1.0];
    
    [headerView addSubview:label];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"forIndexPath:indexPath];
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.playerLabel.text = self.malePlayerArray[indexPath.row];
            break;
        case 1:
            cell.playerLabel.text = self.femalePlayerArray[indexPath.row];
            break;
            
        default:
            break;
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


// Override to support editing the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
       
        if (indexPath.section == 1) {
            //[tableView deleteRowsAtIndexPaths:self.femalePlayerArray[indexPath.row] withRowAnimation:UITableViewRowAnimationFade];
            [self.femalePlayerArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else if (indexPath.section == 0){
            [self.malePlayerArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
