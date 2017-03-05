//
//  PaymentViewController.m
//  Hungry
//
//  Created by ioshero 9/26/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "PaymentViewController.h"
#import "LocationViewController.h"
#import "MapViewController.h"
#import "MainViewController.h"

@interface PaymentViewController () <UITextFieldDelegate>
{
    float                   m_fCurOffset;
}

@property (weak, nonatomic) IBOutlet UIScrollView   *m_scrollMainView;
@property (weak, nonatomic) IBOutlet UIScrollView   *m_scrollPriceView;
@property (weak, nonatomic) IBOutlet UIView         *m_viewMain;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblTotal;
@property (weak, nonatomic) IBOutlet UIView         *m_viewCardNumber;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtCardNumber;
@property (weak, nonatomic) IBOutlet UIView         *m_viewSub1;
@property (weak, nonatomic) IBOutlet UIView         *m_viewSub2;
@property (weak, nonatomic) IBOutlet UIView         *m_viewSub3;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtSub1;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtSub2;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtSub3;
@property (weak, nonatomic) IBOutlet UIView         *m_viewLocation;
@property (weak, nonatomic) IBOutlet UIView         *m_viewPhone;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblLocation;
@property (weak, nonatomic) IBOutlet UITextField    *m_txtPhone;
@property (weak, nonatomic) IBOutlet UIToolbar      *m_toolBar;
@property (weak, nonatomic) IBOutlet UIImageView    *m_imgCardType;

@property (retain, nonatomic) LocationInfo*     m_selectedLoc;

@end

@implementation PaymentViewController

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
    
    self.m_viewSub1.layer.masksToBounds = YES;
    self.m_viewSub1.layer.cornerRadius = 5.0f;
    
    self.m_viewSub2.layer.masksToBounds = YES;
    self.m_viewSub2.layer.cornerRadius = 5.0f;
    
    self.m_viewSub3.layer.masksToBounds = YES;
    self.m_viewSub3.layer.cornerRadius = 5.0f;
    
    self.m_viewLocation.layer.masksToBounds = YES;
    self.m_viewLocation.layer.cornerRadius = 5.0f;
    
    self.m_viewPhone.layer.masksToBounds = YES;
    self.m_viewPhone.layer.cornerRadius = 5.0f;
    
    [self.m_scrollMainView setContentSize: CGSizeMake(self.m_scrollMainView.contentSize.width, 770.0f)];
    
    [self.m_txtCardNumber setInputAccessoryView: self.m_toolBar];
    [self.m_txtPhone setInputAccessoryView: self.m_toolBar];
    [self.m_txtSub1 setInputAccessoryView: self.m_toolBar];
    [self.m_txtSub2 setInputAccessoryView: self.m_toolBar];
    [self.m_txtSub3 setInputAccessoryView: self.m_toolBar];
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(hideKeyboard)];
    [self.view addGestureRecognizer: gesture];
    
    //fill out user information.
    if([[PFUser currentUser] valueForKey: @"phone"] != nil)
    {
        self.m_txtPhone.text = [[PFUser currentUser] valueForKey: @"phone"];
    }
    
    [self fillPayment];
}

//====================================================================================================
- (void) fillPayment
{
    PFQuery* query = [PFQuery queryWithClassName: @"Payment"];
    [query whereKey: @"user_id" equalTo: [PFUser currentUser].objectId];
    [query orderByDescending: @"createdAt"];    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(objects != nil && [objects count] > 0)
        {
            PFObject* obj = [objects firstObject];
            self.m_imgCardType.image = [UIImage imageNamed: @"visa_card.png"];
            self.m_txtCardNumber.text = [self getSecureCardNumber: [obj valueForKey: @"card_number"]];
            self.m_txtSub1.text = [obj valueForKey: @"cvv"];
            self.m_txtSub2.text = [obj valueForKey: @"expire_date"];
            self.m_txtSub3.text = [obj valueForKey: @"zip"];
        }
    }];
}

//====================================================================================================
- (NSString*) getSecureCardNumber: (NSString*) strCardNumber
{
    NSString* strNewCardNumber = @"";
    if(strCardNumber != nil && [strCardNumber length] > 4)
    {
        for(int i = 0; i < [strCardNumber length] - 4; i++)
        {
            strNewCardNumber = [strNewCardNumber stringByAppendingString: @"*"];
        }
        strNewCardNumber = [strNewCardNumber stringByAppendingString: [strCardNumber substringFromIndex: [strCardNumber length] - 4]];
    }
    else
    {
        strNewCardNumber = strCardNumber;
    }
    
    return strNewCardNumber;
}

//====================================================================================================
- (void) updateDeliveryLocation: (LocationInfo*) place
{
    self.m_selectedLoc = place;
    
    BOOL bExist = NO;
    for(int i = 0; i < [[AppDelegate getDelegate].m_arrRecentLocList count]; i++)
    {
        LocationInfo* loc = [[AppDelegate getDelegate].m_arrRecentLocList objectAtIndex: i];
        if([loc.placeID isEqualToString: place.placeID])
        {
            bExist = YES;
            break;
        }
    }
    
    if(!bExist)
    {
        [[AppDelegate getDelegate].m_arrRecentLocList addObject: place];
        [[AppDelegate getDelegate] saveGlobalInfo];
    }
    
    self.m_lblLocation.text = place.address;
}

