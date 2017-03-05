//
//  Constants.h
//  Hungry
//
//  Created by ioshero 9/22/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#ifndef Hungry_Constants_h
#define Hungry_Constants_h

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define     LOADING_BAR_ANIMATION_DURATION                                  1.0f
#define     LOADING_DISH_ANIMATION_DURATION                                 20.0f
#define     DISH_BAR_INTENT                                                 20.0f

#define     YELP_CONSUMER_KEY                            @"BS-264XamAnPO26kh4-SKw"
#define     YELP_CONSUMER_SECRET                         @"U4AuB2qNWt_mgp10wG_fN9ANsLI"
#define     YELP_TOKEN                                   @"mwtUAQ7xGZ5ZblM9lq8GfFY90XNs5sig"
#define     YELP_TOKEN_SECRET                            @"s6DoMKkXfFIT4LmnYuSNwvfx6Uw"

#define     FOURSQUARE_CLIENT_ID                         @"HZRMU4LPO5RPRQQYRG4SZDUSLE33EUG45NCMINQ50CWIVVLX"
#define     FOURSQUARE_CLIENT_SECRET                     @"HU5RSWSM4LUVYPQ21D0ZLILRYW2KKO25OUUZMSSSFPM3OUBM"

#define     CARD_IO_APP_TOKEN                            @"d18cac9d42d34a5fa30b317ff2d7dfd7"

#define     kAPIHost                                     @"api.yelp.com"
#define     kSearchPath                                  @"/v2/search/"
#define     kBusinessPath                                @"/v2/business/"
#define     kSearchLimit                                 @"20"

//Paypal.
#define     PAYPAL_CLIENT_ID                             @"AQdDhhAVmMPV_d5fCnAJYSfxqwD4Jk45RuUYi-rRA3j2MWe6n7FOhu0loXFb"
#define     PAYPAL_SECRET                                @"EIExxRCGNhpyBZFFef_YTr8oDltnvMW00iQJYLGRDKQOalra6XCYi7NjAXmo"

//Notification Names.
#define     NOTI_UPDATED_LOCATION                        @"updated_location"

typedef enum
{
    SETTINGS_MENU,
    FILTER_MENU,
}

MENU_TYPE;

typedef enum
{
    MAIN_VIEW,
    ORDER_VIEW,
    
} VIEW_INDEX;


#define RECENT_LOCATION                                  @"recent_location"
#define NEARBY_LOCATION                                  @"nearby_location"

#define MIN_PROFILE_SIZE                                200
#endif
