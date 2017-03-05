//
//  MainViewController.m
//  Hungry
//
//  Created by ioshero 9/22/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "MainViewController.h"
#import "DishCellView.h"
#import "AppSettings.h"
#import "OrderViewController.h"
#import "UIImage+animatedGIF.h"
#import "ProfileViewController.h"
#import "CreateProfileViewController.h"
#import "ShareViewController.h"
#import "SupportViewController.h"
#import "AddResturantTableViewCell.h"
#import "PromotionsViewController.h"
#import "CreateProfileViewController.h"

@interface MainViewController() <UITableViewDataSource, UITableViewDelegate, DishCellViewDelegate, AddResturantTableViewCellDelegate>
{
    NSMutableArray*             m_arrFilters;
    NSMutableArray*             m_arrSettings;
    NSMutableArray*             m_arrDishes;
    
    BOOL                        m_bOpenFilter;
    BOOL                        m_bOpenSettings;
    
    int                         m_nMenuIndex;
    
    BOOL                        m_bTutorial1;
    BOOL                        m_bTutorial2;
    
    BOOL                        m_bShowDelivery;
}

@property (weak, nonatomic) IBOutlet UIView             *m_viewContent;
@property (weak, nonatomic) IBOutlet UIImageView        *m_imgTutorial1;
@property (weak, nonatomic) IBOutlet UIImageView        *m_imgTutorial2;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblCategory;
@property (weak, nonatomic) IBOutlet UIImageView        *m_imgLogo;

//Deal List.
@property (weak, nonatomic) IBOutlet UIScrollView       *m_scrollView;
@property (weak, nonatomic) IBOutlet UIButton           *m_btnFilter;
@property (weak, nonatomic) IBOutlet UIButton           *m_btnSettings;
@property (weak, nonatomic) IBOutlet UIButton           *m_btnClose;

@property (weak, nonatomic) IBOutlet UITableView        *m_tableFilter;

//Delivery View.
@property (weak, nonatomic) IBOutlet UIView             *m_viewDelivery;
@property (weak, nonatomic) IBOutlet UIView             *m_viewFoodComing;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblDealName;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblAddress;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblCardNumber;
@property (weak, nonatomic) IBOutlet UILabel            *m_lblDeliveryTime;
@property (weak, nonatomic) IBOutlet UIImageView        *m_imgLastGif;

@end

@implementation MainViewController

//====================================================================================================
-(void) initMember
{
    [super initMember];

    [self initDeliveryUI];
    
    m_arrDishes = [[NSMutableArray alloc] init];
    m_arrFilters = [[NSMutableArray alloc] initWithObjects: @"Pizza", @"Chinese", @"Thai", @"Sushi", @"American", @"Salads", nil];
    m_arrSettings = [[NSMutableArray alloc] initWithObjects: @"Profile", @"Promotions", @"Payment", @"Support", @"Share", @"About", nil];
    
    [self removeAllContents];
    [self updateDishUI];
    
    m_bTutorial1 = [AppSettings getBoolValue: @"tutorial_01"];
    m_bTutorial2 = [AppSettings getBoolValue: @"tutorial_02"];
    self.m_imgTutorial1.hidden = m_bTutorial1;
    
    m_bOpenFilter = NO;
    m_bOpenSettings = NO;
    m_bShowDelivery = NO;

    self.m_viewDelivery.hidden = YES;
    [AppDelegate getDelegate].m_mainViewController = self;
}

//====================================================================================================
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

//====================================================================================================
-(void) updateDishUI
{
    float fx = 0;
    float fy = 0;
    float fw = 320.0f;
    float fh = 506.0f;
    
    for(int i = 0; i < 10/*[m_arrDishes count]*/; i++)
    {
        DishCellView* cellView = [[DishCellView alloc] initWithFrame: CGRectMake(fx, fy, fw, fh)];
        [self.m_scrollView addSubview: cellView];
        cellView.delegate = self;
        
        fx += fw;
    }
    
    [self.m_scrollView setContentSize: CGSizeMake(fx, fh)];
}

//====================================================================================================
-(void) selectedOrder:(NSDictionary *)dicDish
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *nextView = (MainViewController *)[storyboard instantiateViewControllerWithIdentifier:@"order_view"];
    [self.navigationController pushViewController: nextView animated: YES];
}

//====================================================================================================
-(void) removeAllContents
{
    for(UIView* view in self.m_scrollView.subviews)
    {
        [view removeFromSuperview];
    }
}

#pragma mark -
#pragma mark Filter.

//====================================================================================================
-(IBAction) actionFilter:(id)sender
{
    if(m_bOpenSettings) return;
    
    m_nMenuIndex = FILTER_MENU;
    if(!m_bOpenFilter)
    {
        [self.m_btnFilter setImage: [UIImage imageNamed: @"btn_filter_sel.png"] forState: UIControlStateNormal];
        [self openFilterView: FILTER_MENU];
    }
    else
    {
        [self.m_btnFilter setImage: [UIImage imageNamed: @"btn_filter.png"] forState: UIControlStateNormal];
        [self closeFilterView: FILTER_MENU];
    }
    [self.m_tableFilter reloadData];
}

