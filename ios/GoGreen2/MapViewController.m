//  MapViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MapViewController.h"
#import "ContainerViewController.h"
#import "HeatMapPoint.h"
#import "NSArray+Primitive.h"
#import "MapPinSelectorView.h"
#import "CoreDataHeaders.h"
#import "MapPinCommentView.h"
#import <netdb.h>
#include <arpa/inet.h>
#import "NetworkingController.h"
#import "MarkerAnnotation.h"
#import "ThemeHeader.h"

@interface MapViewController ()

@end

@implementation MapViewController

-(MapViewController *)init
{
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        self = [super initWithNibName:@"MapView_IPhone5" bundle:nil];
    }
    else
    {
        self = [super initWithNibName:@"MapView_IPhone" bundle:nil];
    }

    self.title = @"Map";
    
    
    //Drop Marker
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropMarkerAtCurrentLocation:) name:@"dropMarker" object:nil];
    //Marker Canceled
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markerWasCanceled:) name:@"markerCanceled" object:nil];
    //Marker Submitted
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postMarker:) name:@"postMarker" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prepareMapToAppear:) name:@"switchedToMap" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMapPinForPinShow) name:@"goToMapPin" object:nil];
    
    //Networking Callbacks
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatesFromNetwork:) name:@"finishedDownloadingHeatMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatesFromNetwork:) name:@"finishedDownloadingMapPins" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedPushingHeatMap:) name:@"finishedPushingHeatMap" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedPushingMapPins:) name:@"finishedPushingMapPins" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedGettingPinsForShowPin:) name:@"finishedGettingPinsForShowPin" object:nil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 499)];
    }
    else
    {
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)];
    }
    
    [self.view addSubview:self.mapView];
    
    
    [self.mapView setShowsUserLocation:TRUE];
    
    self.centerOnCurrentLocation = FALSE;
    
    //Gesture Recognizer For Custom Location Map Pin
    UILongPressGestureRecognizer *customLocationMapPinGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dropCustomMapPin:)];
    [customLocationMapPinGesture setMinimumPressDuration:.2];
    [self.mapView addGestureRecognizer:customLocationMapPinGesture];

    //Map
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(44.468581,-73.157959);
    span.latitudeDelta=100000;
    span.longitudeDelta=100000;
    region.span = span;
    region.center = location;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 10*METERS_PER_MILE, 10*METERS_PER_MILE);
    [self.mapView setDelegate:self];
    [_mapView setRegion:viewRegion animated:YES];
    [self saveLastViewedLocation:self.mapView];
    
    //Heat Map
    self.heatMap = [[HeatMap alloc] initWithData:nil];
    [self.mapView addOverlay:self.heatMap];
    
    //Networking
    self.pushOverdue = FALSE;
    
    [self saveLastViewedLocation:self.mapView];

    UIView *controlsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.mapView.frame.size.height - 48, 320, 48)];
    UIView *tintView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    [tintView setBackgroundColor:[UIColor blackColor]];
    [tintView setAlpha:0.7];
    
    UISegmentedControl *centerOnLocation = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Free", @"Center", nil]];
    if(self.centerOnCurrentLocation)
    {
        [centerOnLocation setSelectedSegmentIndex:1];
    }
    else
    {
        [centerOnLocation setSelectedSegmentIndex:0];
    }
    [centerOnLocation setTintColor:[UIColor whiteColor]];
    [centerOnLocation setFrame:CGRectMake(5, 5, 130, 27)];
    [centerOnLocation addTarget:self action:@selector(toggleCenterOnLocation:) forControlEvents:UIControlEventValueChanged];
    
    UIButton *dropPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dropPinButton setBackgroundImage:[UIImage imageNamed:@"locationMarker.png"] forState:UIControlStateNormal];
    [dropPinButton setFrame:CGRectMake(140, 5, 40, 27)];
    [dropPinButton addTarget:self action:@selector(dropMarkerAtCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
     
    UISegmentedControl *mapTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Map", @"Sat", nil]];
    [mapTypeControl setTintColor:[UIColor whiteColor]];
    [mapTypeControl addTarget:self action:@selector(toggleSateliteView:) forControlEvents:UIControlEventValueChanged];
    [mapTypeControl setFrame:CGRectMake(controlsView.frame.size.width - 135, 5, 130, 27)];
    if([[[[ContainerViewController sharedContainer] theMapViewController] mapView] mapType] == MKMapTypeStandard)
    {
        [mapTypeControl setSelectedSegmentIndex:0];
    }
    else
    {
        [mapTypeControl setSelectedSegmentIndex:1];
    }
    
    [self.view addSubview:controlsView];
    [controlsView addSubview:tintView];
    
    [controlsView addSubview:dropPinButton];
    [controlsView addSubview:mapTypeControl];
    [controlsView addSubview:centerOnLocation];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self prepareMapToAppear:nil];
}

-(IBAction)prepareMapToAppear:(NSNotification *)sender
{
    NSLog(@"Action - Map: Preparing Map View, Grabbing New Heatmap / Pin Data");
    self.finishedDownloadingHeatMap = FALSE;
    self.finishedDownloadingMapPins = FALSE;
    
    //Get Updates From Server
    [self getHeatDataFromServer];
    [self getMapPins];
}

