//
//  MenuView.m
//  GoGreen
//
//  Created by Aidan Melen on 7/18/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MenuView.h"
#import "ContainerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+methods.h"

@implementation MenuView

- (id)initWithFrame:(CGRect)frame andView:(NSString *)view
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSAssert(![view isEqualToString:MENU_HOME_VIEW] || ![view isEqualToString:MENU_MAP_VIEW] || ![view isEqualToString:MENU_MESSAGE_VIEW], @"Invalid View Passed To Menu");
        
        //Content View, All subviews should be added to this
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height - 32)];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.contentView];
        
        self.topBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topBar.png"]];
        [self.topBarImageView setFrame:CGRectMake(0, self.frame.size.height - 32, 320, 32)];
        [self addSubview:self.topBarImageView];
        
    
        self.toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.toggleButton setFrame:CGRectMake(17, frame.size.height - 25, 30, 21)];
        [self.toggleButton addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
        [self.toggleButton setBackgroundImage:[UIImage imageNamed:@"hamburger_icon.png"] forState:UIControlStateNormal];
        [self addSubview:self.toggleButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomeView:) name:@"updateHomeMenuWithNewPreviousTimes" object:nil];
        
        if([view isEqualToString:MENU_HOME_VIEW])
        {
            [self fadeViewToView:MENU_HOME_VIEW];
        }
        else if([view isEqualToString:MENU_MAP_VIEW])
        {
            [self fadeViewToView:MENU_MAP_VIEW];
        }
        else if([view isEqualToString:MENU_MESSAGE_VIEW])
        {
            [self fadeViewToView:MENU_MESSAGE_VIEW];
        }
    }
    return self;
}

-(IBAction)toggleMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMenu" object:nil];
    if([[[[ContainerViewController sharedContainer] theHomeViewController] view] frame].origin.x == 0 && [[[[ContainerViewController sharedContainer] theHomeViewController] view] frame].size.width != 0)
    {
        [self clearView:MENU_HOME_VIEW];
    }
}

-(void)fadeViewToView:(NSString *)view
{
    for(UIView *subView in self.contentView.subviews)
    {
        VoidBlock animate = ^
        {
            [subView setAlpha:0];
        };
        
        //Perform Animations
        [UIView animateWithDuration:.3 animations:animate];
    }
    
    [self performSelector:@selector(clearView:) withObject:view afterDelay:.3];
}

