//
//  ProfileViewController.m
//  Hungry
//
//  Created by ioshero 10/4/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UIActionSheetDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    BOOL            m_bEditFlag;
    BOOL            m_bChangedProfileImage;
}

@property (weak, nonatomic) IBOutlet UIButton *m_btnEdit;
@property (weak, nonatomic) IBOutlet UITextField *m_txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *m_txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *m_txtPhone;

@end

@implementation ProfileViewController

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
- (void) initMember
{
    [super initMember];
    
    m_bEditFlag = NO;
    m_bChangedProfileImage = NO;
    
    [self enableEditing: NO];
    
    if([[PFUser currentUser] valueForKey: @"first_name"] != nil)
    {
        self.m_txtFirstName.text = [[PFUser currentUser] valueForKey: @"first_name"];
    }
    
    if([[PFUser currentUser] valueForKey: @"last_name"] != nil)
    {
        self.m_txtLastName.text = [[PFUser currentUser] valueForKey: @"last_name"];
    }

    if([[PFUser currentUser] valueForKey: @"phone"] != nil)
    {
        self.m_txtPhone.text = [[PFUser currentUser] valueForKey: @"phone"];
    }

    self.m_txtEmail.text = [PFUser currentUser].email;
}

//====================================================================================================
- (void) hideKeyboard
{
    [self.m_txtFirstName resignFirstResponder];
    [self.m_txtLastName resignFirstResponder];
    [self.m_txtEmail resignFirstResponder];
    [self.m_txtPhone resignFirstResponder];
}

//====================================================================================================
- (void) enableEditing: (BOOL) bEnable
{
    self.m_txtFirstName.enabled = bEnable;
    self.m_txtLastName.enabled = bEnable;
    self.m_txtEmail.enabled = bEnable;
    self.m_txtPhone.enabled = bEnable;
}

//====================================================================================================
- (IBAction)actionSignOut:(id)sender
{
    [self hideKeyboard];
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated: YES];
}

//====================================================================================================
- (IBAction) actionEdit:(id)sender
{
    m_bEditFlag = !m_bEditFlag;
    if(m_bEditFlag)
    {
        [self.m_btnEdit setTitle: @"Done" forState: UIControlStateNormal];
        [self enableEditing: YES];
    }
    else
    {
        [PFUser currentUser].email = self.m_txtEmail.text;
        [[PFUser currentUser] setObject: self.m_txtFirstName.text forKey: @"first_name"];
        [[PFUser currentUser] setObject: self.m_txtLastName.text forKey: @"last_name"];
        [[PFUser currentUser] setObject: self.m_txtPhone.text forKey: @"phone"];
        [[PFUser currentUser] saveInBackground];
        
        [self.m_btnEdit setTitle: @"Edit" forState: UIControlStateNormal];
        [self enableEditing: NO];
    }
}

//====================================================================================================
@end