//====================================================================================================
-(void) openFilterView: (int) nIndex
{
    float fDistance;
    if(nIndex == FILTER_MENU)
    {
        fDistance = ([m_arrFilters count] + 1) * 44.0f;
    }
    else
    {
        fDistance = [m_arrSettings count] * 44.0f;
    }
    
    [UIView animateKeyframesWithDuration: 0.2
                                   delay: 0
                                 options: UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations: ^(void) {
                                  self.m_tableFilter.frame = CGRectMake(self.m_tableFilter.frame.origin.x,
                                                                        self.m_tableFilter.frame.origin.y + self.m_tableFilter.frame.size.height,
                                                                        self.m_tableFilter.frame.size.width,
                                                                        self.m_tableFilter.frame.size.height + 44.0f);
                                  self.m_viewContent.frame = CGRectMake(self.m_viewContent.frame.origin.x,
                                                                       self.m_viewContent.frame.origin.y + fDistance,
                                                                       self.m_viewContent.frame.size.width,
                                                                       self.m_viewContent.frame.size.height);
                              }
                              completion:^(BOOL finished)
     {
         if(nIndex == FILTER_MENU)
         {
             m_bOpenFilter = YES;
         }
         else
         {
             m_bOpenSettings = YES;
         }
     }];
}

//====================================================================================================
-(void) closeFilterView: (int) nIndex
{
    float fDistance;
    if(nIndex == FILTER_MENU)
    {
        fDistance = ([m_arrFilters count] + 1) * 44.0f;
    }
    else
    {
        fDistance = [m_arrSettings count] * 44.0f;
    }
    
    [UIView animateKeyframesWithDuration: 0.2
                                   delay: 0
                                 options: UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations: ^(void) {
                                  self.m_tableFilter.frame = CGRectMake(self.m_tableFilter.frame.origin.x,
                                                                        self.m_tableFilter.frame.origin.y - self.m_tableFilter.frame.size.height,
                                                                        self.m_tableFilter.frame.size.width,
                                                                        self.m_tableFilter.frame.size.height);
                                  self.m_viewContent.frame = CGRectMake(self.m_viewContent.frame.origin.x,
                                                                       self.m_viewContent.frame.origin.y - fDistance,
                                                                       self.m_viewContent.frame.size.width,
                                                                       self.m_viewContent.frame.size.height);
                              }
                              completion:^(BOOL finished)
     {
         if(nIndex == FILTER_MENU)
         {
             m_bOpenFilter = NO;
         }
         else
         {
             m_bOpenSettings = NO;
         }
     }];
}

//====================================================================================================
-(IBAction) actionEndFilterMode:(id)sender
{
    self.m_btnClose.hidden = YES;
    [self.m_btnFilter setImage: [UIImage imageNamed: @"btn_filter.png"] forState: UIControlStateNormal];
    self.m_lblCategory.text = @"";
    self.m_lblCategory.hidden = YES;
    self.m_imgLogo.hidden = NO;
}

//====================================================================================================
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

//====================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_nMenuIndex == FILTER_MENU)
    {
        return [m_arrFilters count] + 1;
    }
    else if(m_nMenuIndex == SETTINGS_MENU)
    {
        return [m_arrSettings count];
    }
    return 0;
}

//====================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell;
    if(m_nMenuIndex == FILTER_MENU)
    {
        if(indexPath.row >= [m_arrFilters count])
        {
            cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
            if(cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddResturantTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            [(AddResturantTableViewCell*)cell setDelegate: self];
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            cell.textLabel.text = [m_arrFilters objectAtIndex:indexPath.row];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f];
        }

    }
    else if(m_nMenuIndex == SETTINGS_MENU)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        cell.textLabel.text = [m_arrSettings objectAtIndex:indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName: @"HelveticaNeue-Light" size: 14.0f];
    }

    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor whiteColor];
    
    //Selection Color.
    UIView * selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed: 235.0f/255.0f green:28.0f/255.0f blue:48.0f/255.0f alpha: 1.0f]];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    
    return cell;
}

////====================================================================================================
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//}

//====================================================================================================
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(m_nMenuIndex == FILTER_MENU)
    {
//        [self.m_btnFilter setImage: [UIImage imageNamed: @"selected_filter.png"] forState: UIControlStateNormal];
        self.m_btnClose.hidden = NO;
        self.m_lblCategory.text = [m_arrFilters objectAtIndex: indexPath.row];
        self.m_lblCategory.hidden = NO;
        self.m_imgLogo.hidden = YES;
    }
    else if(m_nMenuIndex == SETTINGS_MENU)
    {
        [self.m_btnSettings setImage: [UIImage imageNamed: @"btn_settings.png"] forState: UIControlStateNormal];
        [self gotoSettings: indexPath.row];
    }

    [self closeFilterView: m_nMenuIndex];
}

