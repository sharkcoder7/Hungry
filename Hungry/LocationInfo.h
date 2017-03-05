//
//  LocationInfo.h
//  Hungry
//
//  Created by ioshero 9/28/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject
{
    
}
@property(nonatomic, retain) NSString*      placeID;
@property(nonatomic, retain) NSString*      title;
@property(nonatomic, retain) NSString*      address;
@property(nonatomic, retain) NSString*      lat;
@property(nonatomic, retain) NSString*      lng;

- (id)initWithPlainText:(NSString*) plainText;
-(NSString*) getJSONString;

@end
