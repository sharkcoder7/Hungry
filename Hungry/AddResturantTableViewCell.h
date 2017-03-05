//
//  AddResturantTableViewCell.h
//  Hungry
//
//  Created by ioshero 11/2/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddResturantTableViewCellDelegate
@optional
- (void) beginEditing;
- (void) endEditing;
- (void) filterWithRestaurantName: (NSString*) restaurantName;
@end

@interface AddResturantTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    
}

@property(weak, nonatomic) IBOutlet UITextField      *m_txtRestaurantName;
@property(nonatomic, retain) id             delegate;

@end
