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
#import "CoreDataHeaders.h"
#import "NSArray+Primitive.h"
#import "CoreDataHeaders.h"
#import "ThemeHeader.h"

#import <AFNetworking/AFNetworking.h>

//Home Message Requests
NSURLConnection *getHomeMessageConnection = nil;
NSMutableData *getHomeMessageData = nil;
NSInteger getHomeMessageStatusCode = -1;

//Map Requests
NSMutableData *otherData = nil;

NSURLConnection *getMapPinsConnection = nil;
NSMutableData *getMapPinsData = nil;
NSInteger getMapPinsStatusCode = -1;

NSURLConnection *getMapPinsForShowConnection = nil;
NSMutableData *getMapPinsForShowData = nil;
NSInteger getMapPinsForShowStatusCode = -1;

NSURLConnection *postMarkerConnection = nil;
NSMutableData *postMarkerData = nil;
NSInteger postMarkerStatusCode = -1;

NSURLConnection *pushHeatMapConnection = nil;
NSMutableData *pushHeatMapData = nil;
NSInteger pushHeatMapStatusCode = -1;

NSURLConnection *getHeatMapConnection = nil;
NSMutableData *getHeatMapData = nil;
NSInteger getHeatMapStatusCode = -1;

//Message Requests
NSURLConnection *getMessagesForFirstPageOfShowConnection = nil;
NSMutableData *getMessagesForFirstPageOfShowData = nil;
NSInteger getMessagesForFirstPageOfShowStatusCode = -1;

NSURLConnection *getMessagesConnection = nil;
NSMutableData *getMessagesData = nil;
NSInteger getMessagesStatusCode = -1;

NSURLConnection *getMessagesForAppendingForScrollingConnection = nil;
NSMutableData *getMessagesForAppendingForScrollingData = nil;
NSInteger getMessagesForAppendingForScrollingStatusCode = -1;

NSURLConnection *getMessagesForAppendingForShowConnection = nil;
NSMutableData *getMessagesForAppendingForShowData = nil;
NSInteger getMessagesForAppendingForShowStatusCode = -1;

NSURLConnection *postMessageConnection = nil;
NSMutableData *postMessageData = nil;
NSInteger postMessageStatusCode = -1;

