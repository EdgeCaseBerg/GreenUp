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

#import <AFNetworking/AFNetworking.h>

#define UPLOAD_QUEUE_LENGTH 5

//Map Requests
NSMutableData *otherData = nil;

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
NSURLConnection *getMessagesForFirstPageOfShowConnection = nil;
NSMutableData *getMessagesForFirstPageOfShowData = nil;
int getMessagesForFirstPageOfShowStatusCode = -1;

NSURLConnection *getMessagesConnection = nil;
NSMutableData *getMessagesData = nil;
int getMessagesStatusCode = -1;

NSURLConnection *getMessagesForAppendingForScrollingConnection = nil;
NSMutableData *getMessagesForAppendingForScrollingData = nil;
int getMessagesForAppendingForScrollingStatusCode = -1;

NSURLConnection *getMessagesForAppendingForShowConnection = nil;
NSMutableData *getMessagesForAppendingForShowData = nil;
int getMessagesForAppendingForShowStatusCode = -1;

NSURLConnection *postMessageConnection = nil;
NSMutableData *postMessageData = nil;
int postMessageStatusCode = -1;

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
        
        NSLog(@"********************");
        NSLog(@"%@", response);
        NSLog(@"********************");
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
    else if([connection isEqual:getMessagesForFirstPageOfShowConnection])
    {
        [getMessagesForFirstPageOfShowData appendData:data];
    }
    else if([connection isEqual:getMessagesConnection])
    {
        [getMessagesData appendData:data];
        
        NSLog(@"##################################################################");
        NSLog(@"##################################################################");
        NSLog(@"##################################################################");
        NSLog(@"##################################################################");
        NSLog(@"##################################################################");
        
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
        NSLog(@"##################################################################");
        NSLog(@"##################################################################");
        NSLog(@"##################################################################");
        NSLog(@"##################################################################");
        NSLog(@"##################################################################");
        
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
    else
    {
        [otherData appendData:data];
        NSLog(@"STOP..");
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
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
            [self printResponseFromFailedRequest:response andStatusCode:getMapPinsForShowStatusCode];
            
            [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingPinsForShowPin" object:[NSNumber numberWithInt:statusCode.integerValue]];
        }
        
        getMapPinsForShowConnection = nil;
        getMapPinsForShowData = nil;
        getMapPinsForShowStatusCode = -1;
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
        postMarkerData = nil;
        postMarkerStatusCode = -1;
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
            [self printResponseFromFailedRequest:response andStatusCode:pushHeatMapStatusCode];
            
            [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = TRUE;
        }
        else
        {
            [[ContainerViewController sharedContainer] theMapViewController].pushOverdue = FALSE;
            [[[ContainerViewController sharedContainer] theMapViewController].gatheredMapPointsQueue removeAllObjects];
        }
        
        pushHeatMapConnection = nil;
        pushHeatMapData = nil;
        pushHeatMapStatusCode = -1;
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
        NSDictionary *response = nil;
        if(getMessagesForFirstPageOfShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForFirstPageOfShowData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Message: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            //Remove Old Messages Incase Removed
            [[[ContainerViewController sharedContainer] theMessageViewController].messages removeAllObjects];
            
            NSLog(@"Network - Message: Recieved %d New Messages", [[response objectForKey:@"comments"] count]);
            NSLog(@"--- Data - Message: Messages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"comments"]);
            
            NSArray *comments = [response objectForKey:@"comments"];
            //NSMutableArray *newDownloadedMessages = [[NSMutableArray alloc] init];
            for(NSDictionary *comment in comments)
            {
                NetworkMessage *newMessage = [[NetworkMessage alloc] init];
                newMessage.messageContent = [comment objectForKey:@"message"];
                newMessage.messageID = [comment objectForKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"E M d H:m:s y"];
                newMessage.messageTimeStamp = [dateFormatter dateFromString:[comment objectForKey:@"timestamp"]];
                
                newMessage.messageType = [comment objectForKey:@"type"];
                id pinID = [comment objectForKey:@"pin"];
                if([pinID isKindOfClass:[NSNumber class]])
                {
                    newMessage.pinID = [comment objectForKey:@"pin"];
                }
                else
                {
                    newMessage.pinID = nil;
                }
                
                newMessage.addressed = [[comment objectForKey:@"addressed"] boolValue];
                
                [[[ContainerViewController sharedContainer] theMessageViewController].messages addObject:newMessage];
                //[newDownloadedMessages addObject:newMessage];
            }
            
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
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingMessageForFirstPageOfShowMessage" object:[NSNumber numberWithInt:statusCode.integerValue]];
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
        NSDictionary *response = nil;
        if(getMessagesForAppendingForScrollingData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForAppendingForScrollingData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        NSLog(@"Network - Message: Recieved Status Code: %@", statusCode);
        
        NSMutableArray *newMessages = [[NSMutableArray alloc] init];;
        
        if([statusCode integerValue] == 200)
        {
            NSLog(@"Network - Message: Recieved %d New Messages", [[response objectForKey:@"comments"] count]);
            NSLog(@"--- Data - Message: Messages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"comments"]);
            
            NSArray *comments = [response objectForKey:@"comments"];
            //NSMutableArray *newDownloadedMessages = [[NSMutableArray alloc] init];
            for(NSDictionary *comment in comments)
            {
                NetworkMessage *newMessage = [[NetworkMessage alloc] init];
                newMessage.messageContent = [comment objectForKey:@"message"];
                newMessage.messageID = [comment objectForKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"E M d H:m:s y"];
                newMessage.messageTimeStamp = [dateFormatter dateFromString:[comment objectForKey:@"timestamp"]];
                
                newMessage.messageType = [comment objectForKey:@"type"];
                id pinID = [comment objectForKey:@"pin"];
                if([pinID isKindOfClass:[NSNumber class]])
                {
                    newMessage.pinID = [comment objectForKey:@"pin"];
                }
                else
                {
                    newMessage.pinID = nil;
                }
                
                newMessage.addressed = [[comment objectForKey:@"addressed"] boolValue];
                
                [newMessages addObject:newMessage];
            }
            
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
        NSDictionary *response = nil;
        if(getMessagesForAppendingForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForAppendingForShowData options:0 error:nil];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        
        NSMutableArray *newMessages = [[NSMutableArray alloc] init];;
        
        NSLog(@"Network - Message: Recieved Status Code: %@", statusCode);
        
        if([statusCode integerValue] == 200)
        {
            
            NSLog(@"Network - Message: Recieved %d New Messages", [[response objectForKey:@"comments"] count]);
            NSLog(@"--- Data - Message: Messages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"comments"]);
            
            NSArray *comments = [response objectForKey:@"comments"];
            //NSMutableArray *newDownloadedMessages = [[NSMutableArray alloc] init];
            for(NSDictionary *comment in comments)
            {
                NetworkMessage *newMessage = [[NetworkMessage alloc] init];
                newMessage.messageContent = [comment objectForKey:@"message"];
                newMessage.messageID = [comment objectForKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"E M d H:m:s y"];
                newMessage.messageTimeStamp = [dateFormatter dateFromString:[comment objectForKey:@"timestamp"]];
                
                newMessage.messageType = [comment objectForKey:@"type"];
                id pinID = [comment objectForKey:@"pin"];
                if([pinID isKindOfClass:[NSNumber class]])
                {
                    newMessage.pinID = [comment objectForKey:@"pin"];
                }
                else
                {
                    newMessage.pinID = nil;
                }
                
                newMessage.addressed = [[comment objectForKey:@"addressed"] boolValue];
                
                [newMessages addObject:newMessage];
            }
            
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
    else
    {
        NSLog(@"SSTOP");
        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:otherData options:0 error:nil]);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if([connection isEqual:getMapPinsConnection])
    {
        NSDictionary *response = nil;
        if(getMapPinsData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsData options:0 error:nil];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMapPinsStatusCode];
        
        [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:@"-1"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Pins" message:@"You dont appear to have a network connection, please connect and retry loading the map." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        //[alert show];
    }
    else if([connection isEqual:getMapPinsForShowConnection])
    {
        NSDictionary *response = nil;
        if(getMapPinsForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMapPinsForShowData options:0 error:nil];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMapPinsForShowStatusCode];
        
        [[ContainerViewController sharedContainer] theMapViewController].finishedDownloadingMapPins = TRUE;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedDownloadingMapPins" object:[NSNumber numberWithInt:-1]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Pins" message:@"You dont appear to have a network connection, please connect and retry loading the map." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        //[alert show];
    }
    else if([connection isEqual:postMarkerConnection])
    {
        NSDictionary *response = nil;
        if(postMarkerData != nil)
            response = [NSJSONSerialization JSONObjectWithData:postMarkerData options:0 error:nil];
        
        [self printResponseFromFailedRequest:response andStatusCode:postMarkerStatusCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Post Pin" message:@"You dont appear to have a network connection, please connect and retry posting the pin." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedGettingMessageForFirstPageOfShowMessage" object:[NSNumber numberWithInt:-1]];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMessagesForFirstPageOfShowStatusCode];
    }

    else if([connection isEqual:getMessagesForAppendingForScrollingConnection])
    {
        NSDictionary *response = nil;
        if(getMessagesForAppendingForScrollingData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForAppendingForScrollingData options:0 error:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Messages" message:@"You dont appear to have a network connection, please connect and retry looking at the message." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMessagesForAppendingForScrollingStatusCode];
    }
    else if([connection isEqual:getMessagesForAppendingForShowConnection])
    {
        NSDictionary *response = nil;
        if(getMessagesForAppendingForShowData != nil)
            response = [NSJSONSerialization JSONObjectWithData:getMessagesForAppendingForShowData options:0 error:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Messages" message:@"You dont appear to have a network connection, please connect and retry looking at the message." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        
        [self printResponseFromFailedRequest:response andStatusCode:getMessagesForAppendingForShowStatusCode];
    }
    else if([connection isEqual:postMessageConnection])
    {
        NSDictionary *response = nil;
        if(postMessageData != nil)
            response = [NSJSONSerialization JSONObjectWithData:postMessageData options:0 error:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Post Message" message:@"You dont appear to have a network connection, please connect and retry posting your message." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        
        [self printResponseFromFailedRequest:response andStatusCode:postMessageStatusCode];
    }
    else
    {
        NSLog(@"SSTOP");
    }
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
    
    //Fire Off Request
    getMapPinsForShowConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)postMarkerWithPin:(HeatMapPin *)pin andMessage:(NSString *)message andType:(NSString *)type
{
    //Build Request URL
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@?id=%@", BASE_HOST, API_PORT, PINS_RELATIVE_URL, [[ContainerViewController sharedContainer] theMapViewController].pinIDToShow.stringValue];
    
    pin.message = message;
    
    //Perform Post Code To Update With Server
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    [objects addFloat:pin.coordinate.latitude];
    [objects addFloat:pin.coordinate.longitude];
    [objects addObject:type];
    [objects addObject:message];
    [objects addObject:@"false"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:objects forKeys:[NSArray arrayWithObjects:@"latDegrees", @"lonDegrees", @"type", @"message", @"addressed", nil]];
    
    NSLog(@"Network - Map: Pushing New Marker With Data,");
    NSLog(@"--- Data - Map: Lat = %f", pin.coordinate.latitude);
    NSLog(@"--- Data - Map: Lon = %f", pin.coordinate.longitude);
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

    //Fire Off Request
    getHeatMapConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

#pragma mark - Message Request Methods

-(void)getMessageForFirstPageOfShowMessage
{
    NSLog(@"Network - Message: Getting First Page Of Show Message");
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", BASE_HOST, API_PORT, MESSAGES_RELATIVE_URL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    //Fire Off Request
    getMessagesForFirstPageOfShowConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void)getMessages
{
    NSLog(@"Network - Message: Getting Messages");
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", BASE_HOST, API_PORT, MESSAGES_RELATIVE_URL];
    

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id response)
    {
        NSLog(@"Network - Message: Recieved Status Code: %d", [operation.response statusCode]);
        
        if([operation.response statusCode] == 200)
        {
            //Remove Old Messages Incase Removed
            [[[ContainerViewController sharedContainer] theMessageViewController].messages removeAllObjects];
            
            NSLog(@"Network - Message: Recieved %d New Messages", [[response objectForKey:@"comments"] count]);
            NSLog(@"--- Data - Message: Messages,");
            NSLog(@"--- Data - Message: %@", [response objectForKey:@"comments"]);
            
            NSArray *comments = [response objectForKey:@"comments"];
            //NSMutableArray *newDownloadedMessages = [[NSMutableArray alloc] init];
            for(NSDictionary *comment in comments)
            {
                NetworkMessage *newMessage = [[NetworkMessage alloc] init];
                newMessage.messageContent = [comment objectForKey:@"message"];
                newMessage.messageID = [comment objectForKey:@"id"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"y-M-d H:m:s"];
                newMessage.messageTimeStamp = [dateFormatter dateFromString:[comment objectForKey:@"timestamp"]];
                
                newMessage.messageType = [comment objectForKey:@"type"];
                id pinID = [comment objectForKey:@"pin"];
                if([pinID isKindOfClass:[NSNumber class]])
                {
                    newMessage.pinID = [comment objectForKey:@"pin"];
                }
                else
                {
                    newMessage.pinID = nil;
                }
                
                newMessage.addressed = [[comment objectForKey:@"addressed"] boolValue];
                
                [[[ContainerViewController sharedContainer] theMessageViewController].messages addObject:newMessage];
                //[newDownloadedMessages addObject:newMessage];
            }
            
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Get Messages" message:@"You dont appear to have a network connection, please connect and retry looking at the message." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        [self printResponseFromFailedRequest:error andStatusCode:[operation.response statusCode]];
    }];
}

-(void)getMessageForAppendingPageForScrollingWithPageURL:(NSString *)pageURL
{
    NSLog(@"Network - Message: Getting Next Page Of Messages For Scrolling With URL %@", pageURL);
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", BASE_HOST, API_PORT, pageURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    //Configure Request
    [request setHTTPMethod: @"GET"];
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    //Fire Off Request
    getMessagesForAppendingForScrollingConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

-(void)getMessageByAppendingPageForShowMessageWithPageURL:(NSString *)pageURL
{
    NSLog(@"Network - Message: Getting Next Page Of Messages For Show Message With URL %@", pageURL);
    
    NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", BASE_HOST, API_PORT, pageURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:10];
    
    //Configure Request
    [request setHTTPMethod: @"GET"];
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
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
        NSString *urlString = [NSString stringWithFormat:@"%@:%d%@", BASE_HOST, API_PORT, COMMENTS_RELATIVE_URL];
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
        
        NSLog(@"SIZE:::::::::::::: %d", requestData.length);
        
        [request setHTTPBody:requestData];
        
        request.timeoutInterval = 10;
        

        [request addValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        

        //Fire Off Request
        postMessageConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        NSDictionary *test = [request allHTTPHeaderFields];
        
        NSLog(@"%@", test);

    }
}

#pragma mark - Utility Methods

-(void)printResponseFromFailedRequest:(id)error andStatusCode:(int)statusCode
{
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: *************** WANRING ***************");
    NSLog(@"Network - Map: *********** Request Failed ************");
    NSLog(@"Network - Map: ****** Header Status Code: %d *********", statusCode);
    NSLog(@"Network - Map: %@", error);
    NSLog(@"Network - Map: ***************************************");
    NSLog(@"Network - Map: ***************************************");
    
}

@end
