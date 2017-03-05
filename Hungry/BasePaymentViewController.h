//
//  BasePaymentViewController.h
//  Hungry
//
//  Created by ioshero 10/13/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "BaseViewController.h"
#import "CardIO.h"
#import "PayPalMobile.h"

@interface BasePaymentViewController : BaseViewController <PayPalPaymentDelegate>

@end