-(void)updatesFromNetwork:(NSNotification *)sender
{
    NSLog(@"Message - Map: Updates From Network");
    NSLog(@"--- Data - Map: Finished Download Heat Map Data = %d", self.finishedDownloadingHeatMap);
    NSLog(@"--- Data - Map: Finished Download Map Pins = %d", self.finishedDownloadingMapPins);
    
    if(self.finishedDownloadingHeatMap && self.finishedDownloadingMapPins)
    {
        [self updateHeatMapOverlay];
        [self updateHeatMapWithNewPins];
    }
}

#pragma mark - Button Callbacks

-(void)toggleSateliteView:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        [self.mapView setMapType:MKMapTypeStandard];
    }
    else
    {
        [self.mapView setMapType:MKMapTypeHybrid];
    }
}

-(void)toggleCenterOnLocation:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        self.centerOnCurrentLocation = FALSE;
    }
    else
    {
        self.centerOnCurrentLocation = TRUE;
    }
}

#pragma mark - MKMapViewDelegate

-(void)saveLastViewedLocation:(MKMapView *)mapView
{
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithDouble:mapView.region.center.latitude], [NSNumber numberWithDouble:mapView.region.center.longitude], [NSNumber numberWithDouble:mapView.region.span.latitudeDelta * BUFFER_SCALER], [NSNumber numberWithDouble:mapView.region.span.longitudeDelta * BUFFER_SCALER], nil];
    NSArray *keys = [NSArray arrayWithObjects:@"lat", @"lon", @"deltaLat", @"deltaLon", nil];
    
    self.lastViewedLocation = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
}

-(BOOL)checkIfOutsideBufferZone:(MKMapView *)mapView
{
    NSLog(@"Message - Map: Checking Buffer Zone With Scaler %d", BUFFER_SCALER);
    NSNumber *lat = [self.lastViewedLocation objectForKey:@"lat"];
    NSNumber *lon = [self.lastViewedLocation objectForKey:@"lon"];
    NSNumber *latDelta = [self.lastViewedLocation objectForKey:@"deltaLat"];
    NSNumber *lonDelta = [self.lastViewedLocation objectForKey:@"deltaLon"];
    float latDeltaWithoutBuff = latDelta.floatValue / BUFFER_SCALER;
    float lonDeltaWithoutBuff = lonDelta.floatValue / BUFFER_SCALER;
    
    float newLonUpper = mapView.region.center.longitude + mapView.region.span.longitudeDelta;
    float newLonLower = mapView.region.center.longitude - mapView.region.span.longitudeDelta;
    float newLatUpper = mapView.region.center.latitude + mapView.region.span.latitudeDelta;
    float newLatLower = mapView.region.center.latitude - mapView.region.span.latitudeDelta;
    
    float oldLonUpper = lon.floatValue + lonDelta.floatValue;
    float oldLonLower = lon.floatValue - lonDelta.floatValue;
    float oldLatUpper = lat.floatValue + latDelta.floatValue;
    float oldLatLower = lat.floatValue - latDelta.floatValue;
    
    float newLonDelta = mapView.region.span.longitudeDelta;
    float newLatDelta = mapView.region.span.latitudeDelta;
    
    NSLog(@"--- Data - Map: New Upper Lon Limit = %f", newLonUpper);
    NSLog(@"--- Data - Map: New Lower Lon Limit = %f", newLonLower);
    NSLog(@"--- Data - Map: New Upper Lat Limit = %f", newLatUpper);
    NSLog(@"--- Data - Map: New Lower Lat Limit = %f", newLatLower);
    
    NSLog(@"--- Data - Map: Old Upper Lon Limit = %f", oldLonUpper);
    NSLog(@"--- Data - Map: Old Lower Lon Limit = %f", oldLonLower);
    NSLog(@"--- Data - Map: Old Upper Lat Limit = %f", oldLatUpper);
    NSLog(@"--- Data - Map: Old Lower Lat Limit = %f", oldLatLower);
    
    if(newLatUpper >= oldLatUpper ||
       newLatLower <= oldLatLower ||
       newLonUpper >= oldLonUpper ||
       newLonLower <= oldLonLower ||
       newLatDelta * 1.1 < latDeltaWithoutBuff ||
       newLonDelta * 1.1 < lonDeltaWithoutBuff)
    {
        NSLog(@"Message - Map: Outside Buffer Zone");
        return TRUE;
    }
    else
    {
        NSLog(@"Message - Map: Inside Buffer Zone");
        return FALSE;
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"Action - Map: Region Changed");
    if([[[ContainerViewController sharedContainer] theMapViewController] view].frame.origin.x == 0 && [[[ContainerViewController sharedContainer] theMapViewController] view].frame.size.width != 0)
    {
        if([self checkIfOutsideBufferZone:mapView])
        {
            [self saveLastViewedLocation:mapView];
            
            //Get heatmap data and pins from server
            self.finishedDownloadingHeatMap = FALSE;
            self.finishedDownloadingMapPins = FALSE;
            [self getHeatDataFromServer];
            [self getMapPins];
        }
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    return [[HeatMapView alloc] initWithOverlay:overlay];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if([annotation isKindOfClass: [MKUserLocation class]])
    {
        return nil;
    }
    else if([annotation isKindOfClass:[MarkerAnnotation class]])
    {
        NSString *imageName = [self getImageForMarkerNetworkType:((MarkerAnnotation *)annotation).marker.markerType];
        static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
        
        MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
        }
        
        annotationView.image = [UIImage imageNamed:imageName];
        
        annotationView.centerOffset = CGPointMake(0, -15);
        
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    else
    {
        return nil;
    }
}


-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MarkerAnnotation *selectedAnnotation = view.annotation;
    Marker *selectedMarker = selectedAnnotation.marker;
    if([selectedMarker respondsToSelector:@selector(pinID)])
    {
        NSNumber *markerID = selectedMarker.markerID;
        [[[ContainerViewController sharedContainer] theMessageViewController] setPinIDToShow:markerID];
        [[ContainerViewController sharedContainer] switchMessageView];
        [[NetworkingController shared] getMessageForMessageID:markerID.integerValue];
    }
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
    {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        // Set a movement threshold for new events.
        self.locationManager.distanceFilter = MIN_DISTANCE_FOR_UPDATES;
    }
        
    [self.locationManager startUpdatingLocation];
}

