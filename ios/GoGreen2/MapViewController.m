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
#import "MapPinCommentView.h"
#import <netdb.h>
#include <arpa/inet.h>

#define UPLOAD_QUEUE_LENGTH 5
#define longPressDuration .5

@interface MapViewController ()

@end

@implementation MapViewController

-(MapViewController *)init
{
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        self.mapView = [[GreenUpMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 499)];
    }
    else
    {
       self.mapView = [[GreenUpMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 411)]; 
    }
    [self.view addSubview:self.mapView];
    
    self = [super initWithNibName:@"MapView_IPhone" bundle:nil];
    self.title = @"Map";
    
    self.downloadedMapPoints = [[NSMutableArray alloc] init];
    self.gatheredMapPoints = [[NSMutableArray alloc] init];
    self.gatheredMapPointsQueue = [[NSMutableArray alloc] init];
    
    self.downloadedMapPins = [[NSMutableArray alloc] init];
    self.gatheredMapPins = [[NSMutableArray alloc] init];
    
    //Drop Marker
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropMarkerAtCurrentLocation:) name:@"dropMarker" object:nil];
    //Marker Canceled
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markerWasCanceled:) name:@"markerCanceled" object:nil];
    //Marker Submitted
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postMarker:) name:@"postMarker" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:@"switchedToMap" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToMapPin:) name:@"showMapPin" object:nil];
    
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
    [customLocationMapPinGesture setMinimumPressDuration:.2];
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
    span.latitudeDelta=1000000000;
    span.longitudeDelta=1000000000;
    region.span = span;
    region.center = location;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, 5*METERS_PER_MILE, 5*METERS_PER_MILE);
    [self.mapView setDelegate:self];
    [_mapView setRegion:viewRegion animated:YES];
    
    //Heat Map
    self.heatMap = [[HeatMap alloc] initWithData:nil];
    [self.mapView addOverlay:self.heatMap];
    
    //Networking
    self.pushOverdue = FALSE;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getHeatDataFromServer:self.mapView.region.span andLocation:self.mapView.region];
    [self getMapPins];
    [self updateHeatMapOverlay];
    [self updateHeatMapWithNewPins];
}


#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if([[[ContainerViewController sharedContainer] theMapViewController] view].frame.origin.x == 0 && [[[ContainerViewController sharedContainer] theMapViewController] view].frame.size.width != 0)
    {
        //Get heatmap data and pins from server
        [self getHeatDataFromServer:self.mapView.region.span andLocation:self.mapView.region];
        [self updateHeatMapOverlay];
        [self getMapPins];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    return [[HeatMapView alloc] initWithOverlay:overlay];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{    
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    else if([annotation isKindOfClass:[HeatMapPin class]])
    {
        if([((HeatMapPin *)annotation).type isEqualToString:Message_Type_ADMIN])
        {
            static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
            
            MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
            
            if (annotationView == nil)
            {
                annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
            }
            
            annotationView.image = [UIImage imageNamed:@"trashbag.png"];
            CGRect test = annotationView.frame;
            NSLog(@"%f - %f - %f - %f", test.origin.x, test.origin.y, test.size.width, test.size.height);
            [annotationView setFrame:CGRectMake(annotationView.frame.origin.x, annotationView.frame.origin.y - annotationView.frame.size.height, annotationView.frame.size.height, annotationView.frame.size.width)];
            
            annotationView.annotation = annotation;
            
            return annotationView;
        }
        else if([((HeatMapPin *)annotation).type isEqualToString:Message_Type_MARKER])
        {
            static NSString *annotationViewReuseIdentifier = @"annotationViewReuseIdentifier";
            
            MKAnnotationView *annotationView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewReuseIdentifier];
            
            if (annotationView == nil)
            {
                annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewReuseIdentifier];
            }
            
            annotationView.image = [UIImage imageNamed:@"trashMarker.png"];
            
            annotationView.centerOffset = CGPointMake(0, -17);
            
            annotationView.annotation = annotation;
            
            return annotationView;
        }
        else
            return nil;
    }
    else
        return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    HeatMapPin *selectedMapPin = view.annotation;
    [[[ContainerViewController sharedContainer] theMessageViewController] setPinIDToShow:selectedMapPin.pinID];
    [[ContainerViewController sharedContainer] switchMessageView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showSeletedMessage" object:nil];
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
            
            /*
            //Get Current Location
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            region.span = span;
            region.center = location.coordinate;
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
            */
            
            //Stop Getting Updates
            [self.locationManager stopUpdatingLocation];
            
            //Create Pin For Current Location
            HeatMapPin *currentLocationPin = [[HeatMapPin alloc] initWithCoordinate:location.coordinate andValiditity:TRUE andTitle:@"Location Pin" andType:Message_Type_MARKER];
            self.tempPinRef = currentLocationPin;
            
            //Save pin
            [self.gatheredMapPins addObject:currentLocationPin];

            //Add Pin To Map
            [self.mapView addAnnotation:currentLocationPin];
            
            //Show Message Overlay
            MapPinCommentView *commentView = [[MapPinCommentView alloc] initWithFrame:self.view.window.frame];
            [self.view.window addSubview:commentView];
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
            
            /*
            //Update Map Location
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            region.span = span;
            region.center = location.coordinate;
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
            */
            
            //Create Pin For Current Location
            HeatMapPin *currentLocationPin = [[HeatMapPin alloc] initWithCoordinate:location.coordinate andValiditity:TRUE andTitle:@"Location Pin" andType:Message_Type_MARKER];
            self.tempPinRef = currentLocationPin;
            
            //Save pin
            [self.gatheredMapPins addObject:currentLocationPin];
            
            //Add Pin To Map
            [self.mapView addAnnotation:currentLocationPin];
            
            //Show Message Overlay
            MapPinCommentView *commentView = [[MapPinCommentView alloc] initWithFrame:self.view.window.frame];
            [self.view.window addSubview:commentView];
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
            
            /*
            //Update Map Location
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            region.span = span;
            region.center = location.coordinate;
            [self.mapView setRegion:region animated:TRUE];
            [self.mapView regionThatFits:region];
             */
        }
        
        //Turn Off Pin Flag
        self.loggingForMarker = FALSE;
    }
}

