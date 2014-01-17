//
//  NetworkingController.m
//  HockeyApp
//
//  Created by Anders Melen on 11/5/13.
//  Copyright (c) 2013 . All rights reserved.
//

#import "NetworkingController.h"
#import <MapKit/MapKit.h>
#import "ContainerViewController.h"
#import "HeatMapPin.h"
#import "HeatMapPoint.h"
#import "NSArray+Primitive.h"

#define UPLOAD_QUEUE_LENGTH 5

#define API_PORT 31337

#define BASE_HOST @"199.195.248.180"
#define HEAT_MAP_RELATIVE_URL @"/api/heatmap"
#define COMMENTS_RELATIVE_URL @"/api/comments"
#define PINS_RELATIVE_URL @"/api/pins"

//Map Requests
NSURLConnection *getMapPinsConnection = nil;
NSMutableData *getMapPinsData = nil;
int getMapPinsStatusCode = -1;

NSURLConnection *getMapPinsForShowConnection = nil;
NSMutableData *getMapPinsForShowData = nil;
int getMapPinsForShowStatusCode = -1;

NSURLConnection *postMarkerConnection = nil;
NSMutableData *postMarkerData = nil;
int postMarkerStatusCode = -1;

NSURLConnection *pushHeatMapConnection = nil;
NSMutableData *pushHeatMapData = nil;
int pushHeatMapStatusCode = -1;

NSURLConnection *getHeatMapConnection = nil;
NSMutableData *getHeatMapData = nil;
int getHeatMapStatusCode = -1;

//Message Requests
#define REQUEST_TYPE_GET_MESSAGES__FIRST_PAGE_SHOW_MESSAGE 5
#define REQUEST_TYPE_GET_MESSAGES 6
#define REQUEST_TYPE_GET_MESSAGE_FOR_APPENDING_FOR_SCROLLING 7
#define REQUEST_TYPE_GET_MESSAGE_FOR_APPENDING_FOR_SHOW_MESSAGE 8
#define REQUEST_TYPE_POST_MESSAGE 9

static NetworkingController *sharedNetworkingController;

@implementation NetworkingController

+ (NetworkingController *) shared
{
	if (sharedNetworkingController == nil)
	{
		sharedNetworkingController = [[NetworkingController alloc] init];
	}
	return sharedNetworkingController;
}

