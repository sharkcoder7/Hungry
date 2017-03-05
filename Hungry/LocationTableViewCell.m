//
//  LocationTableViewCell.m
//  Hungry
//
//  Created by ioshero 9/28/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

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
-(void) updateLocation: (LocationInfo*) dicLocation
{
    self.m_lblTitle.text = dicLocation.title;
    self.m_lblAddress.text = dicLocation.address;
}

//====================================================================================================
@end

