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
#import "Team.h"
#import "DataSource.h"
#import "TeamListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>


@interface MyTeamListTableViewController ()<UIAlertViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, MGSwipeTableCellDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSString * teamName;
@property (strong, nonatomic) NSMutableArray * teamArray;
@property (strong, nonatomic) Team * teamObject;
@property (strong, nonatomic) UIImagePickerController *photoPicker;
@property (strong, nonatomic) UIImage * teamImage;
@property (assign, nonatomic) NSInteger tempIndex;
@property (strong, nonatomic) Player * currentPlayer;
@property (strong, nonatomic) UIPickerView *sportsTypePickerView;
@property (strong, nonatomic) NSArray * sportsTypePickerData;


@end

@implementation MyTeamListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentPlayer = [DataSource sharedInstance].currentPlayer;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.rowHeight = 120;
    
    self.tempIndex = -1;
    
    self.teamArray = [DataSource sharedInstance].teamArray;
    if (self.teamArray.count == 0 ) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"請新增一個球隊，或請隊友將您加入現有球隊" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
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

- (IBAction)photoButtonPressed:(MGSwipeButton *)sender {
    
    //UIButton *button = (MGSwipeButton *)sender;
    self.tempIndex = sender.tag;
    
    UIAlertController * view = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* fromCamera = [UIAlertAction
                                 actionWithTitle:@"開啟相機"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)]) {
                                         
                                         [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                                         
                                     }
                                     
                                     
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
    UIAlertAction* fromAlbum = [UIAlertAction
                                actionWithTitle:@"從相機膠卷選取"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                                        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                                    }
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"取消"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [view addAction:fromCamera];
    [view addAction:fromAlbum];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - PickerView Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 3;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.sportsTypePickerData[component][row];
}

- (IBAction)AddTeam:(id)sender {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"選擇球賽類別"
                                  message:@"\n\n\n\n\n "
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"新增" style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   UITextField *nameTextField = alert.textFields.firstObject;
                                                   
                                                   Team * teamObject = [Team createTeam];
                                                   teamObject[@"name"] = nameTextField.text;
                                                   teamObject[@"createBy"] = [NSString stringWithFormat:@"%@", [PFUser currentUser].objectId];
                                                   NSInteger row = [self.sportsTypePickerView selectedRowInComponent:0];
                                                   teamObject[@"sportsType"] = self.sportsTypePickerData[0][row];
                                                   teamObject[@"isDeleted"] = [NSNumber numberWithBool:NO];
                                                   teamObject[@"players"] = [@[self.currentPlayer] mutableCopy];
                                                   [[DataSource sharedInstance] addTeam:teamObject];
                                                   
                                                   [self.tableView reloadData];
                                                   [teamObject saveInBackground];
                                                   
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    self.sportsTypePickerData = @[@[@"羽    球", @"網    球", @"桌    球"]];

    
    self.sportsTypePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(50, 30, 170, 120)];
    //self.sportsTypePickerView = [[UIPickerView alloc]init];
    self.sportsTypePickerView.delegate = self;
    self.sportsTypePickerView.dataSource = self;
 
    [alert.view addSubview:self.sportsTypePickerView];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"輸入球隊名稱";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    //[self.sportsTypePickerView selectRow:0 inComponent:0 animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.teamArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTeamListCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.teamName.text = self.teamArray[indexPath.row][@"name"];
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"退出\n球隊" backgroundColor:[UIColor redColor]],
                          [MGSwipeButton buttonWithTitle:@"編輯\n名稱" backgroundColor:[UIColor lightGrayColor]],[MGSwipeButton buttonWithTitle:@"編輯\n照片" backgroundColor:[UIColor lightGrayColor]]];
    
    cell.rightSwipeSettings.transition = MGSwipeTransition3D;
    cell.delegate = self;
    
    
    [cell.photoButton addTarget:self action:@selector(photoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoButton.tag = indexPath.row;
    
    
    cell.teamImage.layer.cornerRadius = 50.0f;
    cell.teamImage.clipsToBounds = YES;
    
    if (indexPath.row == self.tempIndex) {
        cell.teamImage.image = self.teamImage;
    }else{
        if (self.teamArray[indexPath.row][@"photo"]) {
            PFFile * photo = self.teamArray[indexPath.row][@"photo"];
            if (photo) {
                
                NSURL * imageURL = [NSURL URLWithString:photo.url];
                [cell.teamImage setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"team_placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
    }

        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.teamObject = self.teamArray[indexPath.row];
    
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


-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    switch (index) {
        case 0:{
            //delete team = remove myself from this team
            Team * teamToBeDelete = self.teamArray[indexPath.row];
            [teamToBeDelete deletePlayer:self.currentPlayer];
            
            [[DataSource sharedInstance].teamArray removeObject:self.teamArray[indexPath.row]];
            
            [self refreshData];
            return YES;
            break;
        }
            
        case 1:{
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"修改球隊名稱"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           UITextField *nameTextField = alert.textFields.firstObject;
                                                           self.teamArray[indexPath.row][@"name"] = nameTextField.text;
                                                           
                                                           [self.tableView reloadData];
                                                           Team *teamObject = self.teamArray[indexPath.row];
                                                           [teamObject pinInBackground];
                                                           [teamObject saveInBackground];
                                                           
                                                       }];
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                                           }];
            
            [alert addAction:ok];
            [alert addAction:cancel];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.text = self.teamArray[indexPath.row][@"name"];
            }];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return YES;
        }
           
        case 2:{
            
            
            MGSwipeButton * button = cell.rightButtons[2];
            button.tag = indexPath.row;
            [self photoButtonPressed:button];
            return YES;
        }
            
        default:
            break;
    }
    
    
    return YES;
}

#pragma mark - refresh Data
- (void)refreshData{
    self.teamArray = [DataSource sharedInstance].teamArray;
    [self.tableView reloadData];
    
}

#pragma mark image picker delegate

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.sourceType = sourceType;
    photoPicker.delegate = self;
    photoPicker.allowsEditing = YES;
    photoPicker.showsCameraControls = YES;
    
    self.photoPicker = photoPicker;
    [self presentViewController:self.photoPicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *photoImage = info[@"UIImagePickerControllerOriginalImage"];
    self.teamImage = photoImage;

    
    [self.tableView reloadData];
    
    [self updateTeamPhoto];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photoPicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.photoPicker = nil;
}

- (void)updateTeamPhoto{
    
    CGRect rect = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect.size );
    [self.teamImage drawInRect:rect];
    UIImage * teamImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(teamImage, 1.0);
    PFFile *photoFile = [PFFile fileWithData:imageData];
    Team * team = self.teamArray[self.tempIndex];
    
    
    PFQuery * query = [PFQuery queryWithClassName:@"Team"];
    [query fromLocalDatastore];
    [query whereKey:@"objectId" equalTo:team.objectId];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *team, NSError * error){
        if (error) {
            NSLog(@"error: %@", error);
        }else{
            team[@"photo"] = photoFile;
            [team saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (!error) {
                    self.tempIndex = -1;
                }else {
                    NSLog(@"error: %@", error);
                }
            }];
        }
    }];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[TeamPlayersTableViewController class]]) {
        TeamPlayersTableViewController * vc = segue.destinationViewController;
        vc.teamObject = self.teamObject;
        
    }

    
}


@end
