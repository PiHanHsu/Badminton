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
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

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
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
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
    
    
    //set up Photo Button
    self.photoButton.layer.borderWidth = 5.0f;
    self.photoButton.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    self.photoButton.layer.cornerRadius = 75.0;
    self.photoButton.clipsToBounds = YES;

    self.photoImageView.layer.borderWidth = 5.0f;
    self.photoImageView.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    self.photoImageView.layer.cornerRadius = 75.0;
    self.photoImageView.clipsToBounds = YES;
    
    PFFile * photo = currentPlayer[@"photo"];
    
    if (photo) {
        NSLog(@"url: %@",photo.url);

        NSURL * imageURL = [NSURL URLWithString:photo.url];
       
        
        [self.photoImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
//        [photo getDataInBackgroundWithBlock:^(NSData * imageData, NSError * error){
//           [self.photoButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
//        }];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"請輸入新密碼" message:@"修改密碼完成後請重新登入" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                       UITextField *pw1TextField = alert.textFields.firstObject;
                                                           
                                                           PFUser * user = [PFUser currentUser];
                                                           user.password = pw1TextField.text;
                                                           [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                                               if (succeeded) {
                                                                   [self logoutPressed:self.logoutButton];
                                                        }
                                                           }];
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        ok.enabled= NO;
        
        [alert addAction:cancel];
        [alert addAction:ok];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Enter New Password";
            textField.secureTextEntry = YES;
            [textField addTarget:self
                          action:@selector(alertTextFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Re-enter New Password";
            textField.secureTextEntry = YES;
            [textField addTarget:self
                          action:@selector(alertTextFieldDidChange:)
                forControlEvents:UIControlEventEditingChanged];
        }];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alert = (UIAlertController *)self.presentedViewController;
    if (alert) {
        UITextField *pw1TextField = alert.textFields.firstObject;
        
        UITextField *pw2TextField = alert.textFields.lastObject;
        UIAlertAction *ok = alert.actions.lastObject;
        
        if ([pw1TextField.text isEqualToString:pw2TextField.text]) {
            ok.enabled = YES;
        }else{
            ok.enabled = NO;
        }
    }
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
        NSData *imageData = UIImageJPEGRepresentation(self.photoImageView.image, 1.0);
        PFFile *photoFile = [PFFile fileWithData:imageData];
        PFQuery * query = [PFQuery queryWithClassName:@"Player"];
        [query whereKey:@"user" equalTo:[PFUser currentUser].objectId];
        
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *player, NSError * error){
            
            player[@"userName"] = self.userNameTextField.text;
            player[@"name"] = self.realNameTextField.text;
            player[@"email"] = self.emailTextField.text;
            player [@"photo"] = photoFile;
            
            PFUser * user = [PFUser currentUser];
            user[@"email"] = self.emailTextField.text;
            user[@"username"] = self.emailTextField.text;
            
            [user saveInBackground];
            [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"url: %@",photoFile.url);
                    //player[@"photoURL"] = photoFile.url;
                }
            }];
        }];
    }else{
        PFObject * currentPlayer = [DataSource sharedInstance].currentPlayer;
        currentPlayer[@"username"] = self.userNameTextField.text;
        currentPlayer[@"name"] = self.realNameTextField.text;
        currentPlayer[@"email"] = self.emailTextField.text;
        
        PFUser * user = [PFUser currentUser];
        user[@"email"] = self.emailTextField.text;
        user[@"userName"] = self.emailTextField.text;
        
        [user saveInBackground];
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
    self.photoImageView.image = photoImage;
    
    [self.photoButton setImage:photoImage forState:UIControlStateNormal];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photoPicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.photoPicker = nil;
}

- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
- (IBAction)logoutPressed:(id)sender {
    
    [PFUser logOut];
    [PFUser unpinAllObjects];
    [PFObject unpinAllObjects];
    
    UINavigationController * rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RootNavigatoinController"];
    [self presentViewController:rootVC animated:YES completion:nil];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
