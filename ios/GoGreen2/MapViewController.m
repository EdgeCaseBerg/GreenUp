//
//  MapViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MapViewController.h"
#import "ContainerViewController.h"
#import "greenhttp.h"
#import "HeatMapPoint.h"
#import "CSocketController.h"
#import "NSArray+Primitive.h"
#import "MapPinSelectorView.h"
#import "HeatMapPin.h"

#import <netdb.h>
#include <arpa/inet.h>

#define UPLOAD_QUEUE_LENGTH 5
#define longPressDuration 1

@interface MapViewController ()

@end

@implementation MapViewController

-(MapViewController *)init
{
    self.mapView = [[GreenUpMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)];
    [self.view addSubview:self.mapView];
    
    self = [super initWithNibName:@"MapView_IPhone" bundle:nil];
    self.title = @"Map";
    
    self.downloadedMapPoints = [[NSMutableArray alloc] init];
    self.gatheredMapPoints = [[NSMutableArray alloc] init];
    self.gatheredMapPointsQueue = [[NSMutableArray alloc] init];
    
    //Notification Center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropMarkerAtCurrentLocation:) name:@"dropMarker" object:nil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //THIS BUTTON IS JUST FOR QUICK TESTING. SAME BUTTON AS THE HOME SCREEN!
    /*
    //Toggle Logging Button
    self.toggleGeoLogging = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toggleGeoLogging setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.toggleGeoLogging setFrame:CGRectMake(0, 65, 150, 30)];
    if(self.logging)
    {
        [self.toggleGeoLogging setTitle:@"Stop Logging" forState:UIControlStateNormal];
        [self.toggleGeoLogging setBackgroundColor:[UIColor redColor]];
    }
    else
    {
        [self.toggleGeoLogging setTitle:@"Start Logging" forState:UIControlStateNormal];
        [self.toggleGeoLogging setBackgroundColor:[UIColor greenColor]];
    }
    [self.toggleGeoLogging addTarget:self action:@selector(toggleLogging:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toggleGeoLogging];
    */
    
    //Gesture Recognizer For Custom Location Map Pin
    UILongPressGestureRecognizer *customLocationMapPinGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dropCustomMapPin:)];
    [customLocationMapPinGesture setMinimumPressDuration:.25];
    [self.mapView addGestureRecognizer:customLocationMapPinGesture];
    
    //Clear Points Button
    self.clearPoints = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.clearPoints setFrame:CGRectMake(250, 65, 70, 30)];
    [self.clearPoints setTitle:@"Clear" forState:UIControlStateNormal];
    [self.clearPoints addTarget:self action:@selector(clearAllPoints:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearPoints];
    
    //Map
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(44.468581,-73.157959);
    span.latitudeDelta=100;
    span.longitudeDelta=100;
    region.span = span;
    region.center = location;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    [self.mapView setDelegate:self];
    [_mapView setRegion:viewRegion animated:YES];
    
    //Heat Map
    self.heatMap = [[HeatMap alloc] initWithData:nil];
    [self.mapView addOverlay:self.heatMap];
    //[self updateHeatMapOverlay];
    
    //Networking
    self.pushOverdue = FALSE;
}


#pragma mark - MKMapViewDelegate

-(void)updateHeatMapOverlay
{
    //remove old overlay
    [self.mapView removeOverlay:self.heatMap];
    
    //create array of all points gathered and downloaded!
    NSMutableArray *allPoints = [[NSMutableArray alloc] initWithArray:self.downloadedMapPoints];
    [allPoints addObjectsFromArray:self.gatheredMapPoints];
    
    NSLog(@"DOWNLOADED POINTS: %d", self.downloadedMapPoints.count);
    NSLog(@"GATHERED POINTS: %d", self.gatheredMapPoints.count);
    
    //create new heatmap overlay and display it
    self.heatMap = [[HeatMap alloc] initWithData:[self convertPointsToHeatMapFormat:allPoints]];
    [self.mapView addOverlay:self.heatMap];
    [self.mapView setVisibleMapRect:[self.heatMap boundingMapRect] animated:YES];
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    return [[HeatMapView alloc] initWithOverlay:overlay];
}

