//
//  OrderViewController.m
//  Hungry
//
//  Created by ioshero 9/26/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "OrderViewController.h"
#import "MainDishTableViewCell.h"
#import "SubDishTableViewCell.h"
#import "PaymentViewController.h"
#import "FixedDishTableViewCell.h"
#import "SWTableViewCell.h"
#import "AppSettings.h"
#import "CreateProfileViewController.h"

@interface OrderViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate>
{
    NSMutableArray                  *m_arrItems;
}

@property (weak, nonatomic) IBOutlet UITableView    *m_tableView;
@property (weak, nonatomic) IBOutlet UIView         *m_viewFooter;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblMainPrice;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblMainTitle;
@property (weak, nonatomic) IBOutlet UILabel        *m_lblMainCount;

@end

@implementation OrderViewController
@synthesize m_dicDish;

//====================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//====================================================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//====================================================================================================
-(void) initMember
{
    [super initMember];
    
    self.m_lblMainPrice.layer.masksToBounds = YES;
    self.m_lblMainPrice.layer.cornerRadius = self.m_lblMainPrice.frame.size.width / 2.0f;
    
    //Addtional.
    NSArray* arrAdditional = [NSArray arrayWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"SALAD", @"name",
                         @"", @"image",
                         [NSNumber numberWithFloat: 4.0f], @"price",
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"FRUIT", @"name",
                         @"", @"image",
                         [NSNumber numberWithFloat: 2.5f], @"price",
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"CORN", @"name",
                         @"", @"image",
                         [NSNumber numberWithFloat: 2.0f], @"price",
                         nil],
                              
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"CORN", @"name",
                               @"", @"image",
                               [NSNumber numberWithFloat: 2.0f], @"price",
                               nil],
                              
                              [NSDictionary dictionaryWithObjectsAndKeys:
                               @"CORN", @"name",
                               @"", @"image",
                               [NSNumber numberWithFloat: 2.0f], @"price",
                               nil],
                              nil];
    
    NSDictionary* dicItem1 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Addtional Cate Melon Dishes", @"title",
                              arrAdditional, @"data",
                              nil];
    
    //Sides.
    NSArray* arrSide = [NSArray arrayWithObjects:
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"SALAD", @"name",
                         @"", @"image",
                         [NSNumber numberWithFloat: 4.0f], @"price",
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"FRUIT", @"name",
                         @"", @"image",
                         [NSNumber numberWithFloat: 2.5f], @"price",
                         nil],
                        
                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"CORN", @"name",
                         @"", @"image",
                         [NSNumber numberWithFloat: 2.0f], @"price",
                         nil],

                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"CORN", @"name",
                         @"", @"image",
                         [NSNumber numberWithFloat: 2.0f], @"price",
                         nil],

                        [NSDictionary dictionaryWithObjectsAndKeys:
                         @"CORN", @"name",
                         @"", @"image",
                         [NSNumber numberWithFloat: 2.0f], @"price",
                         nil],
                        
                        nil];
    
    NSDictionary* dicItem2 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Sides", @"title",
                              arrSide, @"data",
                              nil];

    

    //Desserts
    NSArray* arrDesserts = [NSArray arrayWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Tiramius", @"name",
                          @"", @"image",
                          [NSNumber numberWithFloat: 4.0f], @"price",
                          nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Cake", @"name",
                          @"", @"image",
                          [NSNumber numberWithFloat: 2.5f], @"price",
                          nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Pastry", @"name",
                          @"", @"image",
                          [NSNumber numberWithFloat: 2.0f], @"price",
                          nil],

                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Pastry", @"name",
                             @"", @"image",
                             [NSNumber numberWithFloat: 2.0f], @"price",
                             nil],
                            
                            [NSDictionary dictionaryWithObjectsAndKeys:
                             @"Pastry", @"name",
                             @"", @"image",
                             [NSNumber numberWithFloat: 2.0f], @"price",
                             nil],
                            
                            nil];
    
    NSDictionary* dicItem3 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Desserts", @"title",
                              arrDesserts, @"data",
                              nil];
    
    //Drinks
    NSArray* arrDrink = [NSArray arrayWithObjects:
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"name",
                          @"drink_sample01.png", @"image",
                          [NSNumber numberWithFloat: 4.0f], @"price",
                          nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"name",
                          @"drink_sample02.png", @"image",
                          [NSNumber numberWithFloat: 2.5f], @"price",
                          nil],
                         
                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"name",
                          @"drink_sample03.png", @"image",
                          [NSNumber numberWithFloat: 2.0f], @"price",
                          nil],

                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"name",
                          @"drink_sample03.png", @"image",
                          [NSNumber numberWithFloat: 2.0f], @"price",
                          nil],

                         [NSDictionary dictionaryWithObjectsAndKeys:
                          @"", @"name",
                          @"drink_sample03.png", @"image",
                          [NSNumber numberWithFloat: 2.0f], @"price",
                          nil],
                         
                         nil];
    
    NSDictionary* dicItem4 = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"Drinks", @"title",
                              arrDrink, @"data",
                              nil];

    
    m_arrItems = [[NSMutableArray alloc] initWithObjects: dicItem1, dicItem2, dicItem3, dicItem4, nil];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
//====================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//====================================================================================================
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

//====================================================================================================
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.m_viewFooter.frame.size.height;
}

//====================================================================================================
- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.m_viewFooter;
}

//====================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrItems count];
}

//====================================================================================================
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185.0f;
}

//====================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    FixedDishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FixedDishTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSDictionary* dicItem = [m_arrItems objectAtIndex: indexPath.row];
    NSString* title = [dicItem valueForKey: @"title"];
    [cell updateDishInfo: title detailInfo: dicItem];
    
    return cell;
}

//====================================================================================================
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor redColor] title: @"DELETE"];
    return rightUtilityButtons;
}

//====================================================================================================
- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
        {
            NSLog(@"left utility buttons open");

        }
            break;
        case 2:
        {
            NSLog(@"right utility buttons open");
        }
            
            break;
        default:
            break;
    }
}


//====================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark -
#pragma mark Action Management.

//====================================================================================================
-(IBAction) actionNext:(id)sender
{
    if([[PFUser currentUser] isAuthenticated])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PaymentViewController *nextView = (PaymentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"confirm_view"];
        nextView.m_returnView = self;
        [self.navigationController pushViewController: nextView animated: YES];
    }
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CreateProfileViewController *nextView = (CreateProfileViewController *)[storyboard instantiateViewControllerWithIdentifier:@"create_profile_view"];
        nextView.m_nPrevViewIndex = ORDER_VIEW;
        nextView.m_returnParentView = self;
        nextView.m_orderView = self;
        [self.navigationController pushViewController: nextView animated: YES];
    }
}

//====================================================================================================
@end
