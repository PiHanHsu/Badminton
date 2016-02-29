//
//  SignupTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/23.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "SignupTableViewController.h"
#import "PlayListDataSource.h"
#import "MyTeamListTableViewController.h"
#import "DataSource.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface SignupTableViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@property (strong, nonatomic) UIImagePickerController *photoPicker;
@property (strong, nonatomic) PFUser * currentUser;
@property (strong, nonatomic) NSString * userId;


@end

@implementation SignupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.signUpBarButton.enabled = NO;
    self.indicator.center = CGPointMake(160, self.view.frame.size.height/2);
    self.indicator.hidden = YES;
    [self.nickNameTextField becomeFirstResponder];
    self.photoImageView.layer.cornerRadius = 5.0;
    self.photoImageView.clipsToBounds = YES;
    self.currentUser = [PFUser currentUser];
    
    //user login with FB
    if (self.currentUser) {
        NSLog(@"currentUser!!");
        self.firstNameTextField.text = [PFUser currentUser][@"firstName"];
        self.lastNameTextField.text = [PFUser currentUser][@"lastName"];
        self.emailTextField.text = [PFUser currentUser][@"email"];
        NSString *userProfilePhotoURLString = [PFUser currentUser][@"pictureURL"];
        if ([PFUser currentUser][@"gender"]) {
            NSString * gender = [PFUser currentUser][@"gender"];
            if ([gender isEqualToString:@"女性"]){
                self.isMale = NO;
                self.genderSegmentedControl.selectedSegmentIndex = 1;
            }else{
                self.isMale = YES;
                self.genderSegmentedControl.selectedSegmentIndex = 0;
            }

        }
        
        if (userProfilePhotoURLString) {
            NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
            [self.photoImageView setImageWithURL:pictureURL placeholderImage:[UIImage imageNamed:@"user_placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
    
    // textfield delegate
    self.nickNameTextField.delegate = self;
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.reTypePasswordTextField.delegate = self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

#pragma mark image picker delegate
- (IBAction)changePhotoButtonPressed:(id)sender {
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
    photoPicker.allowsEditing = YES;
    photoPicker.showsCameraControls = YES;
    
    self.photoPicker = photoPicker;
    [self presentViewController:self.photoPicker animated:YES completion:nil];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    UIImage *photoImage = info[@"UIImagePickerControllerOriginalImage"];
    self.photoImageView.image = photoImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    self.photoPicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.photoPicker = nil;
}

#pragma mark Sign up
- (IBAction)signUpPressed:(id)sender {
    [self.indicator startAnimating];
    
    if (self.genderSegmentedControl.selectedSegmentIndex == 0) {
        self.isMale = YES;
    }else
        self.isMale = NO;
    
    if (self.currentUser) {
        self.currentUser.username = [self.emailTextField.text lowercaseString];
        self.currentUser.password = self.passwordTextField.text;
        self.currentUser.email = self.emailTextField.text;
        [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                self.userId = self.currentUser.objectId;
                [self createPlayerData];
            }
        }];
        
    }else{
        PFUser *user = [PFUser user];
        user.username = [self.emailTextField.text lowercaseString];
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                self.userId = user.objectId;
                [self createPlayerData];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"sign up error: %@", errorString);
                
                //TODO: add "invalid email" error message
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Oops Sorry!!" message:@"Something went wrong, can't sign up now. Please try agian later!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }];
        
    }

}



-(void) createPlayerData{
    if (self.photoImageView.image) {
        
        PFObject * player = [PFObject objectWithClassName:@"Player"];
        player[@"userName"] = self.nickNameTextField.text;
        player[@"nameForSearch"] = [self.nickNameTextField.text lowercaseString];
        player[@"isMale"] = [NSNumber numberWithBool:self.isMale];
        player[@"firstName"] = self.firstNameTextField.text;
        player[@"firstNameForSearch"] = [self.firstNameTextField.text lowercaseString];
        player[@"lastName"] = self.lastNameTextField.text;
        player[@"lastNameForSearch"] = [self.lastNameTextField.text lowercaseString];
        player[@"email"] =self.emailTextField.text;
        player[@"user"] = self.userId;
        
        if (self.currentUser) {
            player[@"pictureUrl"] = self.currentUser[@"pictureURL"];
            
            //TODO, BUG, if FB login, can't save player, error: invalid session token
            [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    [self signUpSuccess];
                }
            }];
        }else{
            //resize Image
            CGRect rect = CGRectMake(0,0,450,450);
            UIGraphicsBeginImageContext( rect.size );
            [self.photoImageView.image drawInRect:rect];
            UIImage * userPhoto = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSData *imageData = UIImageJPEGRepresentation(userPhoto, 1.0);
            PFFile *photoFile = [PFFile fileWithData:imageData];

            player [@"photo"] = photoFile;
            [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                                        PFFile * photo = player[@"photo"];
                    NSString * imageUrl = photo.url;
                    player[@"pictureUrl"] = imageUrl;
                    [player saveInBackground];
                }
            }];

        }
        
    }else{
        PFObject * player = [PFObject objectWithClassName:@"Player"];
        player[@"userName"] = self.nickNameTextField.text;
        player[@"nameForSearch"] = [self.nickNameTextField.text lowercaseString];
        player[@"isMale"] = [NSNumber numberWithBool:self.isMale];
        player[@"firstName"] = self.firstNameTextField.text;
        player[@"firstNameForSearch"] = [self.firstNameTextField.text lowercaseString];
        player[@"lastName"] = self.lastNameTextField.text;
        player[@"lastNameForSearch"] = [self.lastNameTextField.text lowercaseString];
        player[@"email"] =self.emailTextField.text;
        player[@"user"] = self.currentUser.objectId;
        
        [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self signUpSuccess];
                
            }
        }];
    }
    
    
}