-(NSDictionary *)convertPointsToHeatMapFormat:(NSArray *)heatMapArray
{
    //this method converts the array of points to the weird heatmap library format
    NSMutableDictionary *heatMapDictionary = [[NSMutableDictionary alloc] init];
    for(HeatmapPoint *mapPoint in heatMapArray)
    {
        MKMapPoint point = MKMapPointForCoordinate(CLLocationCoordinate2DMake(mapPoint.latDegrees.doubleValue, mapPoint.lonDegrees.doubleValue));
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
    if(abs(howRecent) < 1.0)
    {
        NSLog(@"Message - Map: Found GPS Location");
        [self centerMapWithCurrentLocation:location];
        
        if(self.loggingForMarker)
        {
            //-------------- We Are Not Logging But Want To Drop Marker At Our Current Location ---------
            self.loggingForMarker = FALSE;
            
            //Stop Getting Updates
            [self.locationManager stopUpdatingLocation];
            
            self.tempPinLocation = location.coordinate;
            
            //Show Message Overlay
            MapPinCommentView *commentView = [[MapPinCommentView alloc] initWithFrame:self.view.window.frame];
            [self.view.window addSubview:commentView];
        }
        else if(self.loggingForMarker && self.logging)
        {
            //-------------- We Are Logging AND ALSO Want To Drop A Marker --------------
            //ADD POINTS
            HeatmapPoint *mapPoint = [theCoreDataController insertNewEntityWithName:CORE_DATA_HEATMAPPOINT];
            mapPoint.latDegrees = [NSNumber numberWithInt:location.coordinate.latitude];
            mapPoint.lonDegrees = [NSNumber numberWithInt:location.coordinate.longitude];
            mapPoint.secondsWorked = @1;
            mapPoint.needsPush = @TRUE;
            [theCoreDataController saveContext];
            
            if(location.speed < MAX_METERS_PER_SECOND)
            {
                self.drivingAlertShown = FALSE;
                
                self.loggingForMarker = FALSE;
                
                //Update With Server
                [self getHeatDataFromServer];
                [self pushHeatMapDataToServer];
                [self updateHeatMapOverlay];
            }
            else
            {
                if(!self.drivingAlertShown)
                {
                    [self showDrivingAlert];
                }
            }
            
            self.tempPinLocation = location.coordinate;
            
            //Show Message Overlay
            MapPinCommentView *commentView = [[MapPinCommentView alloc] initWithFrame:self.view.window.frame];
            [self.view.window addSubview:commentView];
        }
        else
        {
            //-------------- We Are Logging AND Don't Want To Drop A Marker --------------
            //ADD POINTS
            HeatmapPoint *mapPoint = [theCoreDataController insertNewEntityWithName:CORE_DATA_HEATMAPPOINT];
            mapPoint.latDegrees = [NSNumber numberWithInt:location.coordinate.latitude];
            mapPoint.lonDegrees = [NSNumber numberWithInt:location.coordinate.longitude];
            mapPoint.secondsWorked = @1;
            mapPoint.needsPush = @TRUE;
            [theCoreDataController saveContext];
            
            if(location.speed < MAX_METERS_PER_SECOND)
            {
                self.drivingAlertShown = FALSE;
                
                //Update With Server
                [self getHeatDataFromServer];
                [self pushHeatMapDataToServer];
                [self updateHeatMapOverlay];
            }
            else
            {
                if(!self.drivingAlertShown)
                {
                    [self showDrivingAlert];
                }
            }
        }
    }
}

-(void)centerMapWithCurrentLocation:(CLLocation *)location
{
    if(self.centerOnCurrentLocation)
    {
        //Update Map Location
        MKCoordinateRegion region;
        //MKCoordinateSpan span;
        //span.latitudeDelta = 0.005;
        //span.longitudeDelta = 0.005;
        region.span = self.mapView.region.span;
        region.center = location.coordinate;
        [self.mapView setRegion:region animated:TRUE];
        [self.mapView regionThatFits:region];
    }
}

-(void)showDrivingAlert
{
    self.drivingAlertShown = TRUE;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you Driving?" message:@"Either you're the world's fastest %@ or you're driving around. We wan't accurate results so once you slow it down you can start " delegate:nil cancelButtonTitle:@"I'm Driving" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - Heat Map Point Methods
-(void)updateHeatMapOverlay
{
    //remove old overlay
    [self.mapView removeOverlay:self.heatMap];
    
    //create array of all points gathered and downloaded!
    NSArray *allPoints = [theCoreDataController fetchAllObjectsWithEntityName:CORE_DATA_HEATMAPPOINT andSortDescriptors:nil];
    
    NSLog(@"Message - Map: Updating Heat Map Overlay");
    
    //create new heatmap overlay and display it
    if(self.heatMap == nil)
    {
        NSLog(@"Message - Map: Nil Heat Overlay, initilizing");
        self.heatMap = [[HeatMap alloc] initWithData:[self convertPointsToHeatMapFormat:allPoints]];
    }
    else
    {
        NSLog(@"Message - Map: Updating Heat Overlay");
        [self.heatMap setData:[self convertPointsToHeatMapFormat:allPoints]];
    }
    [self.mapView addOverlay:self.heatMap];
    //[self.mapView setVisibleMapRect:[self.heatMap boundingMapRect] animated:YES];
}

#pragma mark - Map Pin Methods


-(IBAction)markerWasCanceled:(id)sender
{
    NSLog(@"Action - Map: Canceled Placing Marker");
    //Remove Pin Because WE Canceled
    //[self.mapView removeAnnotation:self.tempPinRef];
    
    //Clear Temp
    //self.tempPinRef = nil;
}

-(IBAction)finishedGettingPinsForShowPin:(NSNotification *)sender
{
    //Hide the loading overlay
    [[ContainerViewController sharedContainer] hideLoadingViewAbrupt:TRUE];
    
    NSNumber *statusCode = sender.object;
    if([statusCode integerValue] == 200)
    {
        Marker *pinToShow = nil;
        for(Marker *marker in [theCoreDataController fetchAllObjectsWithEntityName:CORE_DATA_MARKER andSortDescriptors:nil])
        {
            if([marker.markerID isEqualToNumber:self.pinIDToShow])
            {
                NSLog(@"Message - Map: Found Pin To Show In Downloaded Pins");
                pinToShow = marker;
            }
        }
        
        //Center The Map
        if(self.mapView.region.span.latitudeDelta > 0.025 || self.mapView.region.span.longitudeDelta > 0.025)
        {
            [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(pinToShow.latDegrees.doubleValue, pinToShow.lonDegrees.doubleValue), MKCoordinateSpanMake(0.015, 0.025)) animated:FALSE];
        }
        else
        {
            [self.mapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake(pinToShow.latDegrees.doubleValue, pinToShow.lonDegrees.doubleValue), MKCoordinateSpanMake(self.mapView.region.span.latitudeDelta, self.mapView.region.span.longitudeDelta)) animated:FALSE];
        }

        //Add Fade View
        if(self.fadeView == nil)
            self.fadeView = [[UIView alloc] initWithFrame:self.mapView.frame];
        
        [self.fadeView setBackgroundColor:[UIColor blackColor]];
        [self.fadeView setAlpha:.8];
        [self.view addSubview:self.fadeView];
        
        //Add Fake Pin Overlay
        CGPoint pinPointInSuperView = [self.mapView convertCoordinate:CLLocationCoordinate2DMake(pinToShow.latDegrees.doubleValue, pinToShow.lonDegrees.doubleValue) toPointToView:self.view];
        UIImageView *fakePin = nil;
        if([pinToShow.markerType isEqualToString:MARKER_TYPE_3_NETWORK_TYPE])
        {
            fakePin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hazardMarker.png"]];
        }
        else
        {
            fakePin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker.png"]];
        }
        [fakePin setFrame:CGRectMake(pinPointInSuperView.x - 9.5, pinPointInSuperView.y - 29, 19, 29)];
        
        [self.fadeView addSubview:fakePin];
        
        NSLog(@"Message - Map: Showing Fade View");
        
        //Remove View
        [self performSelector:@selector(fadeOutFadeView:) withObject:nil afterDelay:1];
    }
}

