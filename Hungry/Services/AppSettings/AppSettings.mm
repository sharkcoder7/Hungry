//
//  AppSetting.m
//  fruitGame
//
//  Created by KCU on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppSettings.h"


@implementation AppSettings

+ (void) defineUserDefaults
{
	NSString* userDefaultsValuesPath;
	NSDictionary* userDefaultsValuesDict;
	
	// load the default values for the user defaults
	userDefaultsValuesPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
	userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile: userDefaultsValuesPath];
	[[NSUserDefaults standardUserDefaults] registerDefaults: userDefaultsValuesDict];
}

+(void) storeObject: (NSString*) strName obj: (id) obj
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:obj forKey: strName];	
	[NSUserDefaults resetStandardUserDefaults];
}
	
+(id) loadObject: (NSString*) strName
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults objectForKey: strName];
}

+ (void) setIntValueWithName: (int) nValue name: (NSString*) strName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aFlag  =	[NSNumber numberWithFloat: nValue];	
	[defaults setObject:aFlag forKey: strName];	
	[NSUserDefaults resetStandardUserDefaults];
}

+ (int) getIntValue: (NSString*) strName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	int score = (int)[defaults integerForKey: strName];
	return score;  
}

+ (void) setBoolValueWithName: (BOOL) bValue name: (NSString*) strName
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber* aVolume  =	[[NSNumber alloc] initWithBool: bValue];	
	[defaults setObject:aVolume forKey: strName];	
	[NSUserDefaults resetStandardUserDefaults];	    
}

+ (BOOL) getBoolValue: (NSString*) strName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey :strName];
}

@end