-(IBAction)clearView:(NSString *)view
{
    for(UIView *subView in self.contentView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    if([view isEqualToString:MENU_HOME_VIEW])
    {
        [self switchToHomeView];
    }
    else if([view isEqualToString:MENU_MAP_VIEW])
    {
        [self switchToMapView];
    }
    else
    {
        [self switchToMessageView];
    }
}

-(IBAction)buildViewForHome:(id)sender
{
    [self fadeViewToView:MENU_HOME_VIEW];
}

-(IBAction)buildViewForMap:(id)sender
{
    [self fadeViewToView:MENU_MAP_VIEW];
}

-(IBAction)buildViewForMessages:(id)sender
{
    [self fadeViewToView:MENU_MESSAGE_VIEW];
}

-(IBAction)updateHomeView:(id)sender
{
    [self fadeViewToView:MENU_HOME_VIEW];
}

-(void)switchToHomeView
{
    //Update Previous Time Intervals
    self.previousTimeIntervals = [[[ContainerViewController sharedContainer] theHomeViewController] previousLoggingTimes];
    
    UIView *scrollViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, 130)];
    [scrollViewContainerView setBackgroundColor:[UIColor greenUpGreenColor]];
    [scrollViewContainerView.layer setCornerRadius:5];
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, scrollViewContainerView.frame.size.width - 10, 20)];
    [keyLabel setText:@"Session \t \t \t Time Cleaning"];
    [keyLabel setBackgroundColor:[UIColor clearColor]];
    [keyLabel setTextColor:[UIColor whiteColor]];
    [keyLabel setTextAlignment:NSTextAlignmentCenter];
    [scrollViewContainerView addSubview:keyLabel];
    
    UIScrollView *previousTimesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 30, scrollViewContainerView.frame.size.width - 20, 90)];
    int height = 0;
    [previousTimesScrollView setBackgroundColor:[UIColor clearColor]];
    
    for(int i = self.previousTimeIntervals.count - 1; i >= 0; i--)
    {
        NSNumber *intervalNumber = [self.previousTimeIntervals objectAtIndex:i];
        NSTimeInterval interval = intervalNumber.doubleValue;
        float hours = floor(interval/60/60);
        float min = floor(interval/60);
        float sec = round(interval - min * 60);
        
        UIColor *fontColor =  nil;
        if(i % 2 == 0)
        {
            UIView *highLightedBackground = [[UIView alloc] initWithFrame:CGRectMake(5, height, previousTimesScrollView.frame.size.width - 10, 35)];
            [highLightedBackground setBackgroundColor:[UIColor greenUpLightGreenColor]];
            [previousTimesScrollView addSubview:highLightedBackground];
            
            fontColor = [UIColor whiteColor];
        }
        else
        {
            fontColor = [UIColor whiteColor];
        }
        UILabel *sessionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, height, 70, 30)];
        [sessionLabel setText:[NSString stringWithFormat:@"%d", i + 1]];
        [sessionLabel setBackgroundColor:[UIColor clearColor]];
        [sessionLabel setTextColor:fontColor];
        [sessionLabel setTextAlignment:NSTextAlignmentCenter];
        [previousTimesScrollView addSubview:sessionLabel];
        
        UILabel *dividerLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, height, 15, 30)];
        [dividerLabel setText:@"-"];
        [dividerLabel setBackgroundColor:[UIColor clearColor]];
        [dividerLabel setTextColor:fontColor];
        [dividerLabel setTextAlignment:NSTextAlignmentCenter];
        //[previousTimesScrollView addSubview:dividerLabel];
        
        NSString *time = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)hours, (int)min, (int)sec];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, height, previousTimesScrollView.frame.size.width - 115, 30)];
        [timeLabel setText:time];
        [timeLabel setTextColor:fontColor];
        [timeLabel setTextAlignment:NSTextAlignmentCenter];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [previousTimesScrollView addSubview:timeLabel];
        
        
        height += timeLabel.frame.size.height + 5;
    }
    
    [previousTimesScrollView setContentSize:CGSizeMake(previousTimesScrollView.frame.size.width, height)];
    [scrollViewContainerView addSubview:previousTimesScrollView];
    
    [self.contentView addSubview:scrollViewContainerView];
    
    //Set Background Color
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)switchToMapView
{
    //Set Background Color
    [self setBackgroundColor:[UIColor clearColor]];
    
    //Init the Pin Icons
    UIImageView *pin1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker.png"]];
    UIImageView *pin2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashMarker.png"]];
    UIImageView *pin3Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hazardMarker.png"]];
    
    UIButton *dropPinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dropPinButton setBackgroundImage:[UIImage imageNamed:@"currentLocationButtonBackground.png"] forState:UIControlStateNormal];
    [dropPinButton setFrame:CGRectMake(40, 72, self.frame.size.width - 80, 30)];
    [dropPinButton setTitle:@"Drop Marker At My Location" forState:UIControlStateNormal];
    [dropPinButton addTarget:self action:@selector(dropMarker:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 109, 95, 20)];
    [centerLabel setText:@"Center Map"];
    
    UISwitch *centerOnLocationSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(102, 107, 40, 20)];
    [centerOnLocationSwitch addTarget:self action:@selector(toggleCenterOnLocation:) forControlEvents:UIControlEventValueChanged];
    [centerOnLocationSwitch setOn:[[[ContainerViewController sharedContainer] theMapViewController] centerOnCurrentLocation] animated:TRUE];
    
    UISegmentedControl *mapTypeControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Map", @"Sat", nil]];
    [mapTypeControl addTarget:self action:@selector(toggleSateliteView:) forControlEvents:UIControlEventValueChanged];
    [mapTypeControl setFrame:CGRectMake(185, 107, 130, 27)];
    if([[[[ContainerViewController sharedContainer] theMapViewController] mapView] mapType] == MKMapTypeStandard)
    {
        [mapTypeControl setSelectedSegmentIndex:0];
    }
    else
    {
        [mapTypeControl setSelectedSegmentIndex:1];
    }
    
    
    //Set Pin Image Frames
    [pin1Image setFrame:CGRectMake(42, 5, 30, 40)];
    [pin2Image setFrame:CGRectMake(144, 5, 40, 40)];
    [pin3Image setFrame:CGRectMake(251, 5, 30, 40)];
    
    
    //Add pin images to view
    [self.contentView addSubview:pin1Image];
    [self.contentView addSubview:pin2Image];
    [self.contentView addSubview:pin3Image];
    [self.contentView addSubview:centerOnLocationSwitch];
    [self.contentView addSubview:mapTypeControl];
    [self.contentView addSubview:centerLabel];
    
    //Init Pin Labels
    UILabel *pin1 = [[UILabel alloc] initWithFrame:CGRectMake(2, 40, 106, 30)];
    UILabel *pin2 = [[UILabel alloc] initWithFrame:CGRectMake(112, 40, 102, 30)];
    UILabel *pin3 = [[UILabel alloc] initWithFrame:CGRectMake(214, 40, 106, 30)];
    
    //Set Pins Text
    [pin1 setText:@"Help Needed"];
    [pin2 setText:@"Pick Up"];
    [pin3 setText:@"Hazard"];
    
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
    [self.contentView addSubview:pin1];
    [self.contentView addSubview:pin2];
    [self.contentView addSubview:pin3];
    [self.contentView addSubview:dropPinButton];
}

