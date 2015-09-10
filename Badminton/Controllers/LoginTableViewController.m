//
//  LoginTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/22.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "LoginTableViewController.h"
#import <Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FBSDKCoreKit.h>
#import "PlayListDataSource.h"
#import "MyTeamListTableViewController.h"
#import "DataSource.h"

@interface LoginTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0){
        self.navigationController.navigationBarHidden = YES;
        self.tableView.frame = CGRectMake(0, -20,  320, 480);
    }
    
    //set up indicator
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.center = CGPointMake(160, 190);
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
        [self.indicator startAnimating];
         //[[PlayListDataSource sharedInstance] loadingTeamDataFromParse];
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
    NSArray *permissionsArray = @[@"email"];
    [self.indicator startAnimating];
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
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
                //[[PlayListDataSource sharedInstance] loadingTeamDataFromParse];
                
                [self saveUserDataToParse];
            } else {
                NSLog(@"User with facebook logged in!");
                [self.indicator stopAnimating];
                //[[PlayListDataSource sharedInstance] loadingTeamDataFromParse];
                [[DataSource sharedInstance] loadTeamsFromServer];
            }
        }
    }];
    
}


-(void) saveUserDataToParse
{
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *email =userData[@"email"];
            NSString *pictureURL =[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            NSString *gender =userData[@"gender"];
            
            [[PFUser currentUser] setObject:name forKey:@"name"];
            //[[PFUser currentUser] setObject:facebookID forKey:@"facebookID"];
            [[PFUser currentUser] setObject:email forKey:@"email"];
            [[PFUser currentUser] setObject:pictureURL forKey:@"pictureURL"];
            [[PFUser currentUser] setObject:gender forKey:@"gender"];
            
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeed, NSError* error){
                if (!error){
                   [self performSegueWithIdentifier:@"Go to Sign up Page" sender:nil];
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


@end