-(IBAction)fadeOutFadeView:(id)sender
{
    VoidBlock animate = ^
    {
        [self.fadeView setAlpha:0];
    };
    //Perform Animations
    [UIView animateWithDuration:.25 animations:animate];
    [self performSelector:@selector(removeFadeView:) withObject:nil afterDelay:.25];
}
-(IBAction)removeFadeView:(id)sender
{
    [self.fadeView removeFromSuperview];
    
    NSLog(@"Message - Map: Removing Fade View");
}

-(void)updateMapAnnotations
{
    NSLog(@"Message - Map: Adding Unaddressed Pins To Map");
    
    //Add New
    for(Marker *marker in [theCoreDataController fetchAllObjectsWithEntityName:CORE_DATA_MARKER andSortDescriptors:nil])
    {
        if(!marker.addressed.boolValue)
        {
            MarkerAnnotation *tempAnnotation = [[MarkerAnnotation alloc] initWithMarker:marker];
            [self.mapView addAnnotation:tempAnnotation];
        }
    }
}

-(void)updateHeatMapWithNewPins
{
    NSLog(@"Message - Map: Removing Old Pins From Map");
    //Remove Old
    for(MKAnnotationView *annotation in self.mapView.annotations)
    {
        if([annotation isKindOfClass:[MarkerAnnotation class]])
        {
            [self.mapView removeAnnotation:(id)annotation];
        }
    }

    //Add Downloaded Pins
    [self updateMapAnnotations];
}
-(void)dropMarkerAtCurrentLocation
{
    NSLog(@"Action - Map: Dropping Pin At Current Location");
    //Set Logging For Marker Flag
    self.loggingForMarker = TRUE;
    
    //Give us .5 seconds to see if we get a lock before showing a alert
    [self performSelector:@selector(checkIfGPSWasFoundForMakerDrop) withObject:nil afterDelay:0.5];
    
    //If we arn't collecting GPS data start so we can drop a marker at our current location
    if(!self.logging)
    {
        [self startStandardUpdates];
    }
}

