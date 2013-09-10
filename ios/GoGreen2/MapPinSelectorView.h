//
//  MapPinSelectorView.h
//  GoGreen
//
//  Created by Jordan Rouille on 9/5/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^VoidBlock)(void);

@interface MapPinSelectorView : UIView

@property int rotationCount;
@property (nonatomic, strong) UIImageView *pinWheelImage;

- (id)initWithMapPoint:(CGPoint)sentPoint andDuration:(int)spinDuration;

@end
