//
//  MenuView.m
//  GoGreen
//
//  Created by Aidan Melen on 7/18/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //Set Background Color
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //Init the Pin Icons
        UIImageView *pin1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapPinExample.png"]];
        UIImageView *pin2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapPinExample.png"]];
        UIImageView *pin3Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapPinExample.png"]];
        UIImageView *topBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topBar.png"]];
        
        //Set Pin Image Frames
        [pin1Image setFrame:CGRectMake(10, 5, 80, 40)];
        [pin2Image setFrame:CGRectMake(10, 50, 80, 40)];
        [pin3Image setFrame:CGRectMake(10, 95, 80, 40)];
        [topBar setFrame:CGRectMake(0, self.frame.size.height - 32, 320, 32)];
        
        //Add pin images to view
        [self addSubview:pin1Image];
        [self addSubview:pin2Image];
        [self addSubview:pin3Image];
        [self addSubview:topBar];


        //Init Pin Labels
        UILabel *pin1 = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, 220, 40)];
        UILabel *pin2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, 220, 40)];
        UILabel *pin3 = [[UILabel alloc] initWithFrame:CGRectMake(90, 95, 220, 40)];
        
        //Set Pins Text
        [pin1 setText:@"Pickup Point"];
        [pin2 setText:@"Comment Point"];
        [pin3 setText:@"Trash Point"];
        
        //Set Text Color
        [pin1 setTextColor:[UIColor blackColor]];
        [pin2 setTextColor:[UIColor blackColor]];
        [pin3 setTextColor:[UIColor blackColor]];
        
        //Set Text Alignment
        [pin1 setTextAlignment:NSTextAlignmentCenter];
        [pin2 setTextAlignment:NSTextAlignmentCenter];
        [pin3 setTextAlignment:NSTextAlignmentCenter];
        
        
        //Set Background Color
        [pin1 setBackgroundColor:[UIColor clearColor]];
        [pin2 setBackgroundColor:[UIColor clearColor]];
        [pin3 setBackgroundColor:[UIColor clearColor]];
        
        //Add the pins to the view
        [self addSubview:pin1];
        [self addSubview:pin2];
        [self addSubview:pin3];
    }
    return self;
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
