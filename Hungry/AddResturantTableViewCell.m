//
//  AddResturantTableViewCell.m
//  Hungry
//
//  Created by ioshero 11/2/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "AddResturantTableViewCell.h"

@implementation AddResturantTableViewCell
@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSString* strName = self.m_txtRestaurantName.text;
    if(strName != nil && [strName length] > 0)
    {
        if ([(id)delegate respondsToSelector:@selector(filterWithRestaurantName:)])
        {
            [delegate filterWithRestaurantName: strName];
        }
    }
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if ([(id)delegate respondsToSelector:@selector(beginEditing)])
    {
        [delegate beginEditing];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if ([(id)delegate respondsToSelector:@selector(endEditing)])
    {
        [delegate endEditing];
    }
}


@end
