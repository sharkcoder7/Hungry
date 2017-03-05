//
//  AppDelegate.h
//  Hungry
//
//  Created by ioshero 9/22/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow              *window;
@property (nonatomic, assign) float                 m_fCurLat;
@property (nonatomic, assign) float                 m_fCurLng;
@property (nonatomic, retain) NSMutableArray        *m_arrRecentLocList;
@property (nonatomic, retain) id                    m_mainViewController;

+(AppDelegate*) getDelegate;
-(void) showMessage: (NSString*) strMessage;
- (void)showMessageWithTitle:(NSString*) title text:(NSString *)text;

- (void) saveGlobalInfo;
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKey:(NSString *)key;
- (NSString *)base64Encode:(NSString *)plainText;
- (NSString *)base64Decode:(NSString *)base64String;

@end