#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    if([connection isEqual:getMapPinsConnection])
    {
        getMapPinsData = [[NSMutableData alloc] init];
        getMapPinsStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:getMapPinsForShowConnection])
    {
        getMapPinsForShowData = [[NSMutableData alloc] init];
        getMapPinsForShowStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:postMarkerConnection])
    {
        postMarkerData = [[NSMutableData alloc] init];
        postMarkerStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:pushHeatMapConnection])
    {
        pushHeatMapData = [[NSMutableData alloc] init];
        pushHeatMapStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:getHeatMapConnection])
    {
        getHeatMapData = [[NSMutableData alloc] init];
        getHeatMapStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    if([connection isEqual:getMapPinsConnection])
    {
        [getMapPinsData appendData:data];
    }
    else if([connection isEqual:getMapPinsForShowConnection])
    {
        [getMapPinsForShowData appendData:data];
    }
    else if([connection isEqual:postMarkerConnection])
    {
        [postMarkerData appendData:data];
    }
    else if([connection isEqual:pushHeatMapConnection])
    {
        [pushHeatMapData appendData:data];
    }
    else if([connection isEqual:getHeatMapConnection])
    {
        [getHeatMapData appendData:data];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Handle Request
    if([connection isEqual:getMapPinsConnection])
    {
        NSDictionary *response = nil;
        if(getMapPinsData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            NSLog(@"Network - Map: Recieved %d New Map Pins", [[response objectForKey:@"pins"] count]);
            NSLog(@"--- Data - Map: %@", [response objectForKey:@"pins"]);
            
            [[[ContainerViewController sharedContainer] theMapViewController].downloadedMapPins removeAllObjects];
            
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
                
                [[[ContainerViewController sharedContainer] theMapViewController].downloadedMapPins addObject:newPin];
            }
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
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
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:statusCode];
        }
        
        getMapPinsConnection = nil;
    }
    else if([connection isEqual:getMapPinsForShowConnection])
    {
        NSDictionary *response = nil;
        if(getMapPinsForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsForShowData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            [[[ContainerViewController sharedContainer] theMapViewController].downloadedMapPins removeAllObjects];
            
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
            
            [[[ContainerViewController sharedContainer] theMapViewController].downloadedMapPins addObject:newPin];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingPinsForShowPin" object:[NSNumber numberWithInt:statusCode.integerValue]];
        }
        else
        {
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingPinsForShowPin" object:[NSNumber numberWithInt:statusCode.integerValue]];
        }
        
        getMapPinsForShowData = nil;
    }
    else if([connection isEqual:postMarkerConnection])
    {
        NSDictionary *response = nil;
        if(postMarkerData != nil)
            response = [NSJSONSerialization JSONObjectWithData:postMarkerData options:0 error:nil];
        
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
            [[[ContainerViewController sharedContainer] theMapViewController].mapView removeAnnotation:[[ContainerViewController sharedContainer] theMapViewController].tempPinRef];
            
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
                [[[ContainerViewController sharedContainer] theMapViewController].mapView removeAnnotation:[[ContainerViewController sharedContainer] theMapViewController].tempPinRef];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Post Pin" message:[NSString stringWithFormat:@"Server says: %@", [response objectForKey:@"Error_Message"]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                //Worked
                [[ContainerViewController sharedContainer] theMapViewController].tempPinRef.pinID = [NSNumber numberWithLongLong:pinID.longLongValue];
            }
        }
        
        //self.tempPinRef = nil;
        
        postMarkerConnection = nil;
    }
    else if([connection isEqual:pushHeatMapConnection])
    {
        NSDictionary *response = nil;
        if(pushHeatMapData != nil)
            response = [NSJSONSerialization JSONObjectWithData:pushHeatMapData options:0 error:nil];
        
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
            
            [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = TRUE;
        }
        else
        {
            [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = FALSE;
            [[[ContainerViewController sharedContainer] theMapViewController].gatheredMapPointsQueue removeAllObjects];
        }
        
        pushHeatMapConnection = nil;
    }
    else if([connection isEqual:getHeatMapConnection])
    {
        NSDictionary *response = nil;
        if(getHeatMapData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getHeatMapData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            [[[ContainerViewController sharedContainer] theMapViewController].downloadedMapPoints removeAllObjects];
            
            NSLog(@"Network - Map: Recieved %d New Heat Map Points", [[response objectForKey:@"grid"] count]);
            NSLog(@"--- Data - Map: %@", [response objectForKey:@"grid"]);
            
            for(NSDictionary *pointDictionary in [response objectForKey:@"grid"])
            {
                HeatMapPoint *newPoint = [[HeatMapPoint alloc] init];
                double lat = [[pointDictionary objectForKey:@"latDegrees"] doubleValue];
                double lon = [[pointDictionary objectForKey:@"lonDegrees"] doubleValue];
                double secWorked = [[pointDictionary objectForKey:@"secondsWorked"] doubleValue];
                
                newPoint.lat = lat;
                newPoint.lon = lon;
                newPoint.secWorked = secWorked;
                
                [[[ContainerViewController sharedContainer] theMapViewController].downloadedMapPoints addObject:newPoint];
            }
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingHeatMap = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingHeatMap" object:statusCode];
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
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingHeatMap = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingHeatMap" object:statusCode];
        }
        
        getHeatMapConnection = nil;
    }
    /*
    else if(self.currentRequest == REQUEST_TYPE_GET_MESSAGES__FIRST_PAGE_SHOW_MESSAGE)
    {
        
    }
    else if(self.currentRequest == REQUEST_TYPE_GET_MESSAGES)
    {
        
    }
    else if(self.currentRequest == REQUEST_TYPE_GET_MESSAGE_FOR_APPENDING_FOR_SCROLLING)
    {
        
    }
    else if(self.currentRequest == REQUEST_TYPE_GET_MESSAGE_FOR_APPENDING_FOR_SHOW_MESSAGE)
    {
        
    }
    else if(self.currentRequest == REQUEST_TYPE_POST_MESSAGE)
    {
        
    }*/
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    /*
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: *************** WANRING ***************");
    NSLog(@"Network - Map: *********** Request Failed ************");
    NSLog(@"Network - Map: %@", response);
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: ***************************************");
    */
    
    if([connection isEqual:getMapPinsConnection])
    {
        NSDictionary *response = nil;
        if(getMapPinsData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsData options:0 error:nil];
        
        [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:@"-1"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Pins" message:@"You dont appear to have a network connection, please connect and retry loading the map." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([connection isEqual:getMapPinsForShowConnection])
    {
        NSDictionary *response = nil;
        if(getMapPinsForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsForShowData options:0 error:nil];
        
        [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:[NSNumber numberWithInt:-1]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Pins" message:@"You dont appear to have a network connection, please connect and retry loading the map." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([connection isEqual:postMarkerConnection])
    {
        NSDictionary *response = nil;
        if(postMarkerData != nil)
            response = [NSJSONSerialization JSONObjectWithData:postMarkerData options:0 error:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Post Pin" message:@"You dont appear to have a network connection, please connect and retry posting the pin." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([connection isEqual:pushHeatMapConnection])
    {
        NSDictionary *response = nil;
        if(pushHeatMapData != nil)
            response = [NSJSONSerialization JSONObjectWithData:pushHeatMapData options:0 error:nil];
        
        //If We Dont Have Service, Mark As Overdue
        [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = TRUE;
    }
    else if([connection isEqual:getHeatMapConnection])
    {
        NSLog(@"wtf");
    }
    /*
    else if(self.currentRequest == REQUEST_TYPE_GET_MESSAGES__FIRST_PAGE_SHOW_MESSAGE)
    {
        
    }
    else if(self.currentRequest == REQUEST_TYPE_GET_MESSAGES)
    {
        
    }
    else if(self.currentRequest == REQUEST_TYPE_GET_MESSAGE_FOR_APPENDING_FOR_SCROLLING)
    {
        
    }
    else if(self.currentRequest == REQUEST_TYPE_GET_MESSAGE_FOR_APPENDING_FOR_SHOW_MESSAGE)
    {
        
    }
    else if(self.currentRequest == REQUEST_TYPE_POST_MESSAGE)
    {
        
    }
    
    self.currentRequest = -1;*/
}

#pragma mark - Map Request Methods

-(void)getMapPinsWithMap:(MKMapView *)mapView
{
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?latDegrees=%f&lonDegrees=%f&latOffset=%f&lonOffset=%f", BASE_HOST, API_PORT, PINS_RELATIVE_URL, mapView.region.center.latitude, mapView.region.center.longitude, mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta];
    
    NSLog(@"Network - Map: Getting Pins With Data,");
    NSLog(@"--- Data - Map: Current Lat = %f", mapView.region.center.latitude);
    NSLog(@"--- Data - Map: Current Lon = %f", mapView.region.center.longitude);
    NSLog(@"--- Data - Map: Current Lat Delta = %f", mapView.region.span.latitudeDelta);
    NSLog(@"--- Data - Map: Current Lon Delta = %f", mapView.region.span.longitudeDelta);
    NSLog(@"Networking - Map: Final URL String: %@", urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
    
    //Fire Off Request
    getMapPinsConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)getMapPinsForPinShowWithMap:(MKMapView *)mapView
{
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?id=%@", BASE_HOST, API_PORT, PINS_RELATIVE_URL, [[ContainerViewController sharedContainer] theMapViewController].pinIDToShow.stringValue];
    
    NSLog(@"Network - Map: Getting Map Pin for Pin Show");
    NSLog(@"--- Data - Map: Pin Id: %@", [[ContainerViewController sharedContainer] theMapViewController].pinIDToShow.stringValue);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
    
    //Fire Off Request
    getMapPinsConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)postMarkerWithPin:(HeatMapPin *)pin andMessage:(NSString *)message
{
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?id=%@", BASE_HOST, API_PORT, PINS_RELATIVE_URL, [[ContainerViewController sharedContainer] theMapViewController].pinIDToShow.stringValue];
    
    pin.message = message;
    
    //Perform Post Code To Update With Server
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    [objects addFloat:pin.coordinate.latitude];
    [objects addFloat:pin.coordinate.longitude];
    [objects addObject:Message_Type_MARKER];
    [objects addObject:message];
    [objects addBool:FALSE];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:[NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"type", @"message", @"addressed", nil]];
    
    NSLog(@"Network - Map: Pushing New Marker With Data,");
    NSLog(@"--- Data - Map: Lat = %f", pin.coordinate.latitude);
    NSLog(@"--- Data - Map: Lon = %f", pin.coordinate.longitude);
    NSLog(@"--- Data - Map: Type = %@", Message_Type_MARKER);
    NSLog(@"--- Data - Map: Message = %@", message);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"POST"];

    //Create Data From Request Dictionary
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    [request setHTTPBody:requestData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
    
    request.timeoutInterval = 10;
    
    //Fire Off Request
    postMarkerConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)pushHeatMapPoints
{
    NSLog(@"Message - Map: Pushing Heatmap Data To Server");
    NSLog(@"--- Data - Map: QUEUE LIMIT = %d", UPLOAD_QUEUE_LENGTH);
    NSLog(@"--- Data - Map: Gathered Queue = %d", [[ContainerViewController sharedContainer] theMapViewController].gatheredMapPoints.count);
    NSLog(@"--- Data - Map: Push Overdue = %d", [[ContainerViewController sharedContainer] theMapViewController].pushOverdue);
    
    if([[ContainerViewController sharedContainer] theMapViewController].gatheredMapPointsQueue.count >= UPLOAD_QUEUE_LENGTH || [[ContainerViewController sharedContainer] theMapViewController].pushOverdue)
    {
        if(![[ContainerViewController sharedContainer] networkingReachability])
        {
            //If We Dont Have Service, Mark As Overdue
            [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = TRUE;
        }
        else
        {
            //If We Do Have Service Push That Bitch
            NSLog(@"Message - Map: Push Queue Limit Reached, Push Data,");
            
            int sentCount = 0;
            NSMutableArray *dataArray = [[NSMutableArray alloc] init];
            for(int i = 0; i < [[ContainerViewController sharedContainer] theMapViewController].gatheredMapPointsQueue.count; i++)
            {
                sentCount++;
                HeatMapPoint *point = [[[ContainerViewController sharedContainer] theMapViewController].gatheredMapPointsQueue objectAtIndex:i];
                
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
            
            //Build Request URL
            NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", BASE_HOST, API_PORT, HEAT_MAP_RELATIVE_URL];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:10];
            
            //Configure Request
            [request setHTTPMethod: @"PUT"];
            
            NSMutableArray *playersArray = [[NSMutableArray alloc] init];
            
            //Create Data From Request Dictionary
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:nil];
            [request setHTTPBody:requestData];
            
            request.timeoutInterval = 10;
            
            [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
            
            //Fire Off Request
            pushHeatMapConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
}

-(void)getHeatDataPointsWithSpan:(MKCoordinateSpan)span andLocation:(MKCoordinateRegion)location
{
    [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingHeatMap = FALSE;
     
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

    //Build Request URL
    //NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?latDegrees=%f&lonDegrees=%f&latOffset=%f&lonOffset=%f&precision=%d", BASE_HOST, API_PORT, HEAT_MAP_RELATIVE_URL, location.center.latitude, location.center.longitude, span.latitudeDelta, span.longitudeDelta, precision.integerValue];
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", BASE_HOST, API_PORT, HEAT_MAP_RELATIVE_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;

    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
    
    //Fire Off Request
    getHeatMapConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
}

#pragma mark - Message Request Methods


/*
-(void)updatePlayers:(NSMutableSet *)players
{
    //Set Request Type
    self.currentRequest = REQUEST_TYPE_SYNC_PLAYERS;
 
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@player/",API_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"PUT"];
    NSMutableArray *playersArray = [[NSMutableArray alloc] init];
    
    //Build Request Dictionary
    for(Player *player in players)
    {
        [playersArray addObject:[player parseObjectToJSON]];
    }
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] init];
    [dataDictionary setObject:playersArray forKey:@"players"];
    
    Recruiter *loggedInRecruiter = [[theCoreDataController fetchAllObjectsWithEntityName:Recruiter_Entity andSortDescriptors:nil] lastObject];

    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:loggedInRecruiter.recruiterID.stringValue, loggedInRecruiter.recruiterToken, nil] forKeys:[NSArray arrayWithObjects:@"id", @"token",nil]];
    [dataDictionary setObject:userDictionary forKey:@"user"];
    
    //Create Data From Request Dictionary
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:dataDictionary options:0 error:nil];
    [request setHTTPBody:requestData];
    
    request.timeoutInterval = 10;
    
    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
    
    //Fire Off Request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password
{
    //Set Request Type
    self.currentRequest = REQUEST_TYPE_LOGIN;
    
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@authentication/",API_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"POST"];
    NSMutableDictionary *authenticationData = [[NSMutableDictionary alloc] init];
    [authenticationData setValue:username forKey:@"email"];
    [authenticationData setValue:password forKey:@"password"];
    
    //Create Data From Request Dictionary
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:authenticationData options:0 error:nil];
    [request setHTTPBody:requestData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:0 completionHandler:nil];
    
    request.timeoutInterval = 10;
 
    //Fire Off Request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}*/

@end