-(void)switchToMessageView
{
    //Set Background Color
    [self setBackgroundColor:[UIColor clearColor]];

    UIImageView *exampleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menuMessageTypes.png"]];
    [exampleImage setFrame:CGRectMake(10, 5, self.frame.size.width - 20, 68)];
    [self.contentView addSubview:exampleImage];
    
    UILabel *markerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 147, 25)];
    [markerLabel setText:@"Help Needed"];
    [markerLabel setTextAlignment:NSTextAlignmentCenter];
    [markerLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:markerLabel];
    
    UILabel *hazardLabel = [[UILabel alloc] initWithFrame:CGRectMake(163, 5, 147, 25)];
    [hazardLabel setText:@"Hazard Message"];
    [hazardLabel setTextAlignment:NSTextAlignmentCenter];
    [hazardLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:hazardLabel];
    
    UILabel *pickUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 147, 25)];
    [pickUpLabel setText:@"Pick Up Location"];
    [pickUpLabel setTextAlignment:NSTextAlignmentCenter];
    [pickUpLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:pickUpLabel];
    
    UILabel *generalLabel = [[UILabel alloc] initWithFrame:CGRectMake(163, 40, 147, 25)];
    [generalLabel setText:@"General Comment"];
    [generalLabel setTextAlignment:NSTextAlignmentCenter];
    [generalLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:generalLabel];
    
    UILabel *longPressNote = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, self.frame.size.width - 20, 60)];
    [longPressNote setBackgroundColor:[UIColor clearColor]];
    [longPressNote setTextAlignment:NSTextAlignmentCenter];
    [longPressNote setFont:[longPressNote.font fontWithSize:12]];
    [longPressNote setText:@"You can mark help needed pins as addressed by long pressing the message. Addressed pins will not show up on the map and appear gray in the list. Tapping the pin will bring you to its location on the map."];
    [longPressNote setNumberOfLines:4];
    [self.contentView addSubview:longPressNote];
}

-(IBAction)dropMarker:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dropMarker" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMenu" object:nil];
}

-(IBAction)toggleCenterOnLocation:(UISwitch *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleCenterOnLocation" object:@(sender.isOn)];
}

-(IBAction)toggleSateliteView:(UISegmentedControl *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleSateliteView" object:@(sender.selectedSegmentIndex)];
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
