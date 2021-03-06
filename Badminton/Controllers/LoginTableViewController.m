//
//  LoginTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/22.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "LoginTableViewController.h"
#import <Parse.h>
//#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import "PlayListDataSource.h"
#import "MyTeamListTableViewController.h"
#import "DataSource.h"

@interface LoginTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *spaceView;
@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.width/320 *260);
    self.spaceView.frame = CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.width/320 *260 * 0.05);
    
    
    //set up indicator
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = self.view.center;
    self.indicator.hidden = YES;
    
    [self.view addSubview:self.indicator];
    
    //set up botton layout
    self.loginButton.layer.cornerRadius = 5.0;
    self.loginButton.clipsToBounds = YES;
    
    self.signUpButton.layer.borderWidth = 1.0f;
    self.signUpButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.signUpButton.layer.cornerRadius = 5.0;
    self.signUpButton.clipsToBounds = YES;
    
    //if currentUser, byPass Login
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        //[self _ViewControllerAnimated:YES];
        [self.indicator startAnimating];
        [[DataSource sharedInstance] loadTeamsFromServer];
    }
    
    //Go to next Page after get data
    [[NSNotificationCenter defaultCenter]
     addObserverForName:@"loadingDataFinished"
     object:nil
     queue:[NSOperationQueue mainQueue]
     usingBlock:^(NSNotification *notification) {
         if ([notification.name isEqualToString:@"loadingDataFinished"]) {
             NSLog(@"Loading Data Finished!");
             [self _ViewControllerAnimated:YES];
         }
     }];
    
}

- (void) viewDidDisappear:(BOOL)animated{
    [self.indicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)_ViewControllerAnimated:(BOOL)animated {
    
    //MyTeamListTableViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyTeamTableViewController"];
    UITabBarController * tabbarVC =[self.storyboard instantiateViewControllerWithIdentifier:@"TabbarViewController"];
    
    [tabbarVC setSelectedIndex:0];
    [self presentViewController:tabbarVC animated:YES completion:nil];
    
    //[self.navigationController pushViewController:vc animated:YES];
    //[self performSegueWithIdentifier:@"Show Home Screen" sender:nil];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

#pragma mark Login

- (IBAction)LoginPressed:(id)sender {
    
    [self.indicator startAnimating];
    [PFUser logInWithUsernameInBackground:[self.emailTextField.text lowercaseString]
                                 password:self.passwordTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            //[[PlayListDataSource sharedInstance] loadingTeamDataFromParse];
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
                                            self.emailTextField.text = @"";
                                            self.passwordTextField.text = @"";
                                        }
                                    }];
}

#pragma mark FB Login

- (IBAction)FBLogin:(UIButton *)sender {
    
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"email", @"user_relationships", @"user_birthday", @"user_location"];
    
    [self.indicator startAnimating];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
                [self saveUserDataToParse];
            } else {
                NSLog(@"User with facebook logged in!");
                [self.indicator stopAnimating];
                
                [[DataSource sharedInstance] loadTeamsFromServer];
            }
        }
        
    }];
    
}


-(void) saveUserDataToParse
{
    NSDictionary * params = @{@"fields": @"id, name, first_name, last_name, email, gender"};
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *firstName = userData[@"first_name"];
            NSString *lastName = userData[@"last_name"];
            NSString *email;
            if (userData[@"email"]) {
                email =userData[@"email"];
            }
            
            NSString *pictureURL =[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            NSString *gender =userData[@"gender"];
            
            [[PFUser currentUser] setObject:name forKey:@"name"];
            [[PFUser currentUser] setObject:firstName forKey:@"firstName"];
            [[PFUser currentUser] setObject:lastName forKey:@"lastName"];
            [[PFUser currentUser] setObject:facebookID forKey:@"facebookID"];
            [[PFUser currentUser] setObject:email forKey:@"email"];
            [[PFUser currentUser] setObject:pictureURL forKey:@"pictureURL"];
            [[PFUser currentUser] setObject:gender forKey:@"gender"];
            
            
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeed, NSError* error){
                if (!error){
                    
//                   [self performSegueWithIdentifier:@"Go to Sign up Page" sender:nil];
                    PFObject * player = [PFObject objectWithClassName:@"Player"];
                    player[@"userName"] = name;
                    player[@"nameForSearch"] = [name lowercaseString];
                    player[@"firstName"] = firstName;
                    player[@"firstNameForSearch"] = [firstName lowercaseString];
                    player[@"lastName"] = lastName;
                    player[@"lastNameForSearch"] = [lastName lowercaseString];
                    if ([gender isEqualToString:@"女性"]){
                        player[@"isMale"] = [NSNumber numberWithBool:NO];
                    }else{
                        player[@"isMale"] = [NSNumber numberWithBool:YES];
                    }
                    
                    player[@"user"] = [PFUser currentUser].objectId;
                    player[@"pictureUrl"] = pictureURL;
                    
                    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Create Your Account" message:@"You can use FB or this email/password to Login." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        UITextField *emailTextField = alert.textFields.firstObject;
                        UITextField *passwordTextField = alert.textFields.lastObject;
                       
                        [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (succeeded) {
                                PFUser * currentUser = [PFUser currentUser];
                                currentUser[@"username"] = emailTextField.text;
                                player[@"email"] = emailTextField.text;
                                currentUser[@"password"] = passwordTextField.text;
                                [currentUser saveInBackground];
                                [self _ViewControllerAnimated:YES];
                                
                            }
                        }];

                        [alert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    UIAlertAction * skip = [UIAlertAction actionWithTitle:@"Skip" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        [player saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (succeeded) {
                                [self _ViewControllerAnimated:YES];
                            }
                        }];

                        [alert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    
                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        if (email) {
                            textField.text = email;
                        }else
                        textField.placeholder = @"Email";
                    }];
                    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                        textField.placeholder = @"Enter Your Password";
                    }];
                    
                    [alert addAction:skip];
                    [alert addAction:ok];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
            }];
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            
        } else {
            NSLog(@"Some other error: %@", error);
        }
        
    }];
}

- (IBAction)forgotPasswordPressed:(id)sender {
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"請輸入email" message:@"重新設定密碼的連結將發送至您的email" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * textField) {
        if (self.emailTextField.text.length > 0) {
            textField.text = self.emailTextField.text;
        }else{
            textField.placeholder = @"E-mail";
        }
        
    }];
    
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    UITextField * emailTextField = alert.textFields.firstObject;
                                                    
                                                    [PFUser requestPasswordResetForEmailInBackground:[emailTextField.text lowercaseString] block:^(BOOL succeeded, NSError *error) {
                                                        
                                                        if(succeeded) {
                                                            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Please check your email and follow the instructions to reset your password."
                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                                            }];
                                                            
                                                            
                                                            [alert addAction:ok];
                                                            [self presentViewController:alert animated:YES completion:nil];
                                                        } else {
                                                            NSLog(@"%@", error);
                                                            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Oops Sorry!" message:@"We cannot find the email address. Please check you email again!"
                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                            UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                [alert dismissViewControllerAnimated:YES completion:nil];
                                                            }];
                                                            
                                                            
                                                            [alert addAction:ok];
                                                            [self presentViewController:alert animated:YES completion:nil];
                                                        }
                                                    }];
                                                    
                                                    
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action) {
                                                        
                                                        
                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                        
                                                    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}


@end
