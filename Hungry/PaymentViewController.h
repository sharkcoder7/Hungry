//
//  PaymentViewController.h
//  Hungry
//
//  Created by ioshero 9/26/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "BasePaymentViewController.h"

@interface PaymentViewController : BasePaymentViewController
{
    
}
@property(nonatomic, retain) id             m_returnView;

- (void) updateDeliveryLocation: (LocationInfo*) place;
@end
