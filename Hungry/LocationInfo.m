//
//  LocationInfo.m
//  Hungry
//
//  Created by ioshero 9/28/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "LocationInfo.h"

@implementation LocationInfo
@synthesize placeID;
@synthesize title;
@synthesize address;
@synthesize lat;
@synthesize lng;

//====================================================================================================
- (NSString*) getJSONString
{
    NSString* strResult = @"";
    strResult = [strResult stringByAppendingString: [NSString stringWithFormat: @"%@XXX,", placeID]];
    strResult = [strResult stringByAppendingString: [NSString stringWithFormat: @"%@XXX,", title]];
    strResult = [strResult stringByAppendingString: [NSString stringWithFormat: @"%@XXX,", address]];
    strResult = [strResult stringByAppendingString: [NSString stringWithFormat: @"%@XXX,", lat]];
    strResult = [strResult stringByAppendingString: [NSString stringWithFormat: @"%@", lng]];
    
    return strResult;
}

//====================================================================================================
- (id)initWithPlainText:(NSString*) plainText
{
    if (self = [super init])
    {
        NSArray* arrData = [plainText componentsSeparatedByString: @"XXX,"];
        
        self.placeID = [arrData objectAtIndex: 0];
        self.title = [arrData objectAtIndex: 1];
        self.address = [arrData objectAtIndex: 2];
        self.lat = [arrData objectAtIndex: 3];
        self.lng = [arrData objectAtIndex: 4];
    }
    return self;
}


//====================================================================================================
@end