#pragma mark - GPS Location Methods

-(IBAction)toggleLogging:(id)sender
{
    if(self.logging)
    {
        self.logging = FALSE;
        //[self.toggleGeoLogging setTitle:@"Start Logging" forState:UIControlStateNormal];
        //[self.toggleGeoLogging setBackgroundColor:[UIColor greenColor]];
        [self.locationManager stopUpdatingLocation];
        //Home
        [[[[ContainerViewController sharedContainer] theHomeViewController] cleanUpToggleButton] setTitle:@"Start Cleaning" forState:UIControlStateNormal];
        [[[[ContainerViewController sharedContainer] theHomeViewController] cleanUpToggleButton] setBackgroundImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.logging = TRUE;
        //[self.toggleGeoLogging setTitle:@"Stop Logging" forState:UIControlStateNormal];
        //[self.toggleGeoLogging setBackgroundColor:[UIColor redColor]];
        [self startStandardUpdates];
        
        self.startedCleaning = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
        
        //Home
        [[[[ContainerViewController sharedContainer] theHomeViewController] cleanUpToggleButton] setTitle:@"Stop Cleaning" forState:UIControlStateNormal];
        [[[[ContainerViewController sharedContainer] theHomeViewController] cleanUpToggleButton] setBackgroundImage:[UIImage imageNamed:@"Stop.png"] forState:UIControlStateNormal];
    }
}


- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 500;
    
    [self.locationManager startUpdatingLocation];
}

-(NSDictionary *)convertPointsToHeatMapFormat:(NSMutableArray *)heatMapArray
{
    //this method converts the array of points to the weird heatmap library format
    NSMutableDictionary *heatMapDictionary = [[NSMutableDictionary alloc] init];
    for(HeatMapPoint *mapPoint in heatMapArray)
    {
        MKMapPoint point = MKMapPointForCoordinate(CLLocationCoordinate2DMake(mapPoint.lat, mapPoint.lon));
        NSValue *pointValue = [NSValue value:&point withObjCType:@encode(MKMapPoint)];
        [heatMapDictionary setObject:[NSNumber numberWithInt:1] forKey:pointValue];
    }
    
    return heatMapDictionary;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 1.0)
    {
        //ADD POINTS
        HeatMapPoint *mapPoint = [[HeatMapPoint alloc] init];
        mapPoint.lat = location.coordinate.latitude;
        mapPoint.lon = location.coordinate.longitude;
        mapPoint.secWorked = 1;
        
        if(self.loggingForMarker)
        {
            //-------------- We Are Not Logging But Want To Drop Marker At Our Current Location ---------
            self.loggingForMarker = FALSE;
            
            [self.gatheredMapPoints addObject:mapPoint];
            [self.gatheredMapPointsQueue addObject:mapPoint];
            
            //Get Current Location
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            region.span = span;
            region.center = location.coordinate;
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
            
            //Stop Getting Updates
            [self.locationManager stopUpdatingLocation];
            
            //Create Pin For Current Location
            HeatMapPin *currentLocationPin = [[HeatMapPin alloc] initWithCoordinate:location.coordinate andTitle:@"Location Pin"];
            [self.mapView addAnnotation:currentLocationPin];
        }
        else if(self.loggingForMarker && self.logging)
        {
            //-------------- We Are Logging AND ALSO Want To Drop A Marker --------------
            [self.gatheredMapPoints addObject:mapPoint];
            [self.gatheredMapPointsQueue addObject:mapPoint];
            
            //Update With Server
            [self getHeatDataFromServer:self.mapView.region.span andLocation:self.mapView.region];
            [self pushHeatMapDataToServer];
            [self updateHeatMapOverlay];
            
            //Update Map Location
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            region.span = span;
            region.center = location.coordinate;
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
            
            //Create Pin For Current Location
            HeatMapPin *currentLocationPin = [[HeatMapPin alloc] initWithCoordinate:location.coordinate andTitle:@"Location Pin"];
            [self.mapView addAnnotation:currentLocationPin];
        }
        else
        {
            //-------------- We Are Logging AND Don't Want To Drop A Marker --------------
            [self.gatheredMapPoints addObject:mapPoint];
            [self.gatheredMapPointsQueue addObject:mapPoint];
            
            //Update With Server
            [self getHeatDataFromServer:self.mapView.region.span andLocation:self.mapView.region];
            [self pushHeatMapDataToServer];
            [self updateHeatMapOverlay];
            
            //Update Map Location
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            region.span = span;
            region.center = location.coordinate;
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
        }
        
        //Turn Off Pin Flag
        self.loggingForMarker = FALSE;
    }
}