NSURLConnection *addressMessageConnection = nil;
NSMutableData *addressMessageData = nil;
NSInteger addressMessageStatusCode = -1;

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

    if([connection isEqual:getHomeMessageConnection])
    {
        getHomeMessageData = [[NSMutableData alloc] init];
        getHomeMessageStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:getMapPinsConnection])
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
    else if([connection isEqual:getMessagesForFirstPageOfShowConnection])
    {
        getMessagesForFirstPageOfShowData = [[NSMutableData alloc] init];
        getMessagesForFirstPageOfShowStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:getMessagesConnection])
    {
        getMessagesData = [[NSMutableData alloc] init];
        getMessagesStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:getMessagesForAppendingForScrollingConnection])
    {
        getMessagesForAppendingForScrollingData = [[NSMutableData alloc] init];
        getMessagesForAppendingForScrollingStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:getMessagesForAppendingForShowConnection])
    {
        getMessagesForAppendingForShowData = [[NSMutableData alloc] init];
        getMessagesForAppendingForShowStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:postMessageConnection])
    {
        postMessageData = [[NSMutableData alloc] init];
        postMessageStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else if([connection isEqual:addressMessageConnection])
    {
        addressMessageData = [[NSMutableData alloc] init];
        addressMessageStatusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    else
    {
        otherData = [[NSMutableData alloc] init];
        NSLog(@"SSTOP");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to the instance variable you declared
    if([connection isEqual:getHomeMessageConnection])
    {
        [getHomeMessageData appendData:data];
    }
    else if([connection isEqual:getMapPinsConnection])
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
    else if([connection isEqual:getMessagesForFirstPageOfShowConnection])
    {
        [getMessagesForFirstPageOfShowData appendData:data];
    }
    else if([connection isEqual:getMessagesConnection])
    {
        [getMessagesData appendData:data];
    }
    else if([connection isEqual:getMessagesForAppendingForScrollingConnection])
    {
        [getMessagesForAppendingForScrollingData appendData:data];
    }
    else if([connection isEqual:getMessagesForAppendingForShowConnection])
    {
        [getMessagesForAppendingForShowData appendData:data];
    }
    else if([connection isEqual:postMessageConnection])
    {
        [postMessageData appendData:data];
    }
    else if([connection isEqual:addressMessageConnection])
    {
        [addressMessageData appendData:data];
    }
    else
    {
        [otherData appendData:data];
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

#pragma mark - Did Finish Loading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Handle Request
    if([connection isEqual:getHomeMessageConnection])
    {
#pragma mark Get Home Messages
        NSDictionary *response = nil;
        if(getHomeMessageData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getHomeMessageData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Home Message: Recieved Status Code: %@", statusCode);
        
        
        if(getHomeMessageStatusCode == 200)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingHomeMessage" object:response];
        }
        else
        {
            [self printResponseFromFailedRequest:response andStatusCode:getHomeMessageStatusCode];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingHomeMessage" object:@"-1"];
        }
        
        getHomeMessageConnection = nil;
        getHomeMessageData = nil;
        getHomeMessageStatusCode = -1;
    }
    else if([connection isEqual:getMapPinsConnection])
    {
#pragma mark Get Markers
        NSDictionary *response = nil;
        if(getMapPinsData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            NSLog(@"Network - Map: Recieved %lu New Map Pins", (unsigned long)[[response objectForKey:@"pins"] count]);
            NSLog(@"--- Data - Map: %@", [response objectForKey:@"pins"]);
            
            [theCoreDataController deleteAllObjectsWithEntityName:CORE_DATA_MARKER andPredicate:nil];
            [theCoreDataController saveContext];
            
            for(NSDictionary *networkPin in [response objectForKey:@"pins"])
            {
                //Add New Pins
                Marker *newPin = [theCoreDataController insertNewEntityWithName:CORE_DATA_MARKER];
                NSString *stringPinID = [[networkPin objectForKey:@"id"] stringValue];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                [f setNumberStyle:NSNumberFormatterDecimalStyle];
                newPin.markerID = [f numberFromString:stringPinID];
                newPin.latDegrees = [networkPin objectForKey:@"latDegrees"];
                newPin.lonDegrees = [networkPin objectForKey:@"lonDegrees"];
                newPin.markerType = [networkPin objectForKey:@"type"];
                newPin.addressed = [networkPin objectForKey:@"addressed"];
                newPin.needsPush = @FALSE;
            }
            
            [theCoreDataController saveContext];
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:statusCode];
        }
        else
        {
            [self printResponseFromFailedRequest:response andStatusCode:getMapPinsStatusCode];
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:statusCode];
        }
        
        getMapPinsConnection = nil;
        getMapPinsData = nil;
        getMapPinsStatusCode = -1;
    }
    else if([connection isEqual:getMapPinsForShowConnection])
    {
#pragma mark Get Markers For Show
        NSDictionary *response = nil;
        if(getMapPinsForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsForShowData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            [theCoreDataController deleteAllObjectsWithEntityName:CORE_DATA_MARKER andPredicate:nil];
            [theCoreDataController saveContext];
            
            NSDictionary *networkPin = [response objectForKey:@"pin"];
            
            NSLog(@"Network - Map: Recieved New Map Pin");
            NSLog(@"--- Data - Map: %@", [response objectForKey:@"pin"]);
            
            
            //Add New Pins
            Marker *newPin = [theCoreDataController insertNewEntityWithName:CORE_DATA_MARKER];
            NSString *stringPinID = [[networkPin objectForKey:@"id"] stringValue];
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            newPin.markerID = [f numberFromString:stringPinID];
            newPin.latDegrees = [networkPin objectForKey:@"latDegrees"];
            newPin.lonDegrees = [networkPin objectForKey:@"lonDegrees"];
            newPin.markerID = [networkPin objectForKey:@"type"];
            newPin.addressed = [networkPin objectForKey:@"addressed"];
            newPin.needsPush = @FALSE;
            
            [theCoreDataController saveContext];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingPinsForShowPin" object:[NSNumber numberWithInteger:statusCode.integerValue]];
        }
        else
        {
            [self printResponseFromFailedRequest:response andStatusCode:getMapPinsForShowStatusCode];
            
            [[ContainerViewController sharedContainer] removeLoadingViewFromView];
            
            [self showNoNetworkAlert];
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingPinsForShowPin" object:[NSNumber numberWithInteger:statusCode.integerValue]];
        }
        
        getMapPinsForShowConnection = nil;
        getMapPinsForShowData = nil;
        getMapPinsForShowStatusCode = -1;
    }
    else if([connection isEqual:postMarkerConnection])
    {
#pragma mark Post Marker
        NSDictionary *response = nil;
        if(postMarkerData != nil)
            response = [NSJSONSerialization JSONObjectWithData:postMarkerData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] != 200)
        {
            [self printResponseFromFailedRequest:response andStatusCode:postMarkerStatusCode];
            
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
#warning !!!!!!!!!!!!!!!!!!!!!!
                //[[[ContainerViewController sharedContainer] theMapViewController].mapView removeAnnotation:[[ContainerViewController sharedContainer] theMapViewController].tempPinRef];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could Not Post Pin" message:[NSString stringWithFormat:@"Server says: %@", [response objectForKey:@"Error_Message"]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                //Worked
#warning !!!!!!!!!!!!!!!!!!!!!!
                //[[ContainerViewController sharedContainer] theMapViewController].tempPinRef.pinID = [NSNumber numberWithLongLong:pinID.longLongValue];
            }
        }
        
        //self.tempPinRef = nil;
        
        postMarkerConnection = nil;
        postMarkerData = nil;
        postMarkerStatusCode = -1;
    }
    else if([connection isEqual:pushHeatMapConnection])
    {
#pragma mark Post Heat Map Points
        NSDictionary *response = nil;
        if(pushHeatMapData != nil)
            response = [NSJSONSerialization JSONObjectWithData:pushHeatMapData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] != 200)
        {
            [self printResponseFromFailedRequest:response andStatusCode:pushHeatMapStatusCode];
            
            [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = TRUE;
        }
        else
        {
            [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = FALSE;
        }
        
        pushHeatMapConnection = nil;
        pushHeatMapData = nil;
        pushHeatMapStatusCode = -1;
    }
    else if([connection isEqual:getHeatMapConnection])
    {
#pragma mark Get Heat Map Points
        NSDictionary *response = nil;
        if(getHeatMapData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getHeatMapData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Map: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            [theCoreDataController deleteAllObjectsWithEntityName:CORE_DATA_HEATMAPPOINT andPredicate:nil];
            [theCoreDataController saveContext];
            
            NSLog(@"Network - Map: Recieved %lu New Heat Map Points", (unsigned long)[[response objectForKey:@"grid"] count]);
            NSLog(@"--- Data - Map: %@", [response objectForKey:@"grid"]);
            
            for(NSDictionary *pointDictionary in [response objectForKey:@"grid"])
            {
                HeatmapPoint *newPoint = [theCoreDataController insertNewEntityWithName:CORE_DATA_HEATMAPPOINT];
                double lat = [[pointDictionary objectForKey:@"latDegrees"] doubleValue];
                double lon = [[pointDictionary objectForKey:@"lonDegrees"] doubleValue];
                double secWorked = [[pointDictionary objectForKey:@"secondsWorked"] doubleValue];
                
                newPoint.latDegrees = [NSNumber numberWithDouble:lat];
                newPoint.lonDegrees = [NSNumber numberWithDouble:lon];
                newPoint.secondsWorked = [NSNumber numberWithDouble:secWorked];
                newPoint.needsPush = @FALSE;
            }
            
            [theCoreDataController saveContext];
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingHeatMap = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingHeatMap" object:statusCode];
        }
        else
        {
            [self printResponseFromFailedRequest:response andStatusCode:getHeatMapStatusCode];
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingHeatMap = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingHeatMap" object:statusCode];
        }
        
        getHeatMapConnection = nil;
        getHeatMapData = nil;
        getHeatMapStatusCode = -1;
    }
    else if([connection isEqual:getMessagesForFirstPageOfShowConnection])
    {
#pragma mark Get Messages For First Page Of Show
        NSDictionary *response = nil;
        if(getMessagesForFirstPageOfShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForFirstPageOfShowData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Message: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            //Remove Old Messages Incase Removed
            [[[ContainerViewController sharedContainer] theMessageViewController].messages removeAllObjects];
            
            NSLog(@"Network - Message: Recieved %lu New Messages", (unsigned long)[[response objectForKey:@"comments"] count]);
            NSLog(@"--- Data - Message: Messages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"comments"]);
            
            NSArray *comments = [response objectForKey:@"comments"];
            //NSMutableArray *newDownloadedMessages = [[NSMutableArray alloc] init];
            for(NSDictionary *comment in comments)
            {
                Message *newMessage = [theCoreDataController insertNewEntityWithName:CORE_DATA_MESSAGE];
                newMessage.message = [comment objectForKey:@"message"];
                newMessage.messageID = [comment objectForKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"y-M-d H:m:s"];
                newMessage.timeStamp = [dateFormatter dateFromString:[comment objectForKey:@"timestamp"]];
                
                newMessage.messageType = [comment objectForKey:@"type"];
                id pinID = [comment objectForKey:@"pin"];
                if([pinID isKindOfClass:[NSNumber class]])
                {
                    newMessage.messageID = [comment objectForKey:@"pin"];
                }
                else
                {
                    newMessage.messageID = nil;
                }
                
                newMessage.needsPush = @FALSE;
                newMessage.addressed = [comment objectForKey:@"addressed"];
                //[newDownloadedMessages addObject:newMessage];
            }
            
            [theCoreDataController saveContext];
            
            NSLog(@"--- Data - Message: Pages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"page"]);
            
            NSDictionary *pages = [response objectForKey:@"page"];
            if(![[pages objectForKey:@"next"] isEqualToString:@"null"])
            {
                NSString *fullURL = [pages objectForKey:@"next"];
                NSArray *components = [fullURL componentsSeparatedByString:@"/api/"];
                [[ContainerViewController sharedContainer] theMessageViewController].nextPageURL = [NSString stringWithFormat:@"/api/%@", [components objectAtIndex:1]];
            }
            else
            {
                [[ContainerViewController sharedContainer] theMessageViewController].nextPageURL = nil;
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingMessageForFirstPageOfShowMessage" object:[NSNumber numberWithInteger:statusCode.integerValue]];
        }
        else
        {
            [self printResponseFromFailedRequest:response andStatusCode:getMessagesForFirstPageOfShowStatusCode];
        }
        
        getMessagesForFirstPageOfShowConnection = nil;
        getMessagesForFirstPageOfShowData = nil;
        getMessagesForFirstPageOfShowStatusCode = -1;
    }
    
    else if([connection isEqual:getMessagesForAppendingForScrollingConnection])
    {
#pragma mark Get Messages For Appending For Scrolling
        NSDictionary *response = nil;
        if(getMessagesForAppendingForScrollingData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForAppendingForScrollingData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Message: Recieved Status Code: %@", statusCode);
        
        NSMutableArray *newMessages = [[NSMutableArray alloc] init];;
        
        if([statusCode integerValue] == 200)
        {
            NSLog(@"Network - Message: Recieved %lu New Messages", (unsigned long)[[response objectForKey:@"comments"] count]);
            NSLog(@"--- Data - Message: Messages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"comments"]);
            
            NSArray *comments = [response objectForKey:@"comments"];
            //NSMutableArray *newDownloadedMessages = [[NSMutableArray alloc] init];
            for(NSDictionary *comment in comments)
            {
                Message *newMessage = [theCoreDataController insertNewEntityWithName:CORE_DATA_MESSAGE];
                newMessage.message = [comment objectForKey:@"message"];
                newMessage.messageID = [comment objectForKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"y-M-d H:m:s"];
                newMessage.timeStamp = [dateFormatter dateFromString:[comment objectForKey:@"timestamp"]];
                
                newMessage.messageType = [comment objectForKey:@"type"];
                id pinID = [comment objectForKey:@"pin"];
                
#warning !!!!!!!!!!!!!!!!!!!!!!!
                /*
                if([pinID isKindOfClass:[NSNumber class]])
                {
                    newMessage.pinID = [comment objectForKey:@"pin"];
                }
                else
                {
                    newMessage.pinID = nil;
                }*/
                
                newMessage.addressed = [comment objectForKey:@"addressed"];
                newMessage.needsPush = @FALSE;
                
                [newMessages addObject:newMessage];
            }
            
            [theCoreDataController saveContext];
            
            NSLog(@"--- Data - Message: Pages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"page"]);
            
            NSDictionary *pages = [response objectForKey:@"page"];
            if(![[pages objectForKey:@"next"] isEqualToString:@"null"])
            {
                NSString *fullURL = [pages objectForKey:@"next"];
                NSArray *components = [fullURL componentsSeparatedByString:@"/api/"];
                [[ContainerViewController sharedContainer] theMessageViewController].nextPageURL = [NSString stringWithFormat:@"/api/%@", [components objectAtIndex:1]];
            }
            else
            {
                [[ContainerViewController sharedContainer] theMessageViewController].nextPageURL = nil;
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingNewPageForScrolling" object:newMessages];
        }
        else
        {
            [self printResponseFromFailedRequest:response andStatusCode:getMessagesForAppendingForScrollingStatusCode];
        }
        getMessagesForAppendingForScrollingConnection = nil;
        getMessagesForAppendingForScrollingData = nil;
        getMessagesForAppendingForScrollingStatusCode = -1;
    }
    else if([connection isEqual:getMessagesForAppendingForShowConnection])
    {
#pragma mark Get Messages For Appending For Show
        NSDictionary *response = nil;
        if(getMessagesForAppendingForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForAppendingForShowData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        
        NSMutableArray *newMessages = [[NSMutableArray alloc] init];;
        
        NSLog(@"Network - Message: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            
            NSLog(@"Network - Message: Recieved %lu New Messages", (unsigned long)[[response objectForKey:@"comments"] count]);
            NSLog(@"--- Data - Message: Messages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"comments"]);
            
            NSArray *comments = [response objectForKey:@"comments"];
            //NSMutableArray *newDownloadedMessages = [[NSMutableArray alloc] init];
            for(NSDictionary *comment in comments)
            {
                Message *newMessage = [theCoreDataController insertNewEntityWithName:CORE_DATA_MESSAGE];
                newMessage.message = [comment objectForKey:@"message"];
                newMessage.messageID = [comment objectForKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"y-M-d H:m:s"];
                newMessage.timeStamp = [dateFormatter dateFromString:[comment objectForKey:@"timestamp"]];
                
                newMessage.messageType = [comment objectForKey:@"type"];
                
#warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                /*
                id pinID = [comment objectForKey:@"pin"];
                if([pinID isKindOfClass:[NSNumber class]])
                {
                    newMessage.pinID = [comment objectForKey:@"pin"];
                }
                else
                {
                    newMessage.pinID = nil;
                }*/
                
                newMessage.addressed = [comment objectForKey:@"addressed"];
                newMessage.needsPush = @FALSE;
                
                [newMessages addObject:newMessage];
            }
            
            [theCoreDataController saveContext];
            
            NSLog(@"--- Data - Message: Pages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"page"]);
            
            NSDictionary *pages = [response objectForKey:@"page"];
            if(![[pages objectForKey:@"next"] isEqualToString:@"null"])
            {
                NSString *fullURL = [pages objectForKey:@"next"];
                NSArray *components = [fullURL componentsSeparatedByString:@"/api/"];
                [[ContainerViewController sharedContainer] theMessageViewController].nextPageURL = [NSString stringWithFormat:@"/api/%@", [components objectAtIndex:1]];
            }
            else
            {
                [[ContainerViewController sharedContainer] theMessageViewController].nextPageURL = nil;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingNewPageForShowingNewMessage" object:newMessages];
        }
        else
        {
            [self printResponseFromFailedRequest:response andStatusCode:getMessagesForAppendingForShowStatusCode];
        }
        
        getMessagesForAppendingForShowConnection = nil;
        getMessagesForAppendingForShowData = nil;
        getMessagesForAppendingForShowStatusCode = -1;
    }
    else if([connection isEqual:postMessageConnection])
    {
#pragma mark Post Message
        NSDictionary *response = nil;
        if(postMessageData != nil)
            response = [NSJSONSerialization JSONObjectWithData:postMessageData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];

        if([statusCode integerValue] != 200)
        {
            NSLog(@"Network - Message: ***************************************");
            NSLog(@"Network - Message: ***************************************");
            NSLog(@"Network - Message: *************** WANRING ***************");
            NSLog(@"Network - Message: ****** Received Bad Status Code *******");
            NSLog(@"Network - Message: %@", response);
            NSLog(@"Network - Message: ***************************************");
            NSLog(@"Network - Message: ***************************************");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Failed" message:[NSString stringWithFormat:@"Server says: %@", [response objectForKey:@"Error_Message"]] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            //Reset Message Field
            [[ContainerViewController sharedContainer] theMessageViewController].messageTextView.text = @"";
            
            //Get New Messages
            [self getMessages];
        }
        
        postMessageConnection = nil;
        postMessageData = nil;
        postMessageStatusCode = -1;
    }
    else if([connection isEqual:addressMessageConnection])
    {
#pragma mark Address Message
        NSDictionary *response = nil;
        if(addressMessageData != nil)
            response = [NSJSONSerialization JSONObjectWithData:addressMessageData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        
        NSLog(@"Network - Addressed Messaged: Recieved Status Code: %@", statusCode);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedUpdatingMessageStatus" object:nil];
        
        if([statusCode integerValue] != 200)
        {
            [self showNoNetworkAlert];
            [self printResponseFromFailedRequest:response andStatusCode:addressMessageStatusCode];
        }
    }
    else
    {
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:otherData options:0 error:nil]);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([connection isEqual:getHomeMessageConnection])
    {
        NSDictionary *response = nil;
        if(getHomeMessageData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getHomeMessageData options:0 error:nil];
        
        [self printResponseFromFailedRequest:response andStatusCode:getHomeMessageStatusCode];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingHomeMessage" object:@"-1"];
    }
    else if([connection isEqual:getMapPinsConnection])
    {
        NSDictionary *response = nil;
        if(getMapPinsData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsData options:0 error:nil];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMapPinsStatusCode];
        
        [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:@"-1"];
        
        [self showNoNetworkAlert];
    }
    else if([connection isEqual:getMapPinsForShowConnection])
    {
        NSDictionary *response = nil;
        if(getMapPinsForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsForShowData options:0 error:nil];
        
        [[ContainerViewController sharedContainer] removeLoadingViewFromView];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMapPinsForShowStatusCode];
        
        [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:[NSNumber numberWithInt:-1]];
        
        [self showNoNetworkAlert];
    }
    else if([connection isEqual:postMarkerConnection])
    {
        NSDictionary *response = nil;
        if(postMarkerData != nil)
            response = [NSJSONSerialization JSONObjectWithData:postMarkerData options:0 error:nil];
        
        [self printResponseFromFailedRequest:response andStatusCode:postMarkerStatusCode];
        
        [self showNoNetworkAlert];
    }
    else if([connection isEqual:pushHeatMapConnection])
    {
        NSDictionary *response = nil;
        if(pushHeatMapData != nil)
            response = [NSJSONSerialization JSONObjectWithData:pushHeatMapData options:0 error:nil];
        
        [self printResponseFromFailedRequest:response andStatusCode:pushHeatMapStatusCode];
        
        //If We Dont Have Service, Mark As Overdue
        [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = TRUE;
    }
    else if([connection isEqual:getHeatMapConnection])
    {
        NSLog(@"wtf");
    }
    else if([connection isEqual:getMessagesForFirstPageOfShowConnection])
    {
        NSDictionary *response = nil;
        if(getMessagesForFirstPageOfShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForFirstPageOfShowData options:0 error:nil];
        
        //[self showNoNetworkAlert];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingMessageForFirstPageOfShowMessage" object:[NSNumber numberWithInt:-1]];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMessagesForFirstPageOfShowStatusCode];
    }

    else if([connection isEqual:getMessagesForAppendingForScrollingConnection])
    {
        NSDictionary *response = nil;
        if(getMessagesForAppendingForScrollingData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForAppendingForScrollingData options:0 error:nil];
        
        [self showNoNetworkAlert];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMessagesForAppendingForScrollingStatusCode];
    }
    else if([connection isEqual:getMessagesForAppendingForShowConnection])
    {
        NSDictionary *response = nil;
        if(getMessagesForAppendingForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForAppendingForShowData options:0 error:nil];
        
        [self showNoNetworkAlert];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMessagesForAppendingForShowStatusCode];
    }
    else if([connection isEqual:postMessageConnection])
    {
        NSDictionary *response = nil;
        if(postMessageData != nil)
            response = [NSJSONSerialization JSONObjectWithData:postMessageData options:0 error:nil];
        
        [self showNoNetworkAlert];
        
        [self printResponseFromFailedRequest:response andStatusCode:postMessageStatusCode];
    }
    else if([connection isEqual:addressMessageConnection])
    {
        NSDictionary *response = nil;
        if(addressMessageData != nil)
            response = [NSJSONSerialization JSONObjectWithData:addressMessageData options:0 error:nil];
        
        [self showNoNetworkAlert];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedUpdatingMessageStatus" object:nil];
        
        [self printResponseFromFailedRequest:response andStatusCode:addressMessageStatusCode];
    }
    else
    {
        NSLog(@"****WARNING**** NETWORKING CONTROLLER - INVAID REQUEST FAILED");
    }
}

#pragma mark - NEW METHODS

#pragma mark Get Message By ID
-(void)getMessageForMessageID:(int)messageID
{
    self.nextPageURL = nil;
    self.lookingForMessageID = messageID;
    
    [self getMessagePage];
}

-(void)getMessagePage
{
    NSString *urlString = nil;
    if(self.nextPageURL == nil)
    {
        urlString = [NSString stringWithFormat:@"%@:%d/%@", THEME_BASE_URL, THEME_API_PORT, THEME_MESSAGES_RELATIVE_URL];
    }
    else
    {
        urlString = self.nextPageURL;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self finishedGettingMessagePage:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self failedGettingMessagePage:error];
    }];
}

-(void)failedGettingMessagePage:(NSError *)error
{
    self.nextPageURL = nil;
    self.lookingForMessageID = -1;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATOIN_FINISHED_GETTING_MESSAGE_BY_ID object:@FALSE];
}

-(void)finishedGettingMessagePage:(NSDictionary *)response
{
    BOOL foundCorrectPage = FALSE;
    for(NSDictionary *tempMessageData in [response objectForKey:@"comments"])
    {
        Message *newMessage = [self createMessageFromData:tempMessageData];
        if(newMessage.messageID.integerValue == self.lookingForMessageID)
        {
            foundCorrectPage = TRUE;
        }
        
        NSDictionary *tempPageData = [response objectForKey:@"page"];
        self.nextPageURL = [tempPageData objectForKey:@"next"];
    }
    
    [theCoreDataController saveContext];
    
    if(foundCorrectPage)
    {
        self.nextPageURL = nil;
        self.lookingForMessageID = -1;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATOIN_FINISHED_GETTING_MESSAGE_BY_ID object:@TRUE];
    }
    else
    {
        [self getMessagePage];
    }
}

#pragma mark - END OF NEW METHODS


#pragma mark - Home Messages
-(void)getHomeMessage
{
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"http://greenup.xenonapps.com/welcome/"];
    
    NSLog(@"Network - Home: Getting Home Message Data");
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];
    
    //Fire Off Request
    getHomeMessageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - Map Request Methods

-(void)getMapPinsWithDictionary:(NSDictionary *)buffer
{
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?latDegrees=%f&lonDegrees=%f&latOffset=%f&lonOffset=%f", THEME_BASE_URL, THEME_API_PORT, THEME_PINS_RELATIVE_URL, ((NSNumber *)[buffer objectForKey:@"lat"]).floatValue, ((NSNumber *)[buffer objectForKey:@"lon"]).floatValue, ((NSNumber *)[buffer objectForKey:@"deltaLat"]).floatValue, ((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue];
    
    NSLog(@"Network - Map: Getting Pins With Data,");
    NSLog(@"--- Data - Map: Current Lat = %f", ((NSNumber *)[buffer objectForKey:@"lat"]).floatValue);
    NSLog(@"--- Data - Map: Current Lon = %f", ((NSNumber *)[buffer objectForKey:@"lon"]).floatValue);
    NSLog(@"--- Data - Map: Current Lat Delta = %f", ((NSNumber *)[buffer objectForKey:@"deltaLat"]).floatValue);
    NSLog(@"--- Data - Map: Current Lon Delta = %f", ((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue);
    NSLog(@"Networking - Map: Final URL String: %@", urlString);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];
    
    //Fire Off Request
    getMapPinsConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)getMapPinsForPinShow
{
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?id=%@", THEME_BASE_URL, THEME_API_PORT, THEME_PINS_RELATIVE_URL, [[ContainerViewController sharedContainer] theMapViewController].pinIDToShow.stringValue];
    
    NSLog(@"Network - Map: Getting Map Pin for Pin Show");
    NSLog(@"--- Data - Map: Pin Id: %@", [[ContainerViewController sharedContainer] theMapViewController].pinIDToShow.stringValue);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];

    //Fire Off Request
    getMapPinsForShowConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)postMarkerWithPin:(Marker *)pin andMessage:(NSString *)message andType:(NSString *)type
{
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?id=%@", THEME_BASE_URL, THEME_API_PORT, THEME_PINS_RELATIVE_URL, [[ContainerViewController sharedContainer] theMapViewController].pinIDToShow.stringValue];
    
    //Perform Post Code To Update With Server
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    [objects addFloat:pin.latDegrees.floatValue];
    [objects addFloat:pin.lonDegrees.floatValue];
    [objects addObject:type];
    [objects addObject:message];
    [objects addObject:@"false"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:[NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"type", @"message", @"addressed", nil]];
    
    NSLog(@"Network - Map: Pushing New Marker With Data,");
    NSLog(@"--- Data - Map: Lat = %f", pin.latDegrees.floatValue);
    NSLog(@"--- Data - Map: Lon = %f", pin.lonDegrees.floatValue);
    NSLog(@"--- Data - Map: Type = %@", type);
    NSLog(@"--- Data - Map: Message = %@", message);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"POST"];

    //Create Data From Request Dictionary
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    [request setHTTPBody:requestData];
    
    request.timeoutInterval = 10;
    
    //Fire Off Request
    postMarkerConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)pushHeatMapPoints
{
    NSLog(@"Message - Map: Pushing Heatmap Data To Server");
    NSLog(@"--- Data - Map: QUEUE LIMIT = %d", THEME_UPLOAD_QUEUE_LENGTH);
    NSLog(@"--- Data - Map: Gathered Queue = %d", [theCoreDataController fetchAllObjectsWithEntityName:CORE_DATA_HEATMAPPOINT andSortDescriptors:nil].count);
    NSLog(@"--- Data - Map: Push Overdue = %d", [[ContainerViewController sharedContainer] theMapViewController].pushOverdue);
    
    if([theCoreDataController fetchObjectsWithEntityName:CORE_DATA_HEATMAPPOINT predicate:[NSPredicate predicateWithFormat:@"needsPush == TRUE"] sortDescriptors:nil andBatchNumber:0].count >= THEME_UPLOAD_QUEUE_LENGTH || [[ContainerViewController sharedContainer] theMapViewController].pushOverdue)
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
            for(HeatmapPoint *tempPoint in [theCoreDataController fetchObjectsWithEntityName:CORE_DATA_HEATMAPPOINT predicate:[NSPredicate predicateWithFormat:@"needsPush == TRUE"] sortDescriptors:nil andBatchNumber:0])
            {
                //Create Parameters For Push
                NSArray *keys = [NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"secondsWorked", nil];
                NSMutableArray *objects = [[NSMutableArray alloc] init];
                [objects addFloat:tempPoint.latDegrees.floatValue];
                [objects addFloat:tempPoint.lonDegrees.floatValue];
                [objects addFloat:tempPoint.secondsWorked.floatValue];
                
                tempPoint.needsPush = @FALSE;
                
                //Create Dictionary Of Parameters
                NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                [dataArray addObject:parameters];
            }
            
            NSLog(@"--- Data - Map: %@", dataArray);
            
            //Build Request URL
            NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", THEME_BASE_URL, THEME_API_PORT, THEME_HEAT_MAP_RELATIVE_URL];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:10];
            
            //Configure Request
            [request setHTTPMethod: @"PUT"];
            
            //Create Data From Request Dictionary
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:nil];
            [request setHTTPBody:requestData];
            
            request.timeoutInterval = 10;
            
            //Fire Off Request
            pushHeatMapConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
    }
}

