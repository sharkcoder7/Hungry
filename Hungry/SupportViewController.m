//
//  SupportViewController.m
//  Hungry
//
//  Created by ioshero 10/5/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "SupportViewController.h"
#import <MessageUI/MessageUI.h>
@interface SupportViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SupportViewController

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
- (IBAction) actionEmail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Feedback on Hungry"];
        [mailViewController setToRecipients: [NSArray arrayWithObject: @"support@hungryishere.com"]];
        [self presentViewController: mailViewController animated: YES completion: nil];
    }
    
    else
    {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

//====================================================================================================
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error: (NSError*)error
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

//====================================================================================================
@end
