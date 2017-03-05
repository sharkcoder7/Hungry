//
//  MainDishTableViewCell.m
//  Hungry
//
//  Created by ioshero 9/28/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "MainDishTableViewCell.h"

@implementation MainDishTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) updateMainDish: (NSString*) strTitle expanded:(BOOL)bExpanded
{
    self.m_lblTitle.text = strTitle;
}

-(void) expand
{
    self.m_imgExpand.image = [UIImage imageNamed: @"minus_expand.png"];    
}

-(void) collapse
{
    self.m_imgExpand.image = [UIImage imageNamed: @"plus_expand.png"];
}


@end
