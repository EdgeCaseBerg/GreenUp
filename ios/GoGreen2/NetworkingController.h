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
#import <MBProgressHUD/MBProgressHUD.h>

@class MKMapView, HeatmapPoint, Marker, Message, CLLocation;

@interface NetworkingController : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSString *nextPageURL;
@property int lookingForMessageID;

//Home Messages
-(void)getHomeMessage;

//Map
-(void)getMapPinsWithDictionary:(NSDictionary *)buffer;
-(void)getMapPinsForPinShow;
-(void)postMarkerWithPin:(Marker *)pin andMessage:(NSString *)message andType:(NSString *)type;
-(void)pushHeatMapPoints;
-(void)getHeatDataPointsWithDictionary:(NSDictionary *)buffer;

//Messages
-(void)getMessageForFirstPageOfShowMessage;
-(void)getMessages;
-(void)getMessageForAppendingPageForScrollingWithPageURL:(NSString *)pageURL;
-(void)getMessageByAppendingPageForShowMessageWithPageURL:(NSString *)pageURL;
-(void)postMessageWithMessageType:(NSString *)type andMessage:(NSString *)message;
-(void)markMessageAsAddressed:(Message *)message;

//NEW METOHDS
-(void)getMessageForMessageID:(int)messageID;
-(void)getMessagePage;-(void)failedGettingMessagePage:(NSError *)error;
-(void)finishedGettingMessagePage:(NSDictionary *)response;

+ (NetworkingController *)shared;

@end
