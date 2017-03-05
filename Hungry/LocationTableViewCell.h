//
//  LocationTableViewCell.h
//  Hungry
//
//  Created by ioshero 9/28/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationInfo.h"

@interface LocationTableViewCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *m_lblAddress;

-(void) updateLocation: (LocationInfo*) dicLocation;
@end
