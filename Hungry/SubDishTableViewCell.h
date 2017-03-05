//
//  SubDishTableViewCell.h
//  Hungry
//
//  Created by ioshero 9/28/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubDishTableViewCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblCount;

-(void) initMember;
@end