-(void)checkIfGPSWasFoundForMakerDrop
{
    if(self.loggingForMarker == TRUE)
    {
        NSLog(@"Message - Map: GPS location could not be attained for dropping marker at current location. Alert has been issued to user");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GPS Lock Not Found" message:@"You can try again in a few moments when you attain a GPS lock or perform a long press on the map and drop a custom location pin" delegate:Nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
        
        self.loggingForMarker = FALSE;
    }
}

-(IBAction)dropCustomMapPin:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"Action - Map: Dropping Custom Pin (Long Press Started)");
        //Start Timer
        self.longPressTimer = [NSDate date];
        
        //Show Spinner
        self.mapSpinner = [[MapPinSelectorView alloc] initWithMapPoint:[sender locationInView:self.view] andDuration:longPressDuration];
        [self.view addSubview:self.mapSpinner];
    }
    else if(sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"Action - Map: Dropping Custom Pin (Long Press Ended)");
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
            
            self.tempPinLocation = coord;
            
            //Show Message Overlay
            MapPinCommentView *commentView = [[MapPinCommentView alloc] initWithFrame:self.view.window.frame];
            [self.view.window addSubview:commentView];
        }
        else
        {
            //GAVE UP LONG PRESS TO EARLY REMOVE SPINNER
            [self.mapSpinner removeFromSuperview];
        }
    }
}


#pragma mark - Networking Methods
-(void)getMapPins
{
    [[NetworkingController shared] getMapPinsWithDictionary:self.lastViewedLocation];
    /*
    NSLog(@"Network - Map: Getting Pins With Data,");
    if([[ContainerViewController sharedContainer] networkingReachability])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
            //Background Process Block
            
            NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"latOffset", @"lonOffset", nil];
            
            NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.mapView.region.center.latitude], [NSNumber numberWithFloat:self.mapView.region.center.longitude], [NSNumber numberWithFloat:self.mapView.region.span.latitudeDelta], [NSNumber numberWithFloat:self.mapView.region.span.longitudeDelta], nil];
            
            NSLog(@"--- Data - Map: Current Lat = %f", self.mapView.region.center.latitude);
            NSLog(@"--- Data - Map: Current Lon = %f", self.mapView.region.center.longitude);
            NSLog(@"--- Data - Map: Current Lat Delta = %f", self.mapView.region.span.latitudeDelta);
            NSLog(@"--- Data - Map: Current Lon Delta = %f", self.mapView.region.span.longitudeDelta);
            
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
            
            NSDictionary *response = [[CSocketController sharedCSocketController] performGETRequestToHost:BASE_HOST withRelativeURL:PINS_RELATIVE_URL withPort:API_PORT withProperties:parameters];
            
            dispatch_async(dispatch_get_main_queue(),^{
                //Completion Block
                
                NSString *statusCode = [response objectForKey:@"status_code"];
                
                NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
                
                if([statusCode integerValue] == 200)
                {
                    
                    NSLog(@"Network - Map: Recieved %d New Map Pins", [[response objectForKey:@"pins"] count]);
                    NSLog(@"--- Data - Map: %@", [response objectForKey:@"pins"]);
                    
                    [self.downloadedMapPins removeAllObjects];
                    
                    for(NSDictionary *networkPin in [response objectForKey:@"pins"])
                    {
                        //Add New Pins
                        HeatMapPin *newPin = [[HeatMapPin alloc] init];
                        NSString *stringPinID = [[networkPin objectForKey:@"id"] stringValue];
                        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                        [f setNumberStyle:NSNumberFormatterDecimalStyle];
                        newPin.pinID = [f numberFromString:stringPinID];
                        newPin.message = [networkPin objectForKey:@"message"];
                        newPin.coordinate = CLLocationCoordinate2DMake([[networkPin objectForKey:@"latDegrees"] doubleValue], [[networkPin objectForKey:@"lonDegrees"] doubleValue]);
                        newPin.type = [networkPin objectForKey:@"type"];
                        newPin.message = [networkPin objectForKey:@"message"];
                        newPin.addressed = [[networkPin objectForKey:@"addressed"] boolValue];
                        
                        [self.downloadedMapPins addObject:newPin];
                    }
                    
                    self.finishedDownloadingMapPins = TRUE;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:statusCode];
                }
                else
                {
                    NSLog(@"Network - Map: ***************************************");
                    NSLog(@"Network - Map: ***************************************");
                    NSLog(@"Network - Map: *************** WANRING ***************");
                    NSLog(@"Network - Map: ****** Received Bad Status Code *******");
                    NSLog(@"Network - Map: %@", response);
                    NSLog(@"Network - Map: ***************************************");
                    NSLog(@"Network - Map: ***************************************");
                    
                    self.finishedDownloadingMapPins = TRUE;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:statusCode];
                }
            });
        });
    }
    else
    {
        self.finishedDownloadingMapPins = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:@"-1"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Pins" message:@"You dont appear to have a network connection, please connect and retry loading the map." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    */
}

