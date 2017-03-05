//
//  DishCellView.h
//  Hungry
//
//  Created by ioshero 9/23/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DishCellViewDelegate
@optional
-(void) selectedOrder: (NSDictionary*) dicDish;
@end

@interface DishCellView : UIView
{
    
}
@property(nonatomic, retain) NSDictionary*      m_dicDish;
@property(nonatomic, retain) id                 delegate;

-(void) updateDish: (NSDictionary*) dicDish;

@end
