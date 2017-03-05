//
//  BaseViewController.h
//  Hungry
//
//  Created by ioshero 9/22/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"

//Model
#import "LocationInfo.h"

@interface BaseViewController : UIViewController
{
    BOOL                m_bCallAPIFlag;
}

-(void) initMember;

- (void)queryInfoForTerm:(NSString *)term
                                lat:(float) lat
                                lng: (float) lng
                  completionHandler:(void (^)(NSArray *arrData, NSError *error))completionHandler;
- (void)queryTopBusinessInfoForTerm:(NSString *)term
                           location:(NSString *)location
                  completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler;
- (void)queryBusinessInfoForBusinessId:(NSString *)businessID
                     completionHandler:(void (^)(NSDictionary *topBusinessJSON, NSError *error))completionHandler;

- (IBAction) actionBack:(id)sender;
@end
