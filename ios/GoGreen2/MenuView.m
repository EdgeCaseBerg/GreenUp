//
//  MenuView.m
//  GoGreen
//
//  Created by Aidan Melen on 7/18/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MenuView.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame andView:(NSString *)view
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSAssert(![view isEqualToString:MENU_HOME_VIEW] || ![view isEqualToString:MENU_MAP_VIEW] || ![view isEqualToString:MENU_MESSAGE_VIEW], @"Invalid View Passed To Menu");
        
        if([view isEqualToString:MENU_HOME_VIEW])
        {
            [self fadeView];
            [self performSelector:@selector(buildViewForHome:) withObject:nil afterDelay:.3];
        }
        else if([view isEqualToString:MENU_MAP_VIEW])
        {
            [self fadeView];
            [self buildViewForMap];
        }
        else if([view isEqualToString:MENU_MESSAGE_VIEW])
        {
            [self buildViewForMessages];
        }
        
    }
    return self;
}

-(void)fadeView
{
    for(UIView *subView in self.subviews)
    {
        VoidBlock animate = ^
        {
            [subView setAlpha:0];
        };
        
        //Perform Animations
        [UIView animateWithDuration:.3 animations:animate];
    }
    
    [self performSelector:@selector(clearView:) withObject:nil afterDelay:.3];
}

-(IBAction)clearView:(id)sender
{
    for(UIView *subView in self.subviews)
    {
        [subView removeFromSuperview];
    }
}

-(IBAction)buildViewForHome:(id)sender
{
    [self fadeView];
    
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

-(IBAction)buildViewForMap:(id)sender
{
    [self fadeView];
    
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

-(IBAction)buildViewForMessages:(id)sender
{
    /*
    [self fadeView];
    
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
    [self addSubview:pin3];*/
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
