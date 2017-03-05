//
//  SubDishTableViewCell.m
//  Hungry
//
//  Created by ioshero 9/28/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "SubDishTableViewCell.h"

@implementation SubDishTableViewCell

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
-(void) initMember
{
    self.m_lblPrice.layer.masksToBounds = YES;
    self.m_lblPrice.layer.cornerRadius = self.m_lblPrice.frame.size.width / 2.0f;
}

//====================================================================================================
@end