#pragma mark - Heat Map Point Methods
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
    //[self.mapView setVisibleMapRect:[self.heatMap boundingMapRect] animated:YES];
}

#pragma mark - Map Pin Methods


-(IBAction)markerWasCanceled:(id)sender
{
    //Remove Pin Because WE Canceled
    [self.mapView removeAnnotation:self.tempPinRef];
    
    //Clear Temp
    //self.tempPinRef = nil;
}

-(void)goToMapPin:(NSNotification *)sender
{
    NSLog(@"INTEGER OF ID: %llu", self.pinIDToShow.longLongValue);
    HeatMapPin *pinToShow = nil;
    for(HeatMapPin *pin in self.downloadedMapPins)
    {
        if([pin.pinID isEqualToNumber:self.pinIDToShow])
        {
            pinToShow = pin;
        }
    }
    for(HeatMapPin *pin in self.gatheredMapPins)
    {
        if([pin.pinID isEqualToNumber:self.pinIDToShow])
        {
            pinToShow = pin;
        }
    }
    
    //Center The Map
    [self.mapView setRegion:MKCoordinateRegionMake(pinToShow.coordinate, MKCoordinateSpanMake(.015, .15)) animated:FALSE];
    
    //Add Fade View
    self.fadeView = [[UIView alloc] initWithFrame:self.mapView.frame];
    [self.fadeView setBackgroundColor:[UIColor blackColor]];
    [self.fadeView setAlpha:.8];
    [self.view addSubview:self.fadeView];
    
    //Add Fake Pin Overlay
    CGPoint pinPointInSuperView = [self.mapView convertCoordinate:pinToShow.coordinate toPointToView:self.view];
    UIImageView *fakePin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashMarker.png"]];
    [fakePin setFrame:CGRectMake(pinPointInSuperView.x - 15, pinPointInSuperView.y - 17, 30, 34)];
    [self.fadeView addSubview:fakePin];
    
    //Remove View
    [self performSelector:@selector(fadeOutFadeView:) withObject:nil afterDelay:1];
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
}


-(void)addNewDownloadedPins:(NSArray *)pins
{
    for(HeatMapPin *currentPin in pins)
    {
        BOOL found = FALSE;
        for(HeatMapPin *downloadedPin in self.downloadedMapPins)
        {
            if(downloadedPin.pinID == currentPin.pinID)
            {
                found = TRUE;
                break;
            }
        }
        
        if(!found)
            [self.downloadedMapPins addObject:currentPin];
    }
}

-(void)updateMapWithPins:(NSMutableArray *)pins
{
    //Add New
    for(HeatMapPin *pin in pins)
    {
        if(!pin.addressed)
        {
            [self.mapView addAnnotation:pin];
        }
    }
}

-(void)updateHeatMapWithNewPins
{
    //Remove Old
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //Add Downloaded Pins
    [self updateMapWithPins:self.downloadedMapPins];
}
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