//====================================================================================================
- (IBAction)actionGoogleMap:(id)sender
{
    if(self.m_selectedLoc == nil) return;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *nextView = (MapViewController *)[storyboard instantiateViewControllerWithIdentifier:@"map_view"];
    nextView.m_selectedPlace = self.m_selectedLoc;
    [self.navigationController pushViewController: nextView animated: YES];
}

//====================================================================================================
- (IBAction)actionLocation:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationViewController *nextView = (LocationViewController *)[storyboard instantiateViewControllerWithIdentifier:@"location_view"];
    nextView.m_parentView = self;
    [self.navigationController pushViewController: nextView animated: YES];
}

//====================================================================================================
- (IBAction)actionCall:(id)sender
{
    
}

//====================================================================================================
- (IBAction)actionOrder:(id)sender
{
    if(![self.m_txtPhone.text isEqualToString: [[PFUser currentUser] valueForKey: @"phone"]])
    {
        [[PFUser currentUser] setObject: self.m_txtPhone.text forKey: @"phone"];
        [[PFUser currentUser] saveInBackground];
    }
    
    PFQuery* query = [PFQuery queryWithClassName: @"Payment"];
    [query whereKey: @"card_number" equalTo: self.m_txtCardNumber.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(objects != nil && [objects count] > 0)
        {
            PFObject* objPayment = [objects firstObject];
            [objPayment setObject: self.m_txtSub1.text forKey: @"cvv"];
            [objPayment setObject: self.m_txtSub2.text forKey: @"expire_date"];
            [objPayment setObject: self.m_txtSub3.text forKey: @"zip"];
            [objPayment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [self gotoNextView];
            }];
        }
        else
        {
            PFObject* objPayment = [PFObject objectWithClassName: @"Payment"];
            [objPayment setObject: self.m_txtCardNumber.text forKey: @"card_number"];
            [objPayment setObject: self.m_txtSub1.text forKey: @"cvv"];
            [objPayment setObject: self.m_txtSub2.text forKey: @"expire_date"];
            [objPayment setObject: self.m_txtSub3.text forKey: @"zip"];
            [objPayment setObject: [PFUser currentUser].objectId forKey: @"user_id"];
            [objPayment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                [self gotoNextView];
            }];
        }
    }];
    
}

//====================================================================================================
- (void) gotoNextView
{
    [(MainViewController*)[AppDelegate getDelegate].m_mainViewController showDeliveryView];
    [self.navigationController popToViewController: [AppDelegate getDelegate].m_mainViewController animated: YES];
}


#pragma mark -
#pragma mark UITextField Delegate.

//====================================================================================================
- (IBAction) hideKeyboard
{
    [self.m_txtSub1 resignFirstResponder];
    [self.m_txtSub2 resignFirstResponder];
    [self.m_txtSub3 resignFirstResponder];
    [self.m_txtCardNumber resignFirstResponder];
    [self.m_txtPhone resignFirstResponder];
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
    m_fCurOffset = self.m_scrollMainView.contentOffset.y;
    
    if(textField == self.m_txtCardNumber)
    {
        [self.m_scrollMainView setContentOffset: CGPointMake(0, 200.0f) animated: YES];
    }
    else if(textField == self.m_txtSub1 || textField == self.m_txtSub2 || textField == self.m_txtSub3)
    {
        [self.m_scrollMainView setContentOffset: CGPointMake(0, 250.0f) animated: YES];
    }
    else if(textField == self.m_txtPhone)
    {
        [self.m_scrollMainView setContentOffset: CGPointMake(0, 450.0f) animated: YES];
    }
}

//====================================================================================================
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    [self.m_scrollMainView setContentOffset: CGPointMake(0, m_fCurOffset) animated: YES];
}

#pragma mark -
#pragma mar Payment.
//====================================================================================================
- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController
{
    // The full card number is available as info.cardNumber, but don't log that!
    NSLog(@"Received card info. Number: %@, expiry: %02i/%i, cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv);
    
    self.m_txtCardNumber.text = info.redactedCardNumber;
    self.m_txtSub1.text = info.cvv;
    self.m_txtSub2.text = [NSString stringWithFormat: @"%02i/%i", info.expiryMonth, info.expiryYear];
    
    // Use the card info...
    [scanViewController dismissViewControllerAnimated: YES completion: nil];
}

//====================================================================================================
- (IBAction) actionBack:(id)sender
{
    if(self.m_returnView != nil)
    {
        [self.navigationController popToViewController: self.m_returnView animated: YES];
    }
    else
    {
        [super actionBack: sender];
    }
}

//====================================================================================================
@end