//====================================================================================================
- (void) filterWithRestaurantName:(NSString *)restaurantName
{
    self.m_btnClose.hidden = NO;
    self.m_lblCategory.text = restaurantName;
    self.m_lblCategory.hidden = NO;
    self.m_imgLogo.hidden = YES;

    [self closeFilterView: FILTER_MENU];
}

//====================================================================================================
- (void) beginEditing
{
    [self.m_tableFilter setContentOffset: CGPointMake(0, 40) animated: YES];
}

//====================================================================================================
- (void) endEditing
{
    [self.m_tableFilter setContentOffset: CGPointMake(0, 0) animated: YES];
}

#pragma mark -
#pragma mark Tutorial.

//====================================================================================================
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!m_bTutorial1)
    {
        m_bTutorial1 = YES;
        [AppSettings setBoolValueWithName: m_bTutorial1 name: @"tutorial_01"];
        self.m_imgTutorial1.hidden = YES;
    }
    
    if(m_bShowDelivery && !m_bTutorial2 && !self.m_imgTutorial2.hidden)
    {
        m_bTutorial2 = YES;
        [AppSettings setBoolValueWithName: m_bTutorial2 name: @"tutorial_02"];
        self.m_imgTutorial2.hidden = YES;
    }
}

#pragma mark -
#pragma mark Settings Management.

//====================================================================================================
-(IBAction) actionSettings:(id)sender
{
    if(m_bOpenFilter) return;
    
    m_nMenuIndex = SETTINGS_MENU;
    [self.m_tableFilter reloadData];
    if(!m_bOpenSettings)
    {
        [self.m_btnSettings setImage: [UIImage imageNamed: @"btn_settings_sel.png"] forState: UIControlStateNormal];
        [self openFilterView: SETTINGS_MENU];
    }
    else
    {
        [self.m_btnSettings setImage: [UIImage imageNamed: @"btn_settings.png"] forState: UIControlStateNormal];
        [self closeFilterView: SETTINGS_MENU];
    }
}

//====================================================================================================
- (void) gotoSettings: (int) nIndex
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString* strView;
    
    switch (nIndex)
    {
        //Profile
        case 0:
        {
            if([[PFUser currentUser] isAuthenticated])
            {
                strView = @"profile_view";
            }
            else
            {
                strView = @"create_profile_view";
                CreateProfileViewController* nextView = [storyboard instantiateViewControllerWithIdentifier: strView];
                nextView.m_nPrevViewIndex = MAIN_VIEW;
                nextView.m_returnParentView = self;
                [self.navigationController pushViewController: nextView animated: NO];
                return;
            }
        }
            break;

        //Promocodes.
        case 1:
            strView = @"promo_view";
            break;

        //Payment
        case 2:
            strView = @"payment_list_view";
            break;

        //Support
        case 3:
            strView = @"support_view";
            break;

            
        //Share
        case 4:
            strView = @"share_view";
            break;

        //About.
        case 5:
            strView = @"about_view";
            break;
            
        default:
            break;
    }
    
    if(strView != nil)
    {
        id nextView = [storyboard instantiateViewControllerWithIdentifier: strView];
        [self.navigationController pushViewController: nextView animated: NO];
    }
}


#pragma mark -
#pragma mark Delivery View.

//====================================================================================================
- (void) initDeliveryUI
{
    self.m_viewFoodComing.layer.masksToBounds = YES;
    self.m_viewFoodComing.layer.cornerRadius = self.m_viewFoodComing.frame.size.width / 2.0f;
    self.m_lblDeliveryTime.font = [UIFont fontWithName: @"Impact" size: 50.0f];
}

//====================================================================================================
- (void) showDeliveryView
{
    self.m_scrollView.hidden = YES;
    self.m_viewDelivery.hidden = NO;

    NSURL* url = [[NSBundle mainBundle] URLForResource: @"plates" withExtension:@"gif"];
    self.m_imgLastGif.image = [UIImage animatedImageWithAnimatedGIFURL:url];
    self.m_imgLastGif.hidden = NO;
    
    m_bShowDelivery = YES;
}

//====================================================================================================
- (IBAction) actionExit:(id)sender
{
    m_bShowDelivery = NO;
    self.m_viewDelivery.hidden = YES;
    self.m_scrollView.hidden = NO;
    
    self.m_imgLastGif.image = nil;
    self.m_imgLastGif.hidden = NO;
    
    //Go to Share Page.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id nextView = [storyboard instantiateViewControllerWithIdentifier: @"share_view"];
    [self.navigationController pushViewController: nextView animated: NO];
}

//====================================================================================================

@end
