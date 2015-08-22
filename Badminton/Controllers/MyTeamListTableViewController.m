//
//  MyTeamListTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/22.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "MyTeamListTableViewController.h"
#import "MyTeamListTableViewCell.h"
#import "TeamPlayersTableViewController.h"
#import "PlayListDataSource.h"


@interface MyTeamListTableViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString * teamName;
@property (strong, nonatomic) NSMutableArray * teamArray;

@end

@implementation MyTeamListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 120;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self updateDataFromParse];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *) teamArray {
    if(!_teamArray)
        _teamArray = [@[] mutableCopy];
    return _teamArray;
}


- (IBAction)AddTeam:(id)sender {
    
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:nil message:@"請輸入球隊名稱" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"新增", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   if (buttonIndex ==1) {
       
       PFObject * teamObject = [PFObject objectWithClassName:@"Team"];
       teamObject[@"name"] = [alertView textFieldAtIndex:0].text;
       teamObject[@"createBy"] = [NSString stringWithFormat:@"%@", [PFUser currentUser].objectId];
       
       
       [teamObject saveInBackgroundWithBlock:^(BOOL succeed, NSError * error){
           if (succeed) {
             [self updateDataFromParse];
               
           }
       }];
    }
}

-(void) updateDataFromParse{
    
    PFQuery * query = [PFQuery queryWithClassName:@"Team"];
    [query whereKey:@"createBy" equalTo:@"NHOifOc9iQ"];
    [query findObjectsInBackgroundWithBlock:
     ^(NSArray * objects, NSError *error){
         if (!error) {
             NSLog(@"hihi");
             [self.teamArray removeAllObjects];
             [self.teamArray addObjectsFromArray:objects];
             [self.tableView reloadData];
             NSLog(@"rows: %lu", (unsigned long)self.teamArray.count);
         }else{
             NSLog(@"error: %@" ,error);
         }
         
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.teamArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyTeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTeamListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.teamName.text = self.teamArray[indexPath.row][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.teamName = self.teamArray[indexPath.row][@"name"];
    [self performSegueWithIdentifier:@"Show Team Players" sender:nil];
    
//    TeamPlayersTableViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamPlayersTableViewController"];
//    vc.teamName = self.teamName;
//    [self.navigationController pushViewController:vc animated:YES];
   
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[TeamPlayersTableViewController class]]) {
        TeamPlayersTableViewController * vc = segue.destinationViewController;
        vc.teamName = self.teamName;
        
    }

    
}


@end
