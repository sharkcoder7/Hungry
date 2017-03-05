//
//  ResetPasswordViewController.m
//  Hungry
//
//  Created by ioshero 11/9/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController () <UITextFieldDelegate>
{
    
}

@property (nonatomic, weak) IBOutlet UITextField            *m_txtEmail;

@end

@implementation ResetPasswordViewController

//====================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//====================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
- (IBAction) actionReset:(id)sender
{
    NSString* email = self.m_txtEmail.text;
    if(email == nil || [email length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid Email."];
        return;
    }
    
    [SVProgressHUD showWithStatus: @"Please wait..."];
    [PFUser requestPasswordResetForEmailInBackground: email block:^(BOOL succeeded, NSError* error)
     {
         [SVProgressHUD dismiss];
         NSString* strMessage = @"";
         if(succeeded)
         {
             strMessage = @"Please check your email for instructions to reset your password";
         }
         else
         {
             strMessage = @"Email doesn't exists in our database";
         }
         
         [[AppDelegate getDelegate] showMessage: strMessage];
         return;
     }];
}

#pragma mark - 
#pragma mark UITextField Delegate.

//====================================================================================================
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//====================================================================================================
@end
