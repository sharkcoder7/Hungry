//
//  FixedDishTableViewCell.m
//  Hungry
//
//  Created by ioshero 10/6/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "FixedDishTableViewCell.h"
#import "OrderItemView.h"

@implementation FixedDishTableViewCell

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
- (void) initMember
{

}

//====================================================================================================
- (void) updateDishInfo: (NSString*) strTitle detailInfo: (NSDictionary*) dicInfo
{
    self.m_lblTitle.text = strTitle;

    for(UIView* view in self.m_scrollView.subviews)
    {
        [view removeFromSuperview];
    }

    
    NSArray* arrInfo = [dicInfo valueForKey: @"data"];
    if(arrInfo != nil && [arrInfo count] > 0)
    {
        float fx = 4;
        float fy = 0;
        float fw = 104;
        float fh = 138;
        
        for(int i = 0; i < [arrInfo count]; i++)
        {
            OrderItemView* item = [[OrderItemView alloc] initWithFrame: CGRectMake(fx, fy, fw, fh)];
            NSDictionary* dicDish = [arrInfo objectAtIndex: i];
            [item updateOrderItem: dicDish];
            
            [self.m_scrollView addSubview: item];
            fx += fw;
        }
        
        [self.m_scrollView setContentSize: CGSizeMake(fx, fh)];
    }
}

//====================================================================================================
@end