#pragma mark - Drop Marker

-(IBAction)dropMarkerAtCurrentLocation:(id)sender
{
    //Set Logging For Marker Flag
    self.loggingForMarker = TRUE;
    
    //If we arn't collecting GPS data start so we can drop a marker at our current location
    if(!self.logging)
    {
        [self startStandardUpdates];
    }
}

#pragma mark - Long Press Gesture Recognizer
-(IBAction)dropCustomMapPin:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"HIT GESTURE");
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"STARTED!");
        
        //Start Timer
        self.longPressTimer = [NSDate date];
        
        //Show Spinner
        self.mapSpinner = [[MapPinSelectorView alloc] initWithMapPoint:[sender locationInView:self.view] andDuration:longPressDuration];
        [self.view addSubview:self.mapSpinner];
    }
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        NSTimeInterval elapsedTime = -[self.longPressTimer timeIntervalSinceNow];
        if(elapsedTime >= longPressDuration)
        {
            //Remove Old Timer
            self.longPressTimer = nil;
            
            //Remove Spinner
            [self.mapSpinner removeFromSuperview];
            
            //Add Map Pin
            CGPoint point = [sender locationInView:self.mapView];
            CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
            
            HeatMapPin *customPin = [[HeatMapPin alloc] initWithCoordinate:coord andTitle:@"Custom Pin"];
            [self.mapView addAnnotation:customPin];
        }
        else
        {
            //GAVE UP LONG PRESS TO EARLY REMOVE SPINNER
            [self.mapSpinner removeFromSuperview];
        }
    }
}

#pragma mark - Networking Methods

