//
//  HeatmapPoint.h
//  GreenUpVt
//
//  Created by Jordan Rouille on 6/1/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HeatmapPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * latDegrees;
@property (nonatomic, retain) NSNumber * lonDegrees;
@property (nonatomic, retain) NSNumber * secondsWorked;
@property (nonatomic, retain) NSNumber * needsPush;

@end
