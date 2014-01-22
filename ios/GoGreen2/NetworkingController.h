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
