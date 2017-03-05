//
//  DishCellView.m
//  Hungry
//
//  Created by ioshero 9/23/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "DishCellView.h"

@interface DishCellView()
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *m_imgPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *m_imgRating;
@property (weak, nonatomic) IBOutlet UILabel *m_lblName;
@property (weak, nonatomic) IBOutlet UILabel *m_lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *m_lblPrice;

@end

@implementation DishCellView
@synthesize delegate;

//====================================================================================================
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        DishCellView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"DishCellView" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:frame];
        self = xibView;
        [self initMember];
    }
    return self;
}

//====================================================================================================
- (void) initMember
{
    self.m_lblPrice.layer.masksToBounds = YES;
    self.m_lblPrice.layer.cornerRadius = self.m_lblPrice.frame.size.width / 2.0f;
}

//====================================================================================================
-(void) updateDish: (NSDictionary*) dicDish
{
    self.m_dicDish = dicDish;
}

//====================================================================================================
- (IBAction)actionOrder:(id)sender
{
    if ([(id)delegate respondsToSelector:@selector(selectedOrder:)])
    {
        [delegate selectedOrder: self.m_dicDish];
    }
}

//====================================================================================================
@end
