//
//  PlayerListTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/16.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "PlayerListTableViewController.h"
#import "PlayerTableViewCell.h"
#import "PlayListDataSource.h"

@interface PlayerListTableViewController ()
@property (strong, nonatomic) NSArray * malePlayerArray;
@property (strong, nonatomic) NSArray * femalePlayerArray;

@property (strong, nonatomic) NSMutableArray * maleSelectedArray;
@property (strong, nonatomic) NSMutableArray * femaleSelectedArray;

@end

@implementation PlayerListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.malePlayerArray = @[@"蔣宜哲", @"曹智祥", @"張少豪", @"許丕翰", @"林奕廷"];
    self.femalePlayerArray = @[@"黃稚倫", @"楊千慧", @"鄭佳鳳"];
    
    for (NSString * name in self.malePlayerArray) {
         [[PlayListDataSource sharedInstance]addToMalePlayerList:name];
    }
    for (NSString * name in self.femalePlayerArray) {
        [[PlayListDataSource sharedInstance]addToFemalePlayerList:name];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *) maleSelectedArray {
    if(!_maleSelectedArray)
        _maleSelectedArray = [@[] mutableCopy];
    return _maleSelectedArray;
}

- (NSMutableArray *) femaleSelectedArray {
    if(!_femaleSelectedArray)
        _femaleSelectedArray = [@[] mutableCopy];
    return _femaleSelectedArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:243.0/255.0 alpha:1.0];
    tableView.sectionHeaderHeight = 44;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(headerView.bounds.origin.x+16, 16, 288, 21)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerTableViewCell" forIndexPath:indexPath];
    
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
    
    cell.switchButton.tag = indexPath.row;
    if (indexPath.section == 0) {
        [cell.switchButton addTarget:self action:@selector(addToMaleList:) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.section == 1){
        [cell.switchButton addTarget:self action:@selector(addToFemaleList:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (void) addToMaleList: (UISwitch *)sender{
    
    NSString * name = self.malePlayerArray[sender.tag];
    if ([sender isOn]) {
        [[PlayListDataSource sharedInstance]addToMalePlayerList:name];
    }else {
      [[PlayListDataSource sharedInstance]removeFromMalePlayerList:name];
    }
    
    //NSLog(@"Male List: %@", [PlayListDataSource sharedInstance].maleSelectedArray);
}

- (void) addToFemaleList: (UISwitch *)sender{
   
    NSString * name = self.femalePlayerArray[sender.tag];
    if ([sender isOn]) {
        [[PlayListDataSource sharedInstance]addToFemalePlayerList:name];
    }else {
        [[PlayListDataSource sharedInstance]removeFromFemalePlayerList:name];
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
