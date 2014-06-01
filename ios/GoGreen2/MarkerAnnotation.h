//
//  MarkerAnnotation.h
//  GreenUpVt
//
//  Created by Jordan Rouille on 6/1/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CoreDataHeaders.h"
#import "CoreDataHeaders.h"

@interface MarkerAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) Marker *marker;
@property (nonatomic) CLLocationCoordinate2D coordinate;

-(id)initWithMarker:(Marker *)marker;

@end