-(IBAction)dropCustomMapPin:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
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
            
            HeatMapPin *customPin = [[HeatMapPin alloc] initWithCoordinate:coord andValiditity:TRUE andTitle:@"Custom Pin" andType:Message_Type_MARKER];
            self.tempPinRef = customPin;
            
            //Save pin
            [self.gatheredMapPins addObject:customPin];
            
            //Add Pin To Map
            [self.mapView addAnnotation:customPin];
            
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
    NSMutableArray *newDownloadedPins = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        //Background Process Block
        
        NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"latOffset", @"lonOffset", nil];
        
        NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithFloat:self.mapView.region.center.latitude], [NSNumber numberWithFloat:self.mapView.region.center.longitude], [NSNumber numberWithFloat:self.mapView.region.span.latitudeDelta], [NSNumber numberWithFloat:self.mapView.region.span.longitudeDelta], nil];
        
         
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];

        NSDictionary *response = [[CSocketController sharedCSocketController] performGETRequestToHost:BASE_HOST withRelativeURL:PINS_RELATIVE_URL withPort:API_PORT withProperties:parameters];
        
        dispatch_async(dispatch_get_main_queue(),^{
            //Completion Block
            
            NSString *statusCode = [response objectForKey:@"status_code"];
            
            if([statusCode integerValue] == 200)
            {
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
            }
        });
    });
}

-(IBAction)postMarker:(NSNotification *)sender
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        //Background Process Block
        NSDictionary *response = [[CSocketController sharedCSocketController] performPOSTRequestToHost:BASE_HOST withRelativeURL:PINS_RELATIVE_URL withPort:API_PORT withProperties:parameters];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            //Completion Block
            NSString *statusCode = [response objectForKey:@"status_code"];
            if([statusCode integerValue] != 200)
            {
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
                    //Request Failed Remove Pin From Map
                    [self.mapView removeAnnotation:self.tempPinRef];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Post Pin" message:[NSString stringWithFormat:@"Server says: %@", [response objectForKey:@"Error_Message"]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    //Worked
                }
            }
            
            //self.tempPinRef = nil;
        });
    });
}

-(void)pushHeatMapDataToServer
{
    //If the number of gathered points in the queue array is equal to our define or we have the overdue flag set. Update our gathered points with the server!
    NSLog(@"COUNTER: %d - TOTAL: %d", self.gatheredMapPointsQueue.count, self.gatheredMapPoints.count);
    if(self.gatheredMapPointsQueue.count >= UPLOAD_QUEUE_LENGTH || self.pushOverdue)
    {
        if(![self networkingReachability])
        {
            //If We Dont Have Service, Mark As Overdue
            self.pushOverdue = TRUE;
        }
        else
        {
            //If We Do Have Service Push That Bitch
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
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
                //Background Process Block
                NSDictionary *response = [[CSocketController sharedCSocketController] performPUTRequestToHost:BASE_HOST withRelativeURL:HEAT_MAP_RELATIVE_URL withPort:API_PORT withProperties:dataArray];
                
                
                dispatch_async(dispatch_get_main_queue(),^{
                    //Completion Block
                    NSString *statusCode = [response objectForKey:@"status_code"];
                    
                    if([statusCode integerValue] != 200)
                    {
                        NSLog(@"*************PUSH ERROR OCCURED: %@", [response objectForKey:@"Error_Message"]);
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),^{
        //Background Process Block
        NSDictionary *results = [[CSocketController sharedCSocketController] performGETRequestToHost:BASE_HOST withRelativeURL:HEAT_MAP_RELATIVE_URL withPort:API_PORT withProperties:parameters];
        
        dispatch_async(dispatch_get_main_queue(),^{
            //Completion Block
            NSString *statusCode = [results objectForKey:@"status_code"];
            
            if([statusCode integerValue] == 200)
            {
                [self.downloadedMapPoints removeAllObjects];
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
            }
            else
            {
                NSLog(@"*************GET ERROR OCCURED: %@", [results objectForKey:@"Error_Message"]);
            }
        });
    });
}

#pragma mark - Utility Methods
-(IBAction)clearAllPoints:(id)sender
{
    [self.gatheredMapPoints removeAllObjects];
    [self.gatheredMapPointsQueue removeAllObjects];
    [self.downloadedMapPoints removeAllObjects];
    
    [self updateHeatMapOverlay];
}

#pragma mark - Network Reachability
-(BOOL)networkingReachability
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }        
}

#pragma mark - Other Methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