-(void) signUpSuccess{
    
    
    
    [PFUser logInWithUsernameInBackground:[self.emailTextField.text lowercaseString]
                                 password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            [[DataSource sharedInstance] loadTeamsFromServer];
                                        } else {
                                            
                                            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Oops, Sorry!" message:@"Can not login. Please Try Again." preferredStyle:UIAlertControllerStyleAlert];
                                            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                            }];
                                            
                                            [self.indicator stopAnimating];
                                            self.nickNameTextField.text = @"";
                                            self.firstNameTextField.text = @"";
                                            self.lastNameTextField.text = @"";
                                            self.emailTextField.text = @"";
                                            self.passwordTextField.text = @"";
                                            self.reTypePasswordTextField.text = @"";
                                         }
                                    }];
    
   }

#pragma mark textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if( [self hasEmptyFieldExcept:textField newString:newString])
        self.signUpBarButton.enabled = NO;
    else
        self.signUpBarButton.enabled = YES;
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [self.tableView viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}
-(BOOL) hasEmptyFieldExcept:(UITextField *) textFieldInEdit newString:(NSString *) newString {
    
    BOOL hasEmptyField = NO;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    NSArray *textFieldArray = @[self.nickNameTextField,self.firstNameTextField,self.lastNameTextField,self.emailTextField,self.passwordTextField,self.reTypePasswordTextField];
    
    for( UITextField *oneTextField in textFieldArray) {
        if(oneTextField != textFieldInEdit )
            hasEmptyField = hasEmptyField || [self isTextFieldInputEmpty:oneTextField];
        else {
            hasEmptyField = hasEmptyField || ([[newString stringByTrimmingCharactersInSet:whitespace] length] == 0);
        }
    }
    
    
    return hasEmptyField;
}


- (BOOL) isPasswordsMatch {
    BOOL isPasswordsMatch = NO;
    
    if([self isTextFieldInputEmpty:self.passwordTextField]) {
        [self.passwordTextField becomeFirstResponder];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Empty Password" message:@"Please type your password." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if([self isTextFieldInputEmpty:self.reTypePasswordTextField]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Empty Password" message:@"Please type your password." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else {
        if([self.passwordTextField.text isEqualToString:self.reTypePasswordTextField.text])
            isPasswordsMatch = YES;
        else {
            self.reTypePasswordTextField.text = nil;
            [self.reTypePasswordTextField becomeFirstResponder];
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Passwords Not Match" message:@"Please retype your password." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    
    return isPasswordsMatch;
}

- (BOOL) isTextFieldInputEmpty:(UITextField*)textField {
    BOOL isEmpty = NO;
    
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if((textField.text == nil) || ([[textField.text stringByTrimmingCharactersInSet:whitespace] length] == 0)) {
        isEmpty = YES;
    }
    
    return isEmpty;
}

@end