-(void)pushHeatMapDataToServer
{
    //If the number of gathered points in the queue array is equal to our define or we have the overdue flag set. Update our gathered points with the server!
    NSLog(@"COUNTER: %d - TOTAL: %d", self.gatheredMapPointsQueue.count, self.gatheredMapPoints.count);
    if(self.gatheredMapPointsQueue.count >= UPLOAD_QUEUE_LENGTH || self.pushOverdue)
    {
        NSLog(@"********************* PUSHING QUEUE LIMIT REACHED");
        int sentCount = 0;
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.gatheredMapPointsQueue.count; i++)
        {
            sentCount++;
            HeatMapPoint *point = [self.gatheredMapPointsQueue objectAtIndex:i];
            
            //Create Parameters For Push
            NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"secondsWorked", nil];
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            [objects addFloat:point.lat];
            [objects addFloat:point.lon];
            [objects addFloat:point.secWorked];
            
            NSLog(@"PUSHING - Lat: %f", point.lat);
            NSLog(@"PUSHING - Lon: %f", point.lon);
            NSLog(@"PUSHING - sec: %d", point.secWorked);
            
            
            //Create Dictionary Of Parameters
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            [dataArray addObject:parameters];
        }
        
        NSLog(@"SEND POINTS: %d", sentCount);
        
        NSDictionary *response = [[CSocketController sharedCSocketController] performPUTRequestToHost:BASE_HOST withRelativeURL:HEAT_MAP_RELATIVE_URL withPort:API_PORT withProperties:dataArray];
        NSString *statusCode = [response objectForKey:@"status_code"];
        
        if([statusCode integerValue] == 200)
        {
            NSLog(@"*************PUSH ERROR OCCURED: %@", [response objectForKey:@"Error_Message"]);
            self.pushOverdue = TRUE;
           
        }
        else
        {
            self.pushOverdue = FALSE;
            [self.gatheredMapPointsQueue removeAllObjects];
        }
        
    }
}
-(void)getHeatDataFromServer:(MKCoordinateSpan)span andLocation:(MKCoordinateRegion)location
{
    //Generation Properties
    NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"latOffset", @"lonOffset", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithFloat:location.center.latitude], [NSNumber numberWithFloat:location.center.longitude], [NSNumber numberWithFloat:span.latitudeDelta], [NSNumber numberWithFloat:span.longitudeDelta], nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    /*
    NSLog(@"Lon: %f", location.center.longitude);
    NSLog(@"Lat: %f", location.center.latitude);
    NSLog(@"Span-Lon: %f", span.longitudeDelta);
    NSLog(@"Span-Lat: %f", span.latitudeDelta);
    */
    
    NSDictionary *results = [[CSocketController sharedCSocketController] performGETRequestToHost:BASE_HOST withRelativeURL:HEAT_MAP_RELATIVE_URL withPort:API_PORT withProperties:parameters];
    NSString *statusCode = [results objectForKey:@"status_code"];
    
    if([statusCode integerValue] == 200)
    {
        for(NSDictionary *pointDictionary in [results objectForKey:@"grid"])
        {
            HeatMapPoint *newPoint = [[HeatMapPoint alloc] init];
            double lat = [[pointDictionary objectForKey:@"latDegrees"] doubleValue];
            double lon = [[pointDictionary objectForKey:@"lonDegrees"] doubleValue];
            double secWorked = [[pointDictionary objectForKey:@"secondsWorked"] doubleValue];
            
            newPoint.lat = lat;
            newPoint.lon = lon;
            newPoint.secWorked = secWorked;
            
            //Remove Duplicates I've Already Gathered
            BOOL found = FALSE;
            for(HeatMapPoint *point in self.downloadedMapPoints)
            {
                /*
                 NSLog(@"LAT: %f - %f", newPoint.lat, point.lon);
                 NSLog(@"LON: %f - %f", newPoint.lon, point.lat);
                 NSLog(@"SEC: %d - %d", newPoint.secWorked, point.secWorked);
                 */
                
                if(newPoint.lat == point.lat && newPoint.lon == point.lon && newPoint.secWorked == point.secWorked)
                {
                    NSLog(@"************ DUPLICATE FOUND DOWNLOAD");
                    found = TRUE;
                }
            }
            for(HeatMapPoint *point in self.gatheredMapPoints)
            {
                /*
                 NSLog(@"LAT: %f - %f", newPoint.lat, point.lon);
                 NSLog(@"LON: %f - %f", newPoint.lon, point.lat);
                 NSLog(@"SEC: %d - %d", newPoint.secWorked, point.secWorked);
                 */
                
                if(newPoint.lat == point.lat && newPoint.lon == point.lon && newPoint.secWorked == point.secWorked)
                {
                    NSLog(@"************ DUPLICATE FOUND IN GATHERED");
                    found = TRUE;
                }
            }
            
            if(!found)
            {
                [self.downloadedMapPoints addObject:newPoint];
            }
        }
    }
    else
    {
        NSLog(@"*************GET ERROR OCCURED: %@", [results objectForKey:@"Error_Message"]);
    }
}


-(IBAction)clearAllPoints:(id)sender
{
    [self.gatheredMapPoints removeAllObjects];
    [self.gatheredMapPointsQueue removeAllObjects];
    [self.downloadedMapPoints removeAllObjects];
    
    [self updateHeatMapOverlay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