-(void)getMapPinForPinShow
{
    [[NetworkingController shared] getMapPinsForPinShow];
    /*
    NSLog(@"Network - Map: Getting Map Pin for Pin Show");
    if([[ContainerViewController sharedContainer] networkingReachability])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
            //Background Process Block
            
            NSLog(@"--- Data - Map: Pin Id: %@", self.pinIDToShow.stringValue);
            NSDictionary *response = [[CSocketController sharedCSocketController] performGETRequestToHost:BASE_HOST withRelativeURL:[NSString stringWithFormat:@"%@?id=%@",PINS_RELATIVE_URL, self.pinIDToShow.stringValue] withPort:API_PORT withProperties:nil];
            
            dispatch_async(dispatch_get_main_queue(),^{
                //Completion Block
                
                NSString *statusCode = [response objectForKey:@"status_code"];
                
                NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
                
                if([statusCode integerValue] == 200)
                {
                    [self.downloadedMapPins removeAllObjects];
        
                    NSDictionary *networkPin = [response objectForKey:@"pin"];
                    
                    NSLog(@"Network - Map: Recieved New Map Pin");
                    NSLog(@"--- Data - Map: %@", [response objectForKey:@"pin"]);
                    
        
                    //Add New Pins
                    HeatMapPin *newPin = [[HeatMapPin alloc] init];
                    NSString *stringPinID = [[networkPin objectForKey:@"id"] stringValue];
                    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                    [f setNumberStyle:NSNumberFormatterDecimalStyle];
                    newPin.pinID = [f numberFromString:stringPinID];
                    newPin.message = [networkPin objectForKey:@"message"];
                    newPin.coordinate = CLLocationCoordinate2DMake([[networkPin objectForKey:@"latDegrees"] doubleValue], [[networkPin objectForKey:@"lonDegrees"] doubleValue]);
                    newPin.type = [networkPin objectForKey:@"type"];
                    newPin.message = [networkPin objectForKey:@"message"];
                    newPin.addressed = [[networkPin objectForKey:@"addressed"] boolValue];
                    
                    [self.downloadedMapPins addObject:newPin];
                
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingPinsForShowPin" object:[NSNumber numberWithInt:statusCode.integerValue]];
                }
                else
                {
                    self.finishedDownloadingMapPins = TRUE;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingPinsForShowPin" object:[NSNumber numberWithInt:statusCode.integerValue]];
                }
            });
        });
    }
    else
    {
        self.finishedDownloadingMapPins = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:[NSNumber numberWithInt:-1]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Pins" message:@"You dont appear to have a network connection, please connect and retry loading the map." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    */
}

