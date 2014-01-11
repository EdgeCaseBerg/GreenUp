//
//  NetworkingController.h
//  HockeyApp
//
//  Created by Anders Melen on 11/5/13.
//  Copyright (c) 2013 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingController : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSString *currentRequest;
@property NSInteger statusCode;

//Map Pins
-(void)getMapPinsWithParameters:(NSDictionary *)parameters;
-(void)getMapPinForPinShowWithPinID:(int)pinID;

-(void)postNewPinWithParameters:(NSDictionary *)parameters;

//Message Board
-(void)getMessages;
-(void)getMessageForFirstPage;
-(void)getMessageByAppendingPageForScrolling;
-(void)getMessageByAppendingPageForShowMessage;

-(void)postNewMessage;

+ (NetworkingController *)shared;

@end
