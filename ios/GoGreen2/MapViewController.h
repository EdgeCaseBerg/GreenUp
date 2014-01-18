//
//  MapViewController.h
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#define METERS_PER_MILE 1609.344

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HeatMap.h"
#import "HeatMapView.h"
#import "BDHost.h"
#import "Reachability.h"

#define Message_Type_ADMIN @"ADMIN"
#define Message_Type_MARKER @"MARKER"
#define Message_Type_COMMENT @"COMMENT"

@class MapPinSelectorView, HeatMapPin;

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) UIButton *toggleGeoLogging;
@property (strong, nonatomic) UIButton *clearPoints;
@property BOOL logging;
@property BOOL loggingForMarker;
@property (strong, nonatomic) HeatMap *heatMap;
@property (strong, nonatomic) NSDate *startedCleaning;

@property (strong, nonatomic) NSMutableArray *downloadedMapPoints;
@property (strong, nonatomic) NSMutableArray *gatheredMapPoints;
@property (strong, nonatomic) NSMutableArray *gatheredMapPointsQueue;

@property (strong, nonatomic) NSMutableArray *downloadedMapPins;
@property (strong, nonatomic) NSMutableArray *gatheredMapPins;

@property (strong, nonatomic) NSDate *longPressTimer;
@property (strong, nonatomic) MapPinSelectorView *mapSpinner;
@property (strong, nonatomic) HeatMapPin *tempPinRef;
@property (strong, nonatomic) NSNumber *pinIDToShow;
@property (strong, nonatomic) UIView *fadeView;

@property BOOL updatingView;
@property BOOL finishedDownloadingHeatMap;
@property BOOL finishedDownloadingMapPins;
@property BOOL pushedHeatMap;
@property BOOL pusheMapPins;

@property BOOL pushOverdue;
@property BOOL centerOnCurrentLocation;
@property BOOL drivingAlertShown;

@property (strong, nonatomic) NSDictionary *lastViewedLocation;


-(MapViewController *)init;
-(IBAction)toggleLogging:(id)sender;
-(void)getHeatDataFromServer:(MKCoordinateSpan)span andLocation:(MKCoordinateRegion)location;
-(void)pushHeatMapDataToServer;
-(NSDictionary *)convertPointsToHeatMapFormat:(NSMutableArray *)heatMapArray;

@end
