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
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface ProfileTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) UIImage * updateImage;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (strong, nonatomic) UIBarButtonItem *editBarButton;
@property (strong, nonatomic) UIBarButtonItem *cancelBarButton;


@property (strong, nonatomic) UIImagePickerController *photoPicker;
@property (strong, nonatomic) Player * currentPlayer;

@property (assign) BOOL isEditState;
@property (assign) BOOL isMale;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    PFObject * currentPlayer = [DataSource sharedInstance].currentPlayer;
    self.userNameLabel.text = currentPlayer[@"userName"];
    self.userNameTextField.text = currentPlayer[@"userName"];
    self.firstNameTextField.text = currentPlayer[@"firstName"];
    self.lastNameTextField.text = currentPlayer[@"lastName"];
    self.emailTextField.text = currentPlayer[@"email"];
    if ([currentPlayer[@"isMale"] boolValue]) {
        self.isMale = YES;
        self.genderSegmentedControl.selectedSegmentIndex = 0;
    }else{
        self.isMale = NO;
        self.genderSegmentedControl.selectedSegmentIndex = 1;
    }
    //set up Photo Button
    self.photoButton.layer.borderWidth = 5.0f;
    self.photoButton.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    self.photoButton.layer.cornerRadius = 75.0;
    self.photoButton.clipsToBounds = YES;
    
    self.photoImageView.layer.borderWidth = 5.0f;
    self.photoImageView.layer.borderColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor;
    self.photoImageView.layer.cornerRadius = 75.0;
    self.photoImageView.clipsToBounds = YES;
    
    
    [self.photoButton addTarget:self action:@selector(addPhtotButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // set up image
    if (currentPlayer[@"pictureUrl"]) {
        NSString * url = currentPlayer[@"pictureUrl"];
        NSURL * imageURL = [NSURL URLWithString:url];
        [self.photoImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }else{
        PFFile * photo = currentPlayer[@"photo"];
        if (photo) {
            NSLog(@"url: %@",photo.url);
            NSURL * imageURL = [NSURL URLWithString:photo.url];
            [self.photoImageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"user_placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
    
    // set  text fields enable status
    self.userNameTextField.enabled = NO;
    self.firstNameTextField.enabled = NO;
    self.lastNameTextField.enabled = NO;
    self.emailTextField.enabled = NO;
    self.genderSegmentedControl.enabled = NO;
    [self.photoButton setUserInteractionEnabled:NO];
    self.cameraImage.hidden = YES;
    
    //set barButton
    
    self.editBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnPressed:)];
    self.navigationItem.rightBarButtonItem = self.editBarButton;
    
    self.cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnPressed:)];
    self.navigationItem.leftBarButtonItem = nil;
    
    // set logout button
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.logoutButton.layer.cornerRadius = 5.0f;
    self.logoutButton.clipsToBounds = YES;
    
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
    
    return 5;
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
        [self.firstNameTextField resignFirstResponder];
        [self.lastNameTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        
        [self updateProfile];
    }
}

- (void)updateProfile{
    if (self.genderSegmentedControl.selectedSegmentIndex == 0) {
        self.isMale = YES;
    }else
        self.isMale = NO;
    
    PFObject * currentPlayer = [DataSource sharedInstance].currentPlayer;
    currentPlayer[@"userName"] = self.userNameTextField.text;
    currentPlayer[@"firstName"] = self.firstNameTextField.text;
    currentPlayer[@"lastName"] = self.lastNameTextField.text;
    currentPlayer[@"isMale"] = [NSNumber numberWithBool:self.isMale];
    
    if (self.photoButton.imageView.image) {
        CGRect rect = CGRectMake(0,0,450,450);
        UIGraphicsBeginImageContext( rect.size );
        [self.photoImageView.image drawInRect:rect];
        UIImage * userPhoto = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImageJPEGRepresentation(userPhoto, 1.0);
        PFFile *photoFile = [PFFile fileWithData:imageData];
        
        currentPlayer[@"photo"] = photoFile;
        
        [currentPlayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                PFFile * photo = currentPlayer[@"photo"];
                currentPlayer[@"pictureUrl"] = photo.url;
                [currentPlayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        [self checkEmail];
                    }
                }];
            }
        }];
        
    }else{
        [currentPlayer saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self checkEmail];
            }
        }];
    }
    
}

- (void)checkEmail{
    
    PFUser * user = [PFUser currentUser];
    PFObject * currentPlayer = [DataSource sharedInstance].currentPlayer;
    
    if (![self.emailTextField.text isEqualToString:user[@"email"]]){
        currentPlayer[@"email"] = self.emailTextField.text;
        user[@"email"] = self.emailTextField.text;
        user[@"username"] = self.emailTextField.text;
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Account Updated!!" message:@"Please Login again." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self logoutPressed:self.logoutButton];
                    [alert dismissViewControllerAnimated:alert completion:nil];
                }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
}

#pragma mark - Handle BarButtonItem states

- (void)enableInteraction:(BOOL) enabled {
    
    self.userNameTextField.enabled = enabled;
    self.firstNameTextField.enabled = enabled;
    self.lastNameTextField.enabled = enabled;
    self.emailTextField.enabled = enabled;
    self.genderSegmentedControl.enabled = enabled;
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
    
    FBSDKLoginManager * loginManager = [[FBSDKLoginManager alloc]init];
    [loginManager logOut];
    
    
    [PFUser unpinAllObjects];
    [PFObject unpinAllObjects];
    [PFUser logOut];
    
    UINavigationController * rootVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RootNavigatoinController"];
    [self presentViewController:rootVC animated:YES completion:nil];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
