//
//  SignupTableViewController.m
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/23.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import "SignupTableViewController.h"
#import "PlayListDataSource.h"

@interface SignupTableViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UIActivityIndicatorView * indicator;
@end

@implementation SignupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.indicator.center = CGPointMake(160, self.view.frame.size.height/2);
    self.indicator.hidden = YES;
    
    //user login with FB
    if ([PFUser currentUser]) {
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

#pragma mark Sign up

- (IBAction)goPressed:(id)sender {
    [self.indicator startAnimating];
    if(![self isPasswordsMatch]) {
        //[self.activityIndicatorView stopAnimating];
        //[self.activityIndicatorView removeFromSuperview];
        return;
    }
    PFUser *user = [PFUser user];
    user.username = [self.emailTextField.text lowercaseString];
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    
    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.indicator stopAnimating];
            [self.indicator hidesWhenStopped];
            

        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
