//
//  PaymentListViewController.m
//  Hungry
//
//  Created by ioshero 10/5/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "PaymentListViewController.h"
#import "PaymentTableViewCell.h"

@interface PaymentListViewController () <UITableViewDataSource, UITableViewDelegate, PaymentTableViewCellDelegate>
{
    NSMutableArray*         m_arrItems;
    BOOL                    m_bEditFlag;
}

@property (weak, nonatomic) IBOutlet UITableView    *m_tableView;
@property (strong, nonatomic) IBOutlet UIView       *m_viewAddPayment;
@property (weak, nonatomic) IBOutlet UIButton       *m_btnEdit;

@end

@implementation PaymentListViewController

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
- (void) initMember
{
    [super initMember];
    
    m_bEditFlag = NO;
    m_arrItems = [[NSMutableArray alloc] init];
    if([[PFUser currentUser] isAuthenticated])
    {
        [self loadPaymentItems];
    }
}

//====================================================================================================
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [m_arrItems removeAllObjects];
    
    if([[PFUser currentUser] isAuthenticated])
    {
        [self loadPaymentItems];
    }
}

//====================================================================================================
- (void) loadPaymentItems
{
    PFQuery* query = [PFQuery queryWithClassName: @"Payment"];
    [query whereKey: @"user_id" equalTo: [PFUser currentUser].objectId];
    [query orderByDescending: @"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if(objects != nil && [objects count] > 0)
        {
            [m_arrItems removeAllObjects];
            [m_arrItems addObjectsFromArray: objects];
            [self.m_tableView reloadData];
        }
    }];
}

//====================================================================================================
- (IBAction)actionEdit:(id)sender
{
    m_bEditFlag = !m_bEditFlag;
    if(m_bEditFlag)
    {
        [self.m_btnEdit setTitle: @"Done" forState: UIControlStateNormal];
    }
    else
    {
        [self.m_btnEdit setTitle: @"Edit" forState: UIControlStateNormal];
    }
    
    NSInteger sectionCount = [self.m_tableView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger rowCount = [self.m_tableView numberOfRowsInSection:section];
        for (NSInteger row = 0; row < rowCount; row++)
        {
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            PaymentTableViewCell* cell = (PaymentTableViewCell*)[self.m_tableView cellForRowAtIndexPath:indexPath];
            [cell editPayment: m_bEditFlag];
        }
    }
}

//====================================================================================================
- (IBAction)actionAddPayment:(id)sender
{
    if([[PFUser currentUser] isAuthenticated])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        id nextView = [storyboard instantiateViewControllerWithIdentifier:@"payment_add_view"];
        [self.navigationController pushViewController: nextView animated: YES];
    }
}

//====================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrItems count];
}

//====================================================================================================
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61.0f;
}

//====================================================================================================
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35.0f;
}

//====================================================================================================
- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.m_viewAddPayment;
}

//====================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.tag = indexPath.row;
    cell.delegate = self;
    [cell updatePayment: [m_arrItems objectAtIndex: indexPath.row]];
    
    return cell;
}

//====================================================================================================
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

//====================================================================================================
- (void) deletePayment:(int)nIndex
{
    PFObject* obj = [m_arrItems objectAtIndex: nIndex];
    [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        [m_arrItems removeObjectAtIndex: nIndex];
        [self.m_tableView reloadData];
    }];
}

//====================================================================================================

@end