-(void)getHeatDataPointsWithDictionary:(NSDictionary *)buffer
{
    [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingHeatMap = FALSE;
     
    //Generation Properties
    NSNumber *precision = nil;
    if(((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue > 2.0)
    {
        precision = @1;
    }
    else if(((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue > 0.5 && ((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue < 2.0)
    {
        precision = @2;
    }
    else if(((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue > 0.2 && ((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue < 0.5)
    {
        precision = @3;
    }
    else if(((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue > 0.05 && ((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue < 0.2)
    {
        precision = @4;
    }
    else if(((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue < 0.05)
    {
        precision = @5;
    }

    NSLog(@"Network - Map: Getting Heat Map Data With Data,");
    NSLog(@"--- Data - Map: Current Precision = %f", precision.floatValue);
    NSLog(@"--- Data - Map: Current Lat = %f", ((NSNumber *)[buffer objectForKey:@"lat"]).floatValue);
    NSLog(@"--- Data - Map: Current Lon = %f", ((NSNumber *)[buffer objectForKey:@"lon"]).floatValue);
    NSLog(@"--- Data - Map: Current Lat Delta = %f", ((NSNumber *)[buffer objectForKey:@"deltaLat"]).floatValue);
    NSLog(@"--- Data - Map: Current Lon Delta = %f", ((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue);

    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?latDegrees=%f&lonDegrees=%f&latOffset=%f&lonOffset=%f&precision=%ld", THEME_BASE_URL, THEME_API_PORT, THEME_HEAT_MAP_RELATIVE_URL, ((NSNumber *)[buffer objectForKey:@"lat"]).floatValue, ((NSNumber *)[buffer objectForKey:@"lon"]).floatValue, ((NSNumber *)[buffer objectForKey:@"deltaLat"]).floatValue, ((NSNumber *)[buffer objectForKey:@"deltaLon"]).floatValue, (long)precision.integerValue];
    
    //NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", BASE_HOST, API_PORT, HEAT_MAP_RELATIVE_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];

    //Fire Off Request
    getHeatMapConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - Message Request Methods

-(void)getMessageForFirstPageOfShowMessage
{
    NSLog(@"Network - Message: Getting First Page Of Show Message");
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", THEME_BASE_URL, THEME_API_PORT, THEME_MESSAGES_RELATIVE_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];

    //Fire Off Request
    getMessagesForFirstPageOfShowConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void)getMessages
{
    NSLog(@"Network - Message: Getting Messages");
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", THEME_BASE_URL, THEME_API_PORT, THEME_MESSAGES_RELATIVE_URL];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id response)
    {
        NSLog(@"Network - Message: Recieved Status Code: %ld", (long)[operation.response statusCode]);
        
        if([operation.response statusCode] == 200)
        {
            //Remove Old Messages Incase Removed
            [[[ContainerViewController sharedContainer] theMessageViewController].messages removeAllObjects];
            
            NSLog(@"Network - Message: Recieved %lu New Messages", (unsigned long)[[response objectForKey:@"comments"] count]);
            NSLog(@"--- Data - Message: Messages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"comments"]);
            
            NSArray *comments = [response objectForKey:@"comments"];
            //NSMutableArray *newDownloadedMessages = [[NSMutableArray alloc] init];
            for(NSDictionary *comment in comments)
            {
                Message *newMessage = [theCoreDataController insertNewEntityWithName:CORE_DATA_MESSAGE];
                newMessage.message = [comment objectForKey:@"message"];
                newMessage.messageID = [comment objectForKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"y-M-d H:m:s"];
                newMessage.timeStamp = [dateFormatter dateFromString:[comment objectForKey:@"timestamp"]];
                
                newMessage.messageType = [comment objectForKey:@"type"];
      
#warning !!!!!!!!!!!!!!!!!!!!!!!!!!!
                /*
                id pinID = [comment objectForKey:@"pin"];
                if([pinID isKindOfClass:[NSNumber class]])
                {
                    newMessage.pinID = [comment objectForKey:@"pin"];
                }
                else
                {
                    newMessage.pinID = nil;
                }*/
                
                newMessage.addressed = [comment objectForKey:@"addressed"];
                
                [[[ContainerViewController sharedContainer] theMessageViewController].messages addObject:newMessage];
                //[newDownloadedMessages addObject:newMessage];
            }
            
            [theCoreDataController saveContext];
            
            NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"messageTimeStamp" ascending:FALSE];
            [[[ContainerViewController sharedContainer] theMessageViewController].messages sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
            //[self.messages sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:TRUE]]];
            
            NSLog(@"--- Data - Message: Pages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"page"]);
            
            
            NSDictionary *pages = [response objectForKey:@"page"];
            if(![[pages objectForKey:@"next"] isEqualToString:@"null"])
            {
                NSString *fullURL = [pages objectForKey:@"next"];
                NSArray *components = [fullURL componentsSeparatedByString:@"/api/"];
                [[ContainerViewController sharedContainer] theMessageViewController].nextPageURL = [NSString stringWithFormat:@"/api/%@", [components objectAtIndex:1]];
            }
            else
            {
                [[ContainerViewController sharedContainer] theMessageViewController].nextPageURL = nil;
            }
            
            [[[ContainerViewController sharedContainer] theMessageViewController].theTableView reloadData];
        }
        else
        {
            [self printResponseFromFailedRequest:response andStatusCode:getMessagesStatusCode];
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
        [self showNoNetworkAlert];
        [self printResponseFromFailedRequest:error andStatusCode:[operation.response statusCode]];
    }];
}

-(void)getMessageForAppendingPageForScrollingWithPageURL:(NSString *)pageURL
{
    NSLog(@"Network - Message: Getting Next Page Of Messages For Scrolling With URL %@", pageURL);
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", THEME_BASE_URL, THEME_API_PORT, pageURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    //Configure Request
    [request setHTTPMethod: @"GET"];

    //Fire Off Request
    getMessagesForAppendingForScrollingConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void)getMessageByAppendingPageForShowMessageWithPageURL:(NSString *)pageURL
{
    NSLog(@"Network - Message: Getting Next Page Of Messages For Show Message With URL %@", pageURL);
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", THEME_BASE_URL, THEME_API_PORT, pageURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];

    //Fire Off Request
    getMessagesForAppendingForShowConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void)postMessageWithMessageType:(NSString *)type andMessage:(NSString *)message
{
    NSLog(@"Network - Message: Post New Message");

    if([message isEqualToString:@""])
    {
        NSLog(@"Message - Message: Message is Blank!");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank Message" message:@"Cannot post blank message" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //Build Request URL
        NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", THEME_BASE_URL, THEME_API_PORT, THEME_COMMENTS_RELATIVE_URL];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                           timeoutInterval:10];
        
        //Configure Request
        [request setHTTPMethod: @"POST"];
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:type, message, nil] forKeys:[NSArray arrayWithObjects:@"type", @"message", nil]];
        
        NSLog(@"Message - Message: Push New Message, Push Data,");
        NSLog(@"--- Data - Message: %@", parameters);
        
        //Create Data From Request Dictionary
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
  
        [request setHTTPBody:requestData];
        
        request.timeoutInterval = 10;

        [request addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        

        //Fire Off Request
        postMessageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

-(void)markMessageAsAddressed:(Message *)message
{
    NSLog(@"Network - Message: Updaing Toggled Message with Message ID: %@", message.markerID.stringValue);
    
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?id=%@",THEME_BASE_URL, THEME_API_PORT, THEME_PINS_RELATIVE_URL, message.markerID.stringValue];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    NSString *value = nil;
    if(message.addressed)
    {
        value = @"true";
    }
    else
    {
        value = @"false";
    }
    
    //DATA
    NSLog(@"--- Data - Marker ID: %@ and Value: %d", message.markerID.stringValue, message.addressed.boolValue);
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:value, nil] forKeys:[NSArray arrayWithObjects:@"addressed", nil]];
    
    //Create Data From Request Dictionary
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
    
    [request setHTTPBody:requestData];
    
    //Configure Request
    [request setHTTPMethod: @"PUT"];
    
    request.timeoutInterval = 10;
    
    //Fire Off Request
    addressMessageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - Utility Methods

#pragma mark Dictionary --> Object
-(Message *)createMessageFromData:(NSDictionary *)data
{
    Message *newMessage = [theCoreDataController insertNewEntityWithName:CORE_DATA_MESSAGE];
    newMessage.messageID = [data objectForKey:@"id"];
    newMessage.messageType = [data objectForKey:@"type"];
    newMessage.markerID = [data objectForKey:@"pin"];
    newMessage.addressed = [data objectForKey:@"addressed"];
    newMessage.message = [data objectForKey:@"message"];
    newMessage.timeStamp = [self getDateFromNetworkTimeStamp:[data objectForKey:@"timeStamp"]];
    newMessage.needsPush = @FALSE;
    
    return newMessage;
}

#pragma mark Other
-(NSDate *)getDateFromNetworkTimeStamp:(NSString *)timeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:timeStamp];
    
    return date;
}

-(void)printResponseFromFailedRequest:(id)error andStatusCode:(NSInteger)statusCode
{
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: *************** WANRING ***************");
    NSLog(@"Network - Map: *********** Request Failed ************");
    NSLog(@"Network - Map: ****** Header Status Code: %ld *********", (long)statusCode);
    NSLog(@"Network - Map: %@", error);
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: ***************************************");
    
}

-(void)showNoNetworkAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network" message:@"Please try again when you have service" delegate:Nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
}

@end