-(IBAction)postMarker:(NSNotification *)sender
{
    NSArray *parameters = sender.object;

#warning !!!!!!!!!!!!!!!!!!!!!!!
    /*Marker *customPin = [[HeatMapPin alloc] initWithCoordinate:self.tempPinLocation andValiditity:TRUE andTitle:@"Custom Pin" andType:[parameters objectAtIndex:1]];
    self.tempPinRef = customPin;
    
    //Save pin
    [self.gatheredMapPins addObject:customPin];
    
    //Add Pin To Map
    [self.mapView addAnnotation:customPin];
    
    [[NetworkingController shared] postMarkerWithPin:customPin andMessage:[parameters objectAtIndex:0] andType:[parameters objectAtIndex:1]];
    */
    
    /*
    NSLog(@"Network - Map: Pushing New Marker With Data,");
    if([[ContainerViewController sharedContainer] networkingReachability])
    {
        NSString *message = sender.object;
        self.tempPinRef.message = message;
        
        //Perform Post Code To Update With Server
        NSMutableArray *objects = [[NSMutableArray alloc] init];
        [objects addFloat:self.tempPinRef.coordinate.latitude];
        [objects addFloat:self.tempPinRef.coordinate.longitude];
        [objects addObject:Message_Type_MARKER];
        [objects addObject:message];
        [objects addBool:FALSE];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:[NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"type", @"message", @"addressed", nil]];
        
        NSLog(@"--- Data - Map: Lat = %f", self.tempPinRef.coordinate.latitude);
        NSLog(@"--- Data - Map: Lon = %f", self.tempPinRef.coordinate.longitude);
        NSLog(@"--- Data - Map: Type = %@", Message_Type_MARKER);
        NSLog(@"--- Data - Map: Message = %@", message);
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
            //Background Process Block
            NSDictionary *response = [[CSocketController sharedCSocketController] performPOSTRequestToHost:BASE_HOST withRelativeURL:PINS_RELATIVE_URL withPort:API_PORT withProperties:parameters];
            
            dispatch_async(dispatch_get_main_queue(),^{
                //Completion Block
                
                NSString *statusCode = [response objectForKey:@"status_code"];
                
                NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
                
                if([statusCode integerValue] != 200)
                {
                    NSLog(@"Network - Map: ***************************************");
                    NSLog(@"Network - Map: ***************************************");
                    NSLog(@"Network - Map: *************** WANRING ***************");
                    NSLog(@"Network - Map: ****** Received Bad Status Code *******");
                    NSLog(@"Network - Map: %@", response);
                    NSLog(@"Network - Map: ***************************************");
                    NSLog(@"Network - Map: ***************************************");
                    
                    //Request Failed Remove Pin From Map
                    [self.mapView removeAnnotation:self.tempPinRef];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Post Pin" message:[NSString stringWithFormat:@"Server says: %@", [response objectForKey:@"Error_Message"]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    NSString *pinID = [response objectForKey:@"pin_id"];
                    if(pinID == nil)
                    {
                        NSLog(@"WARNING - Map: Server Did Not Return Pin ID!");
                        //Request Failed Remove Pin From Map
                        [self.mapView removeAnnotation:self.tempPinRef];
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Post Pin" message:[NSString stringWithFormat:@"Server says: %@", [response objectForKey:@"Error_Message"]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                        [alert show];
                    }
                    else
                    {
                        //Worked
                        self.tempPinRef.pinID = [NSNumber numberWithLongLong:pinID.longLongValue];
                    }
                }
                
                //self.tempPinRef = nil;
            });
        });
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Post Pin" message:@"You dont appear to have a network connection, please connect and retry posting the pin." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }*/
}

