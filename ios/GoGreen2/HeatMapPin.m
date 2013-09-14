//
//  HeatMapPin.m
//  GoGreen
//
//  Created by Jordan Rouille on 9/5/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "HeatMapPin.h"

@implementation HeatMapPin

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate andValiditity:(BOOL)isValid andTitle:(NSString *)title andType:(NSString *)type
{
    if(self = [super init])
    {
        self.pinID = -1;
        self.message = nil;
        self.coordinate = coordinate;
        self.type = type;
        self.isValid = isValid;
    }
    return self;
}

@end
