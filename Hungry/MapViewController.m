//
//  MapViewController.m
//  Hungry
//
//  Created by ioshero 9/29/14.
//  Copyright (c) 2014 ioshero. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()
{
    
}

@property (weak, nonatomic) IBOutlet MKMapView      *m_mapView;

@end

@implementation MapViewController
@synthesize m_selectedPlace;

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
}

//====================================================================================================
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self dropPin];
}

//====================================================================================================
- (void) dropPin
{
    CLLocation* loc = [[CLLocation alloc] initWithLatitude: [m_selectedPlace.lat floatValue] longitude: [m_selectedPlace.lng floatValue]];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, 800, 800);
    [self.m_mapView setRegion:[self.m_mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = loc.coordinate;
    point.title = m_selectedPlace.title;
    point.subtitle = m_selectedPlace.address;
    
    [self.m_mapView addAnnotation:point];
}

//====================================================================================================

@end