-(void)pushHeatMapDataToServer
{
    [[NetworkingController shared] pushHeatMapPoints];
    /*
    NSLog(@"Message - Map: Pushing Heatmap Data To Server");
    NSLog(@"--- Data - Map: QUEUE LIMIT = %d", UPLOAD_QUEUE_LENGTH);
    NSLog(@"--- Data - Map: Gathered Queue = %d", self.gatheredMapPoints.count);
    NSLog(@"--- Data - Map: Push Overdue = %d", self.pushOverdue);
    
    
    //If the number of gathered points in the queue array is equal to our define or we have the overdue flag set. Update our gathered points with the server!
    if(self.gatheredMapPointsQueue.count >= UPLOAD_QUEUE_LENGTH || self.pushOverdue)
    {
        if(![[ContainerViewController sharedContainer] networkingReachability])
        {
            //If We Dont Have Service, Mark As Overdue
            self.pushOverdue = TRUE;
        }
        else
        {
            //If We Do Have Service Push That Bitch
            NSLog(@"Message - Map: Push Queue Limit Reached, Push Data,");
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
                
                //Create Dictionary Of Parameters
                NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                [dataArray addObject:parameters];
            }
            
            NSLog(@"--- Data - Map: %@", dataArray);
        
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
                //Background Process Block
                NSDictionary *response = [[CSocketController sharedCSocketController] performPUTRequestToHost:BASE_HOST withRelativeURL:HEAT_MAP_RELATIVE_URL withPort:API_PORT withProperties:dataArray];
            
                dispatch_async(dispatch_get_main_queue(),^{
                    //Completion Block
                    NSString *statusCode = [response objectForKey:@"status_code"];
                    
                    NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
                    
                    if([statusCode integerValue] != 200)
                    {
                        NSLog(@"Network - Map: ***************************************");
                        NSLog(@"Network - Map: ***************************************");
                        NSLog(@"Network - Map: *************** WANRING ***************");
                        NSLog(@"Network - Map: ****** Received Bad Status Code *******");
                        NSLog(@"Network - Map: %@", response);
                        NSLog(@"Network - Map: ***************************************");
                        NSLog(@"Network - Map: ***************************************");
                        
                        self.pushOverdue = TRUE;
                    }
                    else
                    {
                        self.pushOverdue = FALSE;
                        [self.gatheredMapPointsQueue removeAllObjects];
                    }
                });
            });
        }
    }*/
}
-(void)getHeatDataFromServer
{
    [[NetworkingController shared] getHeatDataPointsWithDictionary:self.lastViewedLocation];
    /*
    self.finishedDownloadingHeatMap = FALSE;
    
    //Generation Properties
    NSNumber *precision = nil;
    if(location.span.longitudeDelta > 2.0)
    {
        precision = @1;
    }
    else if(location.span.longitudeDelta > 0.5 && location.span.longitudeDelta < 2.0)
    {
        precision = @2;
    }
    else if(location.span.longitudeDelta > 0.2 && location.span.longitudeDelta < 0.5)
    {
        precision = @3;
    }
    else if(location.span.longitudeDelta > 0.05 && location.span.longitudeDelta < 0.2)
    {
        precision = @4;
    }
    else if(location.span.longitudeDelta < 0.05)
    {
        precision = @5;
    }
    
    NSLog(@"Network - Map: Getting Heat Map Data With Data,");
    NSLog(@"--- Data - Map: Current Precision = %f", precision.floatValue);
    NSLog(@"--- Data - Map: Current Lat = %f", location.center.latitude);
    NSLog(@"--- Data - Map: Current Lon = %f", location.center.longitude);
    NSLog(@"--- Data - Map: Current Lat Delta = %f", location.span.latitudeDelta);
    NSLog(@"--- Data - Map: Current Lon Delta = %f", location.span.longitudeDelta);
    
    NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"latOffset", @"lonOffset", @"precision", nil];
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithFloat:location.center.latitude], [NSNumber numberWithFloat:location.center.longitude], [NSNumber numberWithFloat:span.latitudeDelta], [NSNumber numberWithFloat:span.longitudeDelta], precision, nil];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        //Background Process Block
        NSDictionary *results = [[CSocketController sharedCSocketController] performGETRequestToHost:BASE_HOST withRelativeURL:HEAT_MAP_RELATIVE_URL withPort:API_PORT withProperties:parameters];
        
        dispatch_async(dispatch_get_main_queue(),^{
            //Completion Block
            NSString *statusCode = [results objectForKey:@"status_code"];
            
            NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
            
            if([statusCode integerValue] == 200)
            {
                [self.downloadedMapPoints removeAllObjects];
                
                NSLog(@"Network - Map: Recieved %d New Heat Map Points", [[results objectForKey:@"grid"] count]);
                NSLog(@"--- Data - Map: %@", [results objectForKey:@"grid"]);
                
                for(NSDictionary *pointDictionary in [results objectForKey:@"grid"])
                {
                    HeatMapPoint *newPoint = [[HeatMapPoint alloc] init];
                    double lat = [[pointDictionary objectForKey:@"latDegrees"] doubleValue];
                    double lon = [[pointDictionary objectForKey:@"lonDegrees"] doubleValue];
                    double secWorked = [[pointDictionary objectForKey:@"secondsWorked"] doubleValue];

                    newPoint.lat = lat;
                    newPoint.lon = lon;
                    newPoint.secWorked = secWorked;
                    
                    [self.downloadedMapPoints addObject:newPoint];
                }
                
                
                self.finishedDownloadingHeatMap = TRUE;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingHeatMap" object:statusCode];
            }
            else
            {
                NSLog(@"Network - Map: ***************************************");
                NSLog(@"Network - Map: ***************************************");
                NSLog(@"Network - Map: *************** WANRING ***************");
                NSLog(@"Network - Map: ****** Received Bad Status Code *******");
                NSLog(@"Network - Map: %@", results);
                NSLog(@"Network - Map: ***************************************");
                NSLog(@"Network - Map: ***************************************");
                
                self.finishedDownloadingHeatMap = TRUE;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingHeatMap" object:statusCode];
            }
        });
    });*/
}

#pragma mark - Utility Methods
-(NSString *)getImageForMarkerNetworkType:(NSString *)networkType
{
    if([networkType isEqualToString:MARKER_TYPE_1_NETWORK_TYPE])
    {
        return MARKER_TYPE_1_IMAGE_NAME;
    }
    else if([networkType isEqualToString:MARKER_TYPE_2_NETWORK_TYPE])
    {
        return MARKER_TYPE_2_IMAGE_NAME;
    }
    else if([networkType isEqualToString:MARKER_TYPE_3_NETWORK_TYPE])
    {
        return MARKER_TYPE_3_IMAGE_NAME;
    }
    else
    {
        NSAssert(TRUE, @"INVALID MARKER TYPE");
        return @"";
    }
}
-(IBAction)clearAllPoints:(id)sender
{
    NSLog(@"Action - Map: Clearing All Gathered and Downloaded Heatmap Points and Pins");
    [theCoreDataController deleteAllObjectsWithEntityName:CORE_DATA_MARKER andPredicate:nil];
    [theCoreDataController saveContext];
    
    [self updateHeatMapOverlay];
}


#pragma mark - Other Methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
