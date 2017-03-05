//
//  OrderItemView.m
//  Hungry
//
//  Created by ioshero 11/2/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "OrderItemView.h"

@interface OrderItemView()
{
    
}

@property (weak, nonatomic) IBOutlet UILabel *m_lblDishTitle1;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgDish1;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDishPrice1;
@property (weak, nonatomic) IBOutlet UILabel *m_lblDishCount1;

@end

@implementation OrderItemView

//====================================================================================================
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        OrderItemView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"OrderItemView" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:frame];
        self = xibView;
        [self initMember];
    }
    return self;
}

//====================================================================================================
- (void) initMember
{
    self.m_lblDishPrice1.layer.masksToBounds = YES;
    self.m_lblDishPrice1.layer.cornerRadius = self.m_lblDishPrice1.frame.size.width / 2.0f;
}

//====================================================================================================
- (void) updateOrderItem: (NSDictionary*) dicDish
{
    if(![[dicDish valueForKey: @"name"] isKindOfClass: [NSNull class]])
    {
        self.m_lblDishTitle1.text = [dicDish valueForKey: @"name"];
    }
    
    if(![[dicDish valueForKey: @"image"] isKindOfClass: [NSNull class]])
    {
        self.m_imgDish1.image = [UIImage imageNamed: [dicDish valueForKey: @"image"]];
    }
    
    self.m_lblDishPrice1.text = [NSString stringWithFormat: @"$ %0.1f", [[dicDish valueForKey: @"price"] floatValue]];
}

//====================================================================================================
@end
