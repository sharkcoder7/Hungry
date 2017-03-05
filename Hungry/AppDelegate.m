//
//  AppDelegate.m
//  Hungry
//
//  Created by ioshero 9/22/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "AppSettings.h"
#import "NSData+Base64.h"
#import "LocationInfo.h"
#import "PayPalMobile.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface AppDelegate () <CLLocationManagerDelegate>

@end

@implementation AppDelegate
@synthesize m_fCurLat;
@synthesize m_fCurLng;
@synthesize m_arrRecentLocList;
@synthesize m_mainViewController;

//====================================================================================================
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : PAYPAL_CLIENT_ID,
                                                           PayPalEnvironmentSandbox : PAYPAL_SECRET}];

    [AppSettings defineUserDefaults];

    [self initParse];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [self initLocation];
    [self initGlobal];
    return YES;
}

//====================================================================================================
- (void) initParse
{
    [Parse setApplicationId:@"xtZghqNnHfY9fMQDiizTcsrP2NmynASnlXPfhB8E"
                  clientKey:@"L8hGofeHzC82KMsGZLUByBVld11ET2hMGG3a7iRv"];
    [PFFacebookUtils initializeFacebook];
}

//====================================================================================================
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//====================================================================================================
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//====================================================================================================
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//====================================================================================================
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//====================================================================================================
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 
#pragma mark Location Services.

//====================================================================================================
-(void) initLocation
{
    if(locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
//        if(IS_OS_8_OR_LATER)
//        {
//            [locationManager requestAlwaysAuthorization];
//        }
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        
    }
}

//====================================================================================================
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    locationManager = nil;
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: nil
                               message:@"Please enable location services so Hungry can provide better notifications."
                               delegate: nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
}

//====================================================================================================
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil)
    {
        m_fCurLat = currentLocation.coordinate.latitude;
        m_fCurLng = currentLocation.coordinate.longitude;
        
        [[NSNotificationCenter defaultCenter] postNotificationName: NOTI_UPDATED_LOCATION object: nil];
    }
}
#pragma mark -
#pragma mark Global Function.

//====================================================================================================
+(AppDelegate*) getDelegate
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

//====================================================================================================
- (void)showMessage:(NSString *)text
{
    [[[UIAlertView alloc] initWithTitle: nil
                                message: text
                               delegate: self
                      cancelButtonTitle: @"OK"
                      otherButtonTitles: nil] show];
}

//====================================================================================================
- (void)showMessageWithTitle:(NSString*) title text:(NSString *)text
{
    [[[UIAlertView alloc] initWithTitle: title
                                message: text
                               delegate: self
                      cancelButtonTitle: @"OK"
                      otherButtonTitles: nil] show];
}

#pragma mark -
#pragma mark BLL general

//====================================================================================================
- (void) initGlobal
{
    self.m_arrRecentLocList = [[NSMutableArray alloc] init];
    
    NSArray *arrData = [AppSettings loadObject: @"recent_places"];
    if(arrData != nil && [arrData count] > 0)
    {
        for(int i = 0; i <= [arrData count] - 1; i++)
        {
            NSString* strLoc = [self base64Decode: [arrData objectAtIndex: i]];
            LocationInfo* loc = [[LocationInfo alloc] initWithPlainText: strLoc];
            
            [self.m_arrRecentLocList addObject: loc];
        }
    }
}

//====================================================================================================
- (void) saveGlobalInfo
{
    NSMutableArray* arrConverted = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [m_arrRecentLocList count]; i++)
    {
        LocationInfo* loc = [m_arrRecentLocList objectAtIndex: i];
        NSString* strLoc = [self base64Encode: [loc getJSONString]];
        
        [arrConverted addObject: strLoc];
    }
    
    [AppSettings storeObject: @"recent_places" obj: arrConverted];
}

//====================================================================================================
- (void)setValue:(id)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//====================================================================================================
- (id)valueForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

#pragma mark -
#pragma mark - Base64

//====================================================================================================
- (NSString *)base64Encode:(NSString *)plainText
{
    NSData *plainTextData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainTextData base64EncodedString];
    return base64String;
}

//====================================================================================================
- (NSString *)base64Decode:(NSString *)base64String
{
    NSData *plainTextData = [NSData dataFromBase64String:base64String];
    NSString *plainText = [[NSString alloc] initWithData:plainTextData encoding:NSUTF8StringEncoding];
    return plainText;
}

#pragma mark -
#pragma mark Facebook.

//SCFacebook Implementation
//====================================================================================================
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

//====================================================================================================
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

//====================================================================================================
@end
