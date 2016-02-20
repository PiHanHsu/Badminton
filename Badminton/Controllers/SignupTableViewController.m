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

@interface SignupTableViewController ()<UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@property (strong, nonatomic) UIImagePickerController *photoPicker;
@property (strong, nonatomic) PFUser * currentUser;
@property (strong, nonatomic) NSString * userId;


@end

@implementation SignupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indicator.center = CGPointMake(160, self.view.frame.size.height/2);
    self.indicator.hidden = YES;
    self.photoImageView.layer.cornerRadius = 5.0;
    self.photoImageView.clipsToBounds = YES;
    self.currentUser = [PFUser currentUser];
    //    switch (self.genderSegmentedControl.selectedSegmentIndex) {
    //        case 0:
    //            self.photoImageView.image = [UIImage imageNamed:@"male Player"];
    //            break;
    //        case 1:
    //            self.photoImageView.image = [UIImage imageNamed:@"female Player"];
    //            break;
    //        default:
    //            break;
    //    }
    
    //user login with FB
    if (self.currentUser) {
        NSLog(@"currentUser!!");
        self.nameTextField.text = [PFUser currentUser][@"name"];
        self.emailTextField.text = [PFUser currentUser][@"email"];
        NSString *userProfilePhotoURLString = [PFUser currentUser][@"pictureURL"];
        if (userProfilePhotoURLString) {
            NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                       if (connectionError == nil && data != nil) {
                                           self.photoImageView.image = [UIImage imageWithData:data];
                                           self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
                                           self.photoImageView.layer.cornerRadius = 5.0f;
                                           self.photoImageView.clipsToBounds = YES;
                                           
                                       } else {
                                           NSLog(@"Failed to load profile photo.");
                                       }
                                   }];
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

- (IBAction)goPressed:(id)sender {
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
        NSData *imageData = UIImageJPEGRepresentation(self.photoImageView.image, 1.0);
        PFFile *photoFile = [PFFile fileWithData:imageData];
        PFObject * player = [PFObject objectWithClassName:@"Player"];
        player[@"name"] = self.nameTextField.text;
        player[@"nameForSearch"] = [self.nickNameTextField.text lowercaseString];
        player[@"isMale"] = [NSNumber numberWithBool:self.isMale];
        player[@"userName"] = self.nickNameTextField.text;
        player[@"email"] =self.emailTextField.text;
        
        player[@"user"] = self.userId;
        player [@"photo"] = photoFile;
        
        [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                [self signUpSuccess];
                
            }
        }];
    }else{
        PFObject * player = [PFObject objectWithClassName:@"Player"];
        player[@"name"] = self.nameTextField.text;
        player[@"isMale"] = [NSNumber numberWithBool:self.isMale];
        player[@"userName"] = self.nickNameTextField.text;
        player[@"nameForSearch"] = [self.nickNameTextField.text lowercaseString];
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
                                            UIAlertView * av = [[UIAlertView alloc]
                                                                initWithTitle:@"Oops, Sorry!"
                                                                message:@"Can not login. Please Try Again."
                                                                delegate:self
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil, nil];
                                            [av show];
                                            [self.indicator stopAnimating];
                                            self.nickNameTextField.text = @"";
                                            self.nameTextField.text = @"";
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
        self.goButton.enabled = NO;
    else
        self.goButton.enabled = YES;
    
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
    
    NSArray *textFieldArray = @[self.nickNameTextField,self.nameTextField,self.emailTextField,self.passwordTextField,self.reTypePasswordTextField];
    
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
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Empty Password"
                                                     message:@"Please type your password."
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    } else if([self isTextFieldInputEmpty:self.reTypePasswordTextField]) {
        [self.reTypePasswordTextField becomeFirstResponder];
        UIAlertView *av = [[UIAlertView alloc]
                           initWithTitle:@"Empty Password"
                           message:@"Please type your password."
                           delegate:self
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil];
        [av show];
    }
    else {
        if([self.passwordTextField.text isEqualToString:self.reTypePasswordTextField.text])
            isPasswordsMatch = YES;
        else {
            self.reTypePasswordTextField.text = nil;
            [self.reTypePasswordTextField becomeFirstResponder];
            UIAlertView *av = [[UIAlertView alloc]
                               initWithTitle:@"Passwords Not Match"
                               message:@"Please retype your password."
                               delegate:self
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
            [av show];
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
