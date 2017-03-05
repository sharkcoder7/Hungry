//
//  AddPaymentViewController.m
//  Hungry
//
//  Created by ioshero 10/5/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "AddPaymentViewController.h"
#import "CardIO.h"

@interface AddPaymentViewController () <UITextFieldDelegate, CardIOPaymentViewControllerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIView         *m_viewCardNumber;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtCardNumber;
@property (weak, nonatomic) IBOutlet UIView         *m_viewCVV;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtCVV;
@property (weak, nonatomic) IBOutlet UIView         *m_viewExpire;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtExpire;
@property (weak, nonatomic) IBOutlet UIView         *m_viewZip;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtZip;
@property (weak, nonatomic) IBOutlet UIToolbar      *m_toolBar;

@end

@implementation AddPaymentViewController

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
    
    self.m_viewCardNumber.layer.masksToBounds = YES;
    self.m_viewCardNumber.layer.cornerRadius = 5.0f;
    
    self.m_viewCVV.layer.masksToBounds = YES;
    self.m_viewCVV.layer.cornerRadius = 5.0f;
    
    self.m_viewExpire.layer.masksToBounds = YES;
    self.m_viewExpire.layer.cornerRadius = 5.0f;
    
    self.m_viewZip.layer.masksToBounds = YES;
    self.m_viewZip.layer.cornerRadius = 5.0f;
    
    [self.m_txtCardNumber setInputAccessoryView: self.m_toolBar];
    [self.m_txtCVV setInputAccessoryView: self.m_toolBar];
    [self.m_txtExpire setInputAccessoryView: self.m_toolBar];
    [self.m_txtZip setInputAccessoryView: self.m_toolBar];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(hideKeyboard)];
    [self.view addGestureRecognizer: gesture];
}

#pragma mark - 
#pragma mark UITextField Delegate.

//====================================================================================================
- (IBAction) hideKeyboard
{
    [self.m_txtCardNumber resignFirstResponder];
    [self.m_txtCVV resignFirstResponder];
    [self.m_txtExpire resignFirstResponder];
    [self.m_txtZip resignFirstResponder];
}

#pragma mark -
#pragma mark Scan Your Card.

//====================================================================================================
- (IBAction)actionScanYourCard:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
//    scanViewController.appToken = CARD_IO_APP_TOKEN;
    [self presentViewController: scanViewController animated: YES completion: nil];
}

//====================================================================================================
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated: YES completion: nil];
}

//====================================================================================================
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    
    self.m_txtCardNumber.text = info.redactedCardNumber;
    self.m_txtCVV.text = info.cvv;
    self.m_txtExpire.text = [NSString stringWithFormat: @"%02i/%i", info.expiryMonth, info.expiryYear];
    
    // Use the card info...
    [scanViewController dismissViewControllerAnimated: YES completion: nil];
}

//====================================================================================================
- (IBAction) actionSave:(id)sender
{
    NSString* cardNumber = self.m_txtCardNumber.text;
    NSString* ccv = self.m_txtCVV.text;
    NSString* expireDate = self.m_txtExpire.text;
    NSString* zip = self.m_txtZip.text;
    
    if(cardNumber == nil || [cardNumber length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid Card Number."];
        return;
    }

    if(ccv == nil || [ccv length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid CVV."];
        return;
    }
    
    if(expireDate == nil || [expireDate length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid Expire Date."];
        return;
    }
    
    if(zip == nil || [zip length] <= 0)
    {
        [[AppDelegate getDelegate] showMessage: @"Please Input Valid Zip Code."];
        return;
    }
    
    PFQuery* query = [PFQuery queryWithClassName: @"Payment"];
    [query whereKey: @"user_id" equalTo: [PFUser currentUser].objectId];
    [query whereKey: @"card_number" equalTo: cardNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(objects != nil && [objects count] > 0)
        {
            [[AppDelegate getDelegate] showMessage: @"Exist Card number already."];
            return;
        }
        
        PFObject* objPayment = [PFObject objectWithClassName: @"Payment"];
        [objPayment setObject: [PFUser currentUser].objectId forKey: @"user_id"];
        [objPayment setObject: cardNumber forKey: @"card_number"];
        [objPayment setObject: ccv forKey: @"cvv"];
        [objPayment setObject: expireDate forKey: @"expire_date"];
        [objPayment setObject: zip forKey: @"zip"];
        
        [SVProgressHUD show];
        [objPayment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             [SVProgressHUD dismiss];
             [self.navigationController popViewControllerAnimated: YES];
         }];
    }];
}

//====================================================================================================
@end
