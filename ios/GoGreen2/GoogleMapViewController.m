//
//  GoogleMapViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleMapViewController ()

@end

@implementation GoogleMapViewController

-(GoogleMapViewController *)init
{
    self = [super initWithNibName:@"GoogleMapView_IPhone" bundle:nil];
    self.title = @"Google Map";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = self.mapView;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
