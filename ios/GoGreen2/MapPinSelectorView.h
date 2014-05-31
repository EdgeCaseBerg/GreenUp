//
//  MapPinSelectorView.h
//  GoGreen
//
//  Created by Jordan Rouille on 9/5/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapPinSelectorView : UIView

@property int rotationCount;
@property (nonatomic, strong) UIImageView *pinWheelRed;
@property (nonatomic, strong) UIImageView *pinWheelBlue;
@property (nonatomic, strong) UIImageView *pinWheelGreen;
@property (nonatomic, strong) UIImageView *pinWheelOrange;


- (id)initWithMapPoint:(CGPoint)sentPoint andDuration:(float)spinDuration;

@end
