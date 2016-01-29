//
//  ProfileTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/30.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "LoginTableViewController.h"
#import <Parse/Parse.h>
#import "Player.h"
#import "DataSource.h"

@interface ProfileTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) Player * currentPlayer;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) UIBarButtonItem *editBarButton;
@property (strong, nonatomic) UIBarButtonItem *cancelBarButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) UIImage * photoImage;
@property (strong, nonatomic) UIImagePickerController *photoPicker;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;

@property (assign) BOOL isEditState;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFObject * currentPlayer = [DataSource sharedInstance].currentPlayer;
    self.userNameLabel.text = currentPlayer[@"userName"];
    self.userNameTextField.text = currentPlayer[@"userName"];
    self.realNameTextField.text = currentPlayer[@"name"];
    self.emailTextField.text = currentPlayer[@"email"];
    
    PFFile * photo = currentPlayer[@"photo"];
    if (photo) {
        [photo getDataInBackgroundWithBlock:^(NSData * imageData, NSError * error){
           [self.photoButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        }];
    }
    self.userNameTextField.enabled = NO;
    self.realNameTextField.enabled = NO;
    self.emailTextField.enabled = NO;
    [self.photoButton setUserInteractionEnabled:NO];
    self.cameraImage.hidden = YES;
    
    //set up Photo Button
    self.photoButton.layer.borderWidth = 5.0f;
    self.photoButton.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    self.photoButton.layer.cornerRadius = 75.0;
    self.photoButton.clipsToBounds = YES;
    
    [self.photoButton addTarget:self action:@selector(addPhtotButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //set barButton
    
    self.editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnPressed:)];
    self.navigationItem.rightBarButtonItem = self.editBarButton;
    
    self.cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnPressed:)];
    self.navigationItem.leftBarButtonItem = nil;
    
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

#pragma mark - IBActions
- (void)cancelBtnPressed:(UIBarButtonItem *)button {
    [self setEditState:NO showKeyboard:NO];
    
}
- (IBAction)editBtnPressed:(UIBarButtonItem *)button {
    NSString *currentState = button.title;
    
    if( [currentState isEqualToString:@"Edit"]) {
        [self setEditState:YES showKeyboard:YES];
    } else {
        [self setEditState:NO showKeyboard:NO];
        [self.userNameTextField resignFirstResponder];
        [self.realNameTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        
        [self updateProfile];
    }
}

- (void)updateProfile{
    
    if (self.photoButton.imageView.image) {
        NSData *imageData = UIImageJPEGRepresentation(self.photoButton.imageView.image, 1.0);
        PFFile *photoFile = [PFFile fileWithData:imageData];
        PFQuery * query = [PFQuery queryWithClassName:@"Player"];
        [query whereKey:@"user" equalTo:[PFUser currentUser].objectId];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *player, NSError * error){
            
            player[@"userName"] = self.userNameTextField.text;
            player[@"name"] = self.realNameTextField.text;
            player[@"email"] = self.emailTextField.text;
            player [@"photo"] = photoFile;
            
            [player saveInBackground];
        }];
    }else{
        PFObject * currentPlayer = [DataSource sharedInstance].currentPlayer;
        currentPlayer[@"userName"] = self.userNameTextField.text;
        currentPlayer[@"name"] = self.realNameTextField.text;
        currentPlayer[@"email"] = self.emailTextField.text;
        
        [currentPlayer saveInBackground];
    }
}

#pragma mark - Handle BarButtonItem states

- (void)enableInteraction:(BOOL) enabled {
    
    self.userNameTextField.enabled = enabled;
    self.realNameTextField.enabled = enabled;
    self.emailTextField.enabled = enabled;
    [self.photoButton setUserInteractionEnabled:enabled];
    
}

- (void)setEditState:(BOOL) isEditState showKeyboard:(BOOL)shouldShowKeyboard{
    self.isEditState = isEditState;
    
    if(isEditState) {
        
        self.cancelBarButton.enabled = YES;
        self.cameraImage.hidden = NO;
        self.navigationItem.leftBarButtonItem = self.cancelBarButton;
        
        self.editBarButton.title = @"Done";
        
        [self enableInteraction:YES];
        
        if(shouldShowKeyboard)
            [self.userNameTextField becomeFirstResponder];
    } else {
        self.cancelBarButton.enabled = NO;
        self.cameraImage.hidden = YES;
        self.navigationItem.leftBarButtonItem = nil;
        
        self.editBarButton.title = @"Edit";
        
        [self enableInteraction:NO];
    }
}

#pragma mark image picker delegate

- (IBAction)addPhtotButtonPressed:(id)sender {
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

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.sourceType = sourceType;
    photoPicker.delegate = self;
    
    self.photoPicker = photoPicker;
    [self presentViewController:self.photoPicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *photoImage = info[@"UIImagePickerControllerOriginalImage"];
    [self.photoButton setImage:photoImage forState:UIControlStateNormal];
    //self.updatedPhotoImage = photoImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photoPicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.photoPicker = nil;
}


- (IBAction)logoutPressed:(id)sender {
    
    [PFUser logOut];
    [PFUser unpinAllObjects];
    [PFObject unpinAllObjects];
    
    UINavigationController * rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RootNavigatoinController"];
    [self presentViewController:rootVC animated:YES completion:nil];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
