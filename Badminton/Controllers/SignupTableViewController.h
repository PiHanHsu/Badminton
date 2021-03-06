//
//  SignupTableViewController.h
//  Badminton
//
//  Created by PiHan Hsu on 2015/8/23.
//  Copyright (c) 2015年 PiHan Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayListDataSource.h"


@interface SignupTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *reTypePasswordTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (assign, nonatomic) BOOL isMale;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *signUpBarButton;

@end
