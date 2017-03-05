//
//  CreateProfileViewController.m
//  Hungry
//
//  Created by ioshero 10/4/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "CreateProfileViewController.h"
#import "AppSettings.h"
#import "PaymentViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "SignInViewController.h"

@interface CreateProfileViewController () <UITextFieldDelegate>
{
    float               m_fLastOffset;
}
@property (weak, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (weak, nonatomic) IBOutlet UITextField *m_txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPassword;
@property (weak, nonatomic) IBOutlet UIButton    *m_btnBack;
@property (weak, nonatomic) IBOutlet UIToolbar   *m_toolBar;

@end

@implementation CreateProfileViewController
@synthesize m_nPrevViewIndex;

//====================================================================================================
- (void)viewDidLoad {
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
- (void) initMember
{
    [super initMember];
    
    [self.m_scrollView setContentSize: CGSizeMake(self.m_scrollView.contentSize.width, 700.0f)];
    
    [self.m_txtFirstName setInputAccessoryView: self.m_toolBar];
    [self.m_txtLastName setInputAccessoryView: self.m_toolBar];
    [self.m_txtEmail setInputAccessoryView: self.m_toolBar];
    [self.m_txtPhone setInputAccessoryView: self.m_toolBar];
    [self.m_txtPassword setInputAccessoryView: self.m_toolBar];
}

//====================================================================================================
- (IBAction)actionLoginWithFB:(id)sender
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"basic_info"];
    [SVProgressHUD showWithStatus: @"Logging With Facebook..."];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error)
     {
         [SVProgressHUD dismiss];
         if (!user)
         {
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
             return;
         }
         else
         {
             if (user.isNew)
             {
                 NSLog(@"User with facebook signed up and logged in!");
             }
             else
             {
                 NSLog(@"User with facebook logged in!");
             }
             
             [self gotoNextView];
         }
     }];
}

//====================================================================================================
- (IBAction)actionCreateProfile:(id)sender
{
    NSString* firstName = self.m_txtFirstName.text;
    NSString* lastName = self.m_txtLastName.text;
    NSString* email = self.m_txtEmail.text;
    NSString* phone = self.m_txtPhone.text;
    NSString* password = self.m_txtPassword.text;
    
    if(email == nil || [email length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid Email."];
        return;
    }

    if(password == nil || [password length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid Password."];
        return;
    }

    PFUser* user = [PFUser user];
    user.email = email;
    user.username = email;
    user.password = password;
    
    if(firstName != nil && [firstName length] > 0)
    {
        [user setObject: firstName forKey: @"first_name"];
    }
    
    if(lastName != nil && [lastName length] > 0)
    {
        [user setObject: lastName forKey: @"last_name"];
    }
    
    if(phone != nil && [phone length] > 0)
    {
        [user setObject: phone forKey: @"phone"];
    }
    
    [SVProgressHUD show];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [SVProgressHUD dismiss];
         if (!error)
         {
             [self gotoNextView];
         }
         else
         {
             NSLog(@"error = %@", error);
             if(error.code == 100)
             {
                 [[AppDelegate getDelegate] showMessage: @"No internet connection. Please check your connection and try again."];
             }
             else
             {
                 [[AppDelegate getDelegate] showMessage: [error.userInfo valueForKey: @"error"]];
             }
             
             return;
         }
     }];
}

//====================================================================================================
- (IBAction) actionSignIn: (id) sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *nextView = (SignInViewController *)[storyboard instantiateViewControllerWithIdentifier:@"sign_in_view"];
    nextView.m_nPrevViewIndex = self.m_nPrevViewIndex;
    nextView.m_returnParentView = self.m_returnParentView;
    nextView.m_orderView = self.m_orderView;
    [self.navigationController pushViewController: nextView animated: YES];
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
        [self.navigationController popViewControllerAnimated: YES];
    }
}

#pragma mark -
#pragma mark UITextField Delegate.

//====================================================================================================
- (IBAction) actionInputDone:(id)sender
{
    [self hideKeyboard];
}

//====================================================================================================
- (void) hideKeyboard
{
    [self.m_txtFirstName resignFirstResponder];
    [self.m_txtLastName resignFirstResponder];
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtPhone resignFirstResponder];
    [self.m_txtPassword resignFirstResponder];
}

//====================================================================================================
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//====================================================================================================
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    m_fLastOffset = self.m_scrollView.contentOffset.y;
    [self.m_scrollView setContentOffset: CGPointMake(0, textField.tag * 80.0f) animated: YES];
}

//====================================================================================================
-(void) textFieldDidEndEditing:(UITextField *)textField
{
//    [self.m_scrollView setContentOffset: CGPointMake(0, m_fLastOffset) animated: YES];
}

//====================================================================================================

@end
