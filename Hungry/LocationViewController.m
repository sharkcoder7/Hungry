//
//  LocationViewController.m
//  Hungry
//
//  Created by ioshero 9/26/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "LocationViewController.h"
#import "LocationTableViewCell.h"
#import "AFNetworking.h"
#import "PaymentViewController.h"

@interface LocationViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableDictionary*                m_dicData;
    NSMutableArray*                     m_arrSearchResult;
    
    BOOL                                m_bSearchFlag;
}

@property (weak, nonatomic) IBOutlet UISearchBar *m_searchBar;
@property (weak, nonatomic) IBOutlet UITableView *m_tableView;

@end

@implementation LocationViewController
@synthesize m_parentView;

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
    
    m_arrSearchResult = [[NSMutableArray alloc] init];
    m_dicData = [[NSMutableDictionary alloc] init];

    [m_dicData setObject: [AppDelegate getDelegate].m_arrRecentLocList forKey: RECENT_LOCATION];
    [m_dicData setObject: [[NSMutableArray alloc] init] forKey: NEARBY_LOCATION];
    
    m_bSearchFlag = NO;
    [self loadNearByLocations: @""];
}

//====================================================================================================
- (void) loadNearByLocations :(NSString*) addressStr
{
    [AppDelegate getDelegate].m_fCurLat = 37.900000;
    [AppDelegate getDelegate].m_fCurLng = -122.500000;
    
    NSMutableDictionary* parameters=[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                     [NSString stringWithFormat:@"%f,%f",[AppDelegate getDelegate].m_fCurLat,[AppDelegate getDelegate].m_fCurLng], @"ll",
                                      @"20140421", @"v",
                                     FOURSQUARE_CLIENT_SECRET, @"client_secret",FOURSQUARE_CLIENT_ID,@"client_id",@"50",@"limit", nil];
    if(![addressStr isEqualToString:@""])
    {
        [parameters setObject: addressStr forKey:@"query"];
        [parameters setObject: @"80000" forKey: @"radius"];
    }
    else
    {
        [parameters setObject: @"100" forKey: @"radius"];
    }
    
    [SVProgressHUD showWithStatus: @"Please wait..."];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/venues/"]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:@"search?" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject)
    {
        [SVProgressHUD dismiss];
        
        NSDictionary *json=(NSDictionary*)responseObject;
        NSLog(@"%@",json);
        json=[json objectForKey:@"response"];
        if(json)
        {
            NSArray* places = [json objectForKey:@"venues"];
            NSMutableArray* arrResult = [[NSMutableArray alloc] init];
            
            if(places)
            {
                for (int i=0; i<[places count]; i++)
                {
                    NSDictionary* placeDict=[places objectAtIndex:i];
                    LocationInfo* location = [[LocationInfo alloc] init];
                    
                    location.placeID = [placeDict objectForKey:@"id"];
                    location.title = [placeDict objectForKey:@"name"];
                    
                    NSDictionary*mTempDict=[placeDict objectForKey:@"location"];
                    NSNumber *doubleVal=[mTempDict objectForKey:@"lat"];

                    location.lat=[NSString stringWithFormat:@"%f",doubleVal.doubleValue];
                    doubleVal=[mTempDict objectForKey:@"lng"];
                    location.lng=[NSString stringWithFormat:@"%f",doubleVal.doubleValue];
                    
                    if([mTempDict objectForKey:@"formattedAddress"])
                        location.address=[[mTempDict objectForKey:@"formattedAddress"] componentsJoinedByString: @" "];
                    else
                        location.address=@"";
                    
                    [arrResult addObject: location];
                }
                
                if(m_bSearchFlag)
                {
                    [m_arrSearchResult addObjectsFromArray: arrResult];
                }
                else
                {
                    [m_dicData setObject: arrResult forKey: NEARBY_LOCATION];
                }
            }
            
            [self.m_tableView reloadData];
        }
    }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [SVProgressHUD dismiss];
         NSLog(@"Error: %@",error);
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
//====================================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(m_bSearchFlag)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

//====================================================================================================
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 19.0f;
}

//====================================================================================================
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61.0f;
}

//====================================================================================================
-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* lblTitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 320.0f, 19.0f)];
    lblTitle.backgroundColor = [UIColor colorWithRed: 103.0f/255.0f green: 103.0f/255.0f blue: 103.0f/255.0f alpha: 1.0f];
    lblTitle.textColor = [UIColor whiteColor];
    
    if(m_bSearchFlag)
    {
            lblTitle.text = @"     SEARCH";
    }
    else
    {
        if(section == 0)
        {
            lblTitle.text = @"     RECENT";
        }
        else
        {
            lblTitle.text = @"     NEARBY";
        }
    }
    
    return lblTitle;
}

//====================================================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(m_bSearchFlag)
    {
        return [m_arrSearchResult count];
    }
    else
    {
        if(section == 0)
        {
            return [[m_dicData valueForKey: RECENT_LOCATION] count];
        }
        else
        {
            return [[m_dicData valueForKey: NEARBY_LOCATION] count];
        }
    }
}


//====================================================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LocationTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if(m_bSearchFlag)
    {
        [cell updateLocation: [m_arrSearchResult objectAtIndex: indexPath.row]];
    }
    else
    {
        if(indexPath.section == 0)
        {
            [cell updateLocation: [[m_dicData valueForKey: RECENT_LOCATION] objectAtIndex: indexPath.row]];
        }
        else if(indexPath.section == 1)
        {
            [cell updateLocation: [[m_dicData valueForKey: NEARBY_LOCATION] objectAtIndex: indexPath.row]];
        }
    }

    return cell;
}

//====================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationInfo* place;
    
    if(m_bSearchFlag)
    {
        place = [m_arrSearchResult objectAtIndex: indexPath.row];
    }
    else
    {
        if(indexPath.section == 0)
        {
            place = [[m_dicData valueForKey: RECENT_LOCATION] objectAtIndex: indexPath.row];
        }
        else
        {
            place = [[m_dicData valueForKey: NEARBY_LOCATION] objectAtIndex: indexPath.row];
        }
    }
    
    [(PaymentViewController*)self.m_parentView updateDeliveryLocation: place];
    [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark -
#pragma mark UISearch Bar Delegate.

//====================================================================================================
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString* strKey = searchBar.text;
    if([strKey length] <= 0)
    {
        m_bSearchFlag = NO;
        [self loadNearByLocations: @""];
    }
    else
    {
        m_bSearchFlag = YES;
        [m_arrSearchResult removeAllObjects];
        [self loadNearByLocations: strKey];
    }
}

//====================================================================================================
@end
