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
#import "NSArray+Primitive.h"

#define UPLOAD_QUEUE_LENGTH 2

@interface MapViewController ()

@end

@implementation MapViewController

-(MapViewController *)init
{
    self = [super initWithNibName:@"MapView_IPhone" bundle:nil];
    self.title = @"Map";
    
    self.downloadedMapPoints = [[NSMutableArray alloc] init];
    self.gatheredMapPoints = [[NSMutableArray alloc] init];
    self.gatheredMapPointsQueue = [[NSMutableArray alloc] init];
    
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
        [[[[ContainerViewController sharedContainer] theHomeViewController] cleanUpToggleButton] setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
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
        [[[[ContainerViewController sharedContainer] theHomeViewController] cleanUpToggleButton] setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
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
        [self.gatheredMapPoints addObject:mapPoint];
        [self.gatheredMapPointsQueue addObject:mapPoint];
        
        //Update With Server        
        [self getHeatDataFromServer:self.mapView.region.span andLocation:self.mapView.region];
        //[self pushHeatMapDataToServer];
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
}

#pragma mark - Networking Methods

-(void)pushHeatMapDataToServer
{
    //If the number of gathered points in the queue array is equal to our define or we have the overdue flag set. Update our gathered points with the server!
    if(self.gatheredMapPointsQueue.count >= UPLOAD_QUEUE_LENGTH || self.pushOverdue)
    {
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        for(int i = 0; i < self.gatheredMapPointsQueue.count; i++)
        {
            HeatMapPoint *point = [self.gatheredMapPointsQueue objectAtIndex:i];
            
            //Create Parameters For Push
            NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"secondsWorked", nil];
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            [objects addFloat:point.lon];
            [objects addFloat:point.lat];
            [objects addFloat:point.secWorked];
            
            NSLog(@"PUSHING - Lat: %f", point.lat);
            NSLog(@"PUSHING - Lon: %f", point.lon);
            
            //Create Dictionary Of Parameters
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            [dataArray addObject:parameters];
        }
        
        //Parse NSDictionary to JSON
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArray
                                                           options:0
                                                             error:&error];

        
        //Check If Parsing Worked Correctly
        NSString *jsonString;
        if (!jsonData)
        {
            NSLog(@"Got an error: %@", error);
        }
        else
        {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        char *payload=[jsonString UTF8String];
        
        //Perform a POST
        //NSString *hostString = [url absoluteString];
        //char *host=[hostString UTF8String];
        
        char *request = gh_build_put_query([BASE_URL UTF8String], "/api/heatmap", payload);
        char *charPointer = gh_make_request(request, [BASE_URL UTF8String], "127.0.0.1", API_PORT);
        NSLog(@"response was: %s", charPointer);
        
        //always call free
        free(charPointer);
    }
}
-(void)getHeatDataFromServer:(MKCoordinateSpan)span andLocation:(MKCoordinateRegion)location
{
    NSURL *url = [NSURL URLWithString:HEAT_MAP_URL];
    
    NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"latOffset", @"lonOffset", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithFloat:location.center.latitude], [NSNumber numberWithFloat:location.center.longitude], [NSNumber numberWithFloat:span.latitudeDelta], [NSNumber numberWithFloat:span.longitudeDelta], nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    NSLog(@"Lon: %f", location.center.longitude);
    NSLog(@"Lat: %f", location.center.latitude);
    NSLog(@"Span-Lon: %f", span.longitudeDelta);
    NSLog(@"Span-Lat: %f", span.latitudeDelta);
    
    //Perform a GET
    //NSString *hostString = [url absoluteString];
    //char *host=[hostString UTF8String];
   
    char * request = gh_build_get_query([BASE_URL UTF8String], "/api/heatmap");
    char *charPointer = gh_make_request(request, [BASE_URL UTF8String], "127.0.0.1", API_PORT);
    NSString *response = [NSString stringWithFormat:@"%s", charPointer];
    
    NSLog(@"response was: %@", response);
    
#warning NEED TO PARSE NSSTRING INTO NSARRAY OF NSDICTIONARIES
    
    //Aways call free
    free(charPointer);
    
    //Loop through downloaded points and remove any duplicates found in gatherHeatMapPoints, then add the remaining new ones to gatheredHeatMapPoints
    
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
