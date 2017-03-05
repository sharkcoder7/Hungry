//
//  FixedDishTableViewCell.h
//  Hungry
//
//  Created by ioshero 10/6/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixedDishTableViewCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UILabel        *m_lblTitle;
@property (weak, nonatomic) IBOutlet UIScrollView   *m_scrollView;
- (void) initMember;
- (void) updateDishInfo: (NSString*) strTitle detailInfo: (NSDictionary*) dicInfo;
@end
