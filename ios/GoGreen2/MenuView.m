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
#import "ThemeHeader.h"

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
    
    UIView *scrollViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, 90)];
    [scrollViewContainerView setBackgroundColor:[UIColor greenUpGreenColor]];
    [scrollViewContainerView.layer setCornerRadius:5];
    
    UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, scrollViewContainerView.frame.size.width - 10, 20)];
    [keyLabel setText:@"Session \t \t \t Time Cleaning"];
    [keyLabel setBackgroundColor:[UIColor clearColor]];
    [keyLabel setTextColor:[UIColor whiteColor]];
    [keyLabel setTextAlignment:NSTextAlignmentCenter];
    [scrollViewContainerView addSubview:keyLabel];
    
    UIScrollView *previousTimesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 30, scrollViewContainerView.frame.size.width - 20, 55)];
    int height = 0;
    [previousTimesScrollView setBackgroundColor:[UIColor clearColor]];
    
    for(NSInteger i = self.previousTimeIntervals.count - 1; i >= 0; i--)
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
        [sessionLabel setText:[NSString stringWithFormat:@"%ld", i + 1]];
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
    
    UIButton *aboutUs = [UIButton buttonWithType:UIButtonTypeCustom];
    [aboutUs setImage:[UIImage imageNamed:@"aboutUs.png"] forState:UIControlStateNormal];
    [aboutUs addTarget:self action:@selector(showAboutUs) forControlEvents:UIControlEventTouchUpInside];
    [aboutUs setFrame:CGRectMake(5, 100, (self.contentView.frame.size.width / 2) - 10, 35)];
    [self.contentView addSubview:aboutUs];
    
    UIButton *showTutorial = [UIButton buttonWithType:UIButtonTypeCustom];
    [showTutorial setImage:[UIImage imageNamed:@"showTutorial.png"]  forState:UIControlStateNormal];
    [showTutorial addTarget:self action:@selector(showTutorial) forControlEvents:UIControlEventTouchUpInside];
    [showTutorial setFrame:CGRectMake((self.contentView.frame.size.width / 2) + 5, 100, (self.contentView.frame.size.width / 2) - 10, 35)];
    [self.contentView addSubview:showTutorial];
    
    //Set Background Color
    [self setBackgroundColor:[UIColor clearColor]];
}

-(void)switchToMapView
{
    //Set Background Color
    [self setBackgroundColor:[UIColor clearColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.contentView.frame.size.width - 10, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:@"Pin Examples"];
    
    [self.contentView addSubview:titleLabel];
    
    //Init the Pin Icons
    UIImageView *pin1Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker.png"]];
    UIImageView *pin2Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashMarker.png"]];
    UIImageView *pin3Image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hazardMarker.png"]];
    
    //Set Pin Image Frames
    [pin1Image setFrame:CGRectMake(42, 30, 30, 40)];
    [pin2Image setFrame:CGRectMake(144, 30, 40, 40)];
    [pin3Image setFrame:CGRectMake(251, 30, 30, 40)];
    
    
    //Add pin images to view
    [self.contentView addSubview:pin1Image];
    [self.contentView addSubview:pin2Image];
    [self.contentView addSubview:pin3Image];

    //Init Pin Labels
    UILabel *pin1 = [[UILabel alloc] initWithFrame:CGRectMake(2, 65, 106, 30)];
    UILabel *pin2 = [[UILabel alloc] initWithFrame:CGRectMake(112, 65, 102, 30)];
    UILabel *pin3 = [[UILabel alloc] initWithFrame:CGRectMake(214, 65, 106, 30)];
    
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
    
    UIButton *moreInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreInfo addTarget:self action:@selector(showMorePinInfo:) forControlEvents:UIControlEventTouchUpInside];
    [moreInfo setFrame:CGRectMake(5, 95, self.contentView.frame.size.width - 10, 40)];
    [moreInfo setImage:[UIImage imageNamed:@"moreInfo.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:moreInfo];
}

-(void)showMorePinInfo:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What are Pins?" message:@"Pick up pins are only posted by the Green Up organizers. These are locations where you can drop off trash bags.\nIf you find hazardous materials you should drop a hazard pin with a description so a Green Up organizer can take care of it.\nNeed help pins can be dropped when you need assistance from the community. Once a location has been cleaned users can mark the pin as addressed and it will be removed from the map." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
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
    [longPressNote setText:@"Tapping the pin will bring you to its location on the map. Long pressing a help needed message bubble will allow you to remove the marker. Removed markers will appear gray on the message board."];
    [longPressNote setNumberOfLines:4];
    [self.contentView addSubview:longPressNote];
}

-(void)showAboutUs
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAboutView" object:nil];
}

-(void)showTutorial
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTutorial" object:nil];
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
