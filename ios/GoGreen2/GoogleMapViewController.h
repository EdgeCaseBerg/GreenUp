//
//  GoogleMapViewController.h
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleMapViewController : UIViewController

@property (nonatomic, strong) GMSMapView *mapView;

-(GoogleMapViewController *)init;

@end
