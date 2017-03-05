//
//  BaseViewController.m
//  Hungry
//
//  Created by ioshero 9/22/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "BaseViewController.h"
#import "NSURLRequest+OAuth.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

//====================================================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMember];
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
    m_bCallAPIFlag = NO;
}

#pragma mark -
#pragma mark Yelp API.

//====================================================================================================
- (void)queryInfoForTerm:(NSString *)term
                                lat:(float) lat
                                lng: (float) lng
                  completionHandler:(void (^)(NSArray *arrData, NSError *error))completionHandler
{
    NSLog(@"Querying the Search API with term \'%@\' and location \'%f, %f'", term, lat, lng);
    
    //Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term lat: lat lng: lng];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error && httpResponse.statusCode == 200)
        {
            NSArray *businessResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([businessResponseJSON count] > 0)
            {
                NSLog(@"%lu businesses found", (unsigned long)[businessResponseJSON count]);
                
                completionHandler(businessResponseJSON, error);
            } else {
                completionHandler(nil, error); // No business was found
            }
        } else {
            completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}

//====================================================================================================
- (void)queryTopBusinessInfoForTerm:(NSString *)term location:(NSString *)location completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler
{
    NSLog(@"Querying the Search API with term \'%@\' and location \'%@'", term, location);
    
    //Make a first request to get the search results with the passed term and location
    NSURLRequest *searchRequest = [self _searchRequestWithTerm:term location:location];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:searchRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        if (!error && httpResponse.statusCode == 200) {
            
            NSDictionary *searchResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSArray *businessArray = searchResponseJSON[@"businesses"];
            
            if ([businessArray count] > 0) {
                NSDictionary *firstBusiness = [businessArray firstObject];
                NSString *firstBusinessID = firstBusiness[@"id"];
                NSLog(@"%lu businesses found, querying business info for the top result: %@", (unsigned long)[businessArray count], firstBusinessID);
                
                [self queryBusinessInfoForBusinessId:firstBusinessID completionHandler:completionHandler];
            } else {
                completionHandler(nil, error); // No business was found
            }
        } else {
            completionHandler(nil, error); // An error happened or the HTTP response is not a 200 OK
        }
    }] resume];
}

//====================================================================================================
- (void)queryBusinessInfoForBusinessId:(NSString *)businessID completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler
{    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *businessInfoRequest = [self _businessInfoRequestForID:businessID];
    [[session dataTaskWithRequest:businessInfoRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (!error && httpResponse.statusCode == 200) {
            NSDictionary *businessResponseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            completionHandler(businessResponseJSON, error);
        } else {
            completionHandler(nil, error);
        }
    }] resume];
}


#pragma mark - API Request Builders
//====================================================================================================
/**
 Builds a request to hit the search endpoint with the given parameters.
 
 @param term The term of the search, e.g: dinner
 @param location The location request, e.g: San Francisco, CA
 
 @return The NSURLRequest needed to perform the search
 */

- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term lat: (float) lat lng: (float) lng
{
    NSDictionary *params = @{
                             @"term": term,
                             @"ll": [NSString stringWithFormat: @"%f,%f", lat, lng],
                             @"limit": kSearchLimit,
                             @"deals_filter": @"0",
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}


- (NSURLRequest *)_searchRequestWithTerm:(NSString *)term location:(NSString *)location
{
    NSDictionary *params = @{
                             @"term": term,
                             @"location": location,
                             @"limit": kSearchLimit
                             };
    
    return [NSURLRequest requestWithHost:kAPIHost path:kSearchPath params:params];
}

/**
 Builds a request to hit the business endpoint with the given business ID.
 
 @param businessID The id of the business for which we request informations
 
 @return The NSURLRequest needed to query the business info
 */

//====================================================================================================
- (NSURLRequest *)_businessInfoRequestForID:(NSString *)businessID {
    
    NSString *businessPath = [NSString stringWithFormat:@"%@%@", kBusinessPath, businessID];
    return [NSURLRequest requestWithHost:kAPIHost path:businessPath];
}

//====================================================================================================
- (IBAction) actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}

//====================================================================================================

@end
