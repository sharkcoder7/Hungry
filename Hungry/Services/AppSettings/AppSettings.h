//
//  AppSetting.h
//  fruitGame
//
//  Created by KCU on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AppSettings : NSObject 
{

}

+ (void) defineUserDefaults;

+(void) storeObject: (NSString*) strName obj: (id) obj;
+(id) loadObject: (NSString*) strName;

+ (void) setIntValueWithName: (int) nValue name: (NSString*) strName;
+ (int)  getIntValue: (NSString*) strName;

+ (void) setBoolValueWithName: (BOOL) bValue name: (NSString*) strName;
+ (BOOL) getBoolValue: (NSString*) strName;
@end
