//
//  SignInViewController.m
//  Hungry
//
//  Created by ioshero 11/3/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "SignInViewController.h"
#import "PaymentViewController.h"

@interface SignInViewController ()
{
    
}
@property (weak, nonatomic) IBOutlet UITextField *m_txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPassword;

@end

@implementation SignInViewController
@synthesize m_nPrevViewIndex;

//====================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
}

//====================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
- (IBAction)actionSignIn:(id)sender
{
    NSString* username = self.m_txtUsername.text;
    NSString* password = self.m_txtPassword.text;
    
    if(username == nil || [username length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid Username."];
        return;
    }
    
    if(password == nil || [password length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid Password."];
        return;
    }
    
    [SVProgressHUD show];
    [PFUser logInWithUsernameInBackground: username password: password block:^(PFUser *user, NSError *error)
    {
        [SVProgressHUD dismiss];
        if (user) // Login successful
        {
            [self gotoNextView];
        }
        else
        {
            if(error.code == 100)
            {
                [[AppDelegate getDelegate] showMessage: @"No internet connection. Please check your connection and try again."];
            }
            else
            {
                [[AppDelegate getDelegate] showMessage: [error.userInfo valueForKey: @"error"]];
            }
            
        }
    }];
}

//====================================================================================================
- (void) gotoNextView
{
    if(m_nPrevViewIndex == ORDER_VIEW)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PaymentViewController *nextView = (PaymentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"confirm_view"];
        nextView.m_returnView = self.m_orderView;
        [self.navigationController pushViewController: nextView animated: YES];
    }
    else
    {
        [self.navigationController popToViewController: self.m_returnParentView animated: YES];
    }
}

//====================================================================================================

@end
