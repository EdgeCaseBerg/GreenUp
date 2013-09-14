//
//  HeatMapPin.h
//  GoGreen
//
//  Created by Jordan Rouille on 9/5/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HeatMapPin : NSObject <MKAnnotation>

@property CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *message;
@property int pinID;
@property (nonatomic, strong) NSString *type;
@property BOOL isValid;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andValiditity:(BOOL)isValid andTitle:(NSString *)title andType:(NSString *)type;

@end
