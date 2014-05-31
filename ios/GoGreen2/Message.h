//
//  Message.h
//  GreenUpVt
//
//  Created by Jordan Rouille on 5/31/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Marker;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSNumber * messageID;
@property (nonatomic, retain) NSString * messageType;
@property (nonatomic, retain) NSNumber * addressed;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) Marker *marker;

@end
