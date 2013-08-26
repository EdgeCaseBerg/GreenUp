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

@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) UIButton *toggleGeoLogging;
@property (strong, nonatomic) UIButton *clearPoints;
@property BOOL logging;
@property (strong, nonatomic) HeatMap *heatMap;
@property (strong, nonatomic) NSDate *startedCleaning;


@property (strong, nonatomic) NSMutableArray *downloadedMapPoints;
@property (strong, nonatomic) NSMutableArray *gatheredMapPoints;
@property (strong, nonatomic) NSMutableArray *gatheredMapPointsQueue;
@property BOOL pushOverdue;



-(MapViewController *)init;
-(IBAction)dumpAllPoints:(id)sender;
-(IBAction)toggleLogging:(id)sender;
-(void)getHeatDataFromServer:(MKCoordinateSpan)span andLocation:(MKCoordinateRegion)location;
-(void)pushHeatMapDataToServer;
-(NSDictionary *)convertPointsToHeatMapFormat:(NSMutableArray *)heatMapArray;

@end
