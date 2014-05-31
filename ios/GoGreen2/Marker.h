//
//  Marker.h
//  Pods
//
//  Created by Jordan Rouille on 5/31/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message;

@interface Marker : NSManagedObject

@property (nonatomic, retain) NSNumber * markerID;
@property (nonatomic, retain) NSNumber * latDegrees;
@property (nonatomic, retain) NSNumber * lonDegrees;
@property (nonatomic, retain) NSString * markerType;
@property (nonatomic, retain) NSNumber * addressed;
@property (nonatomic, retain) Message *message;

@end
