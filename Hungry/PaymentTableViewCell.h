//
//  PaymentTableViewCell.h
//  Hungry
//
//  Created by ioshero 10/5/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaymentTableViewCellDelegate
@optional
-(void) deletePayment: (int) nIndex;
@end


@interface PaymentTableViewCell : UITableViewCell
{
    
}

@property(weak, nonatomic) IBOutlet UILabel*            m_lblCardNumber;
@property(weak, nonatomic) IBOutlet UIButton*           m_btnDelete;
@property(retain, nonatomic) id                           delegate;

- (void) updatePayment: (PFObject*) objPayment;
- (void) editPayment: (BOOL) bEdit;

@end
