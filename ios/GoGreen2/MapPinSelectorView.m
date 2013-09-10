//
//  MapPinSelectorView.m
//  GoGreen
//
//  Created by Jordan Rouille on 9/5/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MapPinSelectorView.h"
#import <QuartzCore/QuartzCore.h>

#define MAX_ROTATION 3

@implementation MapPinSelectorView

- (id)initWithMapPoint:(CGPoint)sentPoint andDuration:(int)spinDuration
{
    CGRect frameFromPoint = CGRectMake(sentPoint.x - 50, sentPoint.y - 53, 100, 106);
    self = [super initWithFrame:frameFromPoint];
    if (self)
    {
        // Initialization code
        
        self.pinWheelImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinWheel.png"]];
        [self.pinWheelImage setFrame:CGRectMake(0, 0, 100, 106)];
        [self.pinWheelImage setAlpha:0];
        [self addSubview:self.pinWheelImage];
        
        [self runSpinAnimationOnView:self.pinWheelImage duration:spinDuration rotations:1 repeat:1];
        
        VoidBlock animationBlock =
        ^{
            [self.pinWheelImage setAlpha:1];
        };
        
        [UIView animateWithDuration:spinDuration animations: animationBlock];
    }
    return self;
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
