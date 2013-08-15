//
//  MapViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MapViewController.h"
#import "ContainerViewController.h"
#import "FSNConnection.h"
#import "HeatMapPoint.h"
#import "NSArray+Primitive.h"

#define UPLOAD_QUEUE_LENGTH 1

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
}

#pragma mark - Networking Methods

-(void)pushHeatMapDataToServer
{
    //If the number of gathered points in the queue array is equal to our define or we have the overdue flag set. Update our gathered points with the server!
    if(self.gatheredMapPointsQueue.count >= UPLOAD_QUEUE_LENGTH || self.pushOverdue)
    {
        for(HeatMapPoint *point in self.gatheredMapPointsQueue)
        {
            NSURL *url = [NSURL URLWithString:HEAT_MAP_URL];
            
            NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"secondsWorked", nil];
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            [objects addFloat:point.lat];
            [objects addFloat:point.lon];
            [objects addFloat:point.secWorked];
            
            NSLog(@"PUSHING - Lat: %f", point.lat);
            NSLog(@"PUSHING - Lon: %f", point.lon);
            
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            
            NSArray *allCalls = [NSArray arrayWithObject:parameters];
            NSDictionary *par = [[NSDictionary alloc] initWithObjects:allCalls forKeys:[NSArray arrayWithObject:@"1"]];
            
            FSNConnection *connection =
            [FSNConnection withUrl:url
                            method:FSNRequestMethodPOST
                           headers:nil
                        parameters:par
                        parseBlock:^id(FSNConnection *c, NSError **error)
             {
                 NSDictionary *d = [c.responseData dictionaryFromJSONWithError:error];
                 if(!d)
                 {
                     return nil;
                 }
                 
                 NSLog(@"%d", c.response.statusCode);
                 NSLog(@"%@",c.parameters);
                 if (c.response.statusCode == 422)
                 {
                     NSString *error = [d objectForKey:@"Error_Message"];
                     NSLog(@"%@", error);
                     
                     //There is an error, so flag as overdue and dont clear the queue
                     self.pushOverdue = TRUE;
                 }
                                  
                 return nil;
             }
                   completionBlock:^(FSNConnection *c)
             {
                 NSLog(@"complete: %@\n\nerror: %@\n\n", c, c.error);
                 
                 //push completed sucsessfuly so mark as not overdue anymore and reset the queue
                 self.pushOverdue = FALSE;
                 [self.gatheredMapPointsQueue removeAllObjects];
             }
                     progressBlock:^(FSNConnection *c)
             {
                 NSLog(@"progress: %@: %.2f/%.2f", c, c.uploadProgress, c.downloadProgress);
             }];
            
            [connection start];
        }
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
    
    FSNConnection *connection =
    [FSNConnection withUrl:url
                    method:FSNRequestMethodGET
                   headers:nil
                parameters:nil
                parseBlock:^id(FSNConnection *c, NSError **error)
     {
         FSNParseBlock parseBlock = c.parseBlock;
         
         //Clear old points
         [self.downloadedMapPoints removeAllObjects];
         
         //Add new points
         NSArray *heatMapDictionaries = [c.responseData arrayFromJSONWithError:error];
         for(NSDictionary *heatMapPoint in heatMapDictionaries)
         {
             HeatMapPoint *point = [[HeatMapPoint alloc] init];
             point.lat = [[heatMapPoint objectForKey:@"latDegrees"] doubleValue];
             point.lon = [[heatMapPoint objectForKey:@"lonDegrees"] doubleValue];
             point.secWorked = [[heatMapPoint objectForKey:@"secondsWorked"] doubleValue];
             [self.downloadedMapPoints addObject:point];
         }
         
         return nil;
     }
           completionBlock:^(FSNConnection *c)
     {
         //UPDATE HEAT MAP OVERLAY
         //[self updateHeatMapOverlay];

         //NSLog(@"complete: %@\n\nerror: %@\n\n", c, c.error);
         //NSDictionary *parse = c.parseResult;
     }
             progressBlock:^(FSNConnection *c)
     {
         //NSLog(@"progress: %@: %.2f/%.2f", c, c.uploadProgress, c.downloadProgress);
     }];
    
    [connection start];
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
