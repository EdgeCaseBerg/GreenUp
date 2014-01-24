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

#define API_PORT 31338

//#define BASE_HOST @"http://199.195.248.180"
#define BASE_HOST @"http://dev.xenonapps.com"
#define HEAT_MAP_RELATIVE_URL @"/api/heatmap"
#define COMMENTS_RELATIVE_URL @"/api/comments"
#define PINS_RELATIVE_URL @"/api/pins"
#define MESSAGES_RELATIVE_URL @"/api/comments"

@class MKMapView, HeatMapPin, HeatMapPoint, CLLocation;

@interface NetworkingController : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

//Map
-(void)getMapPinsWithMap:(MKMapView *)mapView;
-(void)getMapPinsForPinShowWithMap:(MKMapView *)mapView;
-(void)postMarkerWithPin:(HeatMapPin *)pin andMessage:(NSString *)message andType:(NSString *)type;
-(void)pushHeatMapPoints;
-(void)getHeatDataPointsWithSpan:(MKCoordinateSpan)span andLocation:(MKCoordinateRegion)location;

//Messages
-(void)getMessageForFirstPageOfShowMessage;
-(void)getMessages;
-(void)getMessageForAppendingPageForScrollingWithPageURL:(NSString *)pageURL;
-(void)getMessageByAppendingPageForShowMessageWithPageURL:(NSString *)pageURL;
-(void)postMessageWithMessageType:(NSString *)type andMessage:(NSString *)message;

+ (NetworkingController *)shared;

@end
