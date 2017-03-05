//
//  PaymentTableViewCell.m
//  Hungry
//
//  Created by ioshero 10/5/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell
@synthesize delegate;

//====================================================================================================
- (void)awakeFromNib
{
    // Initialization code
}

//====================================================================================================
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//====================================================================================================
- (void) updatePayment: (PFObject*) objPayment
{
    NSString* strNewCardNumber = @"";
    NSString* strCardNumber = [objPayment valueForKey: @"card_number"];
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
    
    self.m_lblCardNumber.text = [NSString stringWithFormat: @"%@", strNewCardNumber];
}

//====================================================================================================
- (void) editPayment: (BOOL) bEdit
{
    self.m_btnDelete.hidden = !bEdit;
}

//====================================================================================================
- (IBAction) actionDelete:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(deletePayment:)])
    {
        [delegate deletePayment: (int)self.tag];
    }
}

//====================================================================================================
@end
