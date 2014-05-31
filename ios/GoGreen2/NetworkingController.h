//
//  NetworkingController.h
//  HockeyApp
//
//  Created by Anders Melen on 11/5/13.
//  Copyright (c) 2013 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


@class MKMapView, HeatMapPin, HeatMapPoint, NetworkMessage, CLLocation;

@interface NetworkingController : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

//Home Messages
-(void)getHomeMessage;

//Map
-(void)getMapPinsWithDictionary:(NSDictionary *)buffer;
-(void)getMapPinsForPinShow;
-(void)postMarkerWithPin:(HeatMapPin *)pin andMessage:(NSString *)message andType:(NSString *)type;
-(void)pushHeatMapPoints;
-(void)getHeatDataPointsWithDictionary:(NSDictionary *)buffer;

//Messages
-(void)getMessageForFirstPageOfShowMessage;
-(void)getMessages;
-(void)getMessageForAppendingPageForScrollingWithPageURL:(NSString *)pageURL;
-(void)getMessageByAppendingPageForShowMessageWithPageURL:(NSString *)pageURL;
-(void)postMessageWithMessageType:(NSString *)type andMessage:(NSString *)message;
-(void)markMessageAsAddressed:(NetworkMessage *)message;

+ (NetworkingController *)shared;

@end
