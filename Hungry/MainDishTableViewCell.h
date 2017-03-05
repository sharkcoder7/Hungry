//
//  MainDishTableViewCell.h
//  Hungry
//
//  Created by ioshero 9/28/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainDishTableViewCell : UITableViewCell
{
    
}

@property(nonatomic, retain) IBOutlet UIImageView               *m_imgExpand;
@property(nonatomic, retain) IBOutlet UILabel                   *m_lblTitle;

-(void) updateMainDish: (NSString*) strTitle expanded: (BOOL) bExpanded;
-(void) expand;
-(void) collapse;
@end
