//
//  HomeViewController.m
//  GoogleGreenMapTest
//
//  Created by Aidan Melen on 7/12/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "HomeViewController.h"
#import "ContainerViewController.h"
#import "MenuView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        self = [super initWithNibName:@"HomeView_IPhone5" bundle:nil];
    }
    else
    {
        self = [super initWithNibName:@"HomeView_IPhone" bundle:nil];
    }
    
    if(self)
    {
        // Custom initialization
        UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
        [logo setFrame:CGRectMake(0, 0, 320, 207)];
        [self.view addSubview:logo];
        
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 180, 260, 70)];
        [mainLabel setNumberOfLines:4];
        [mainLabel setBackgroundColor:[UIColor clearColor]];
        [mainLabel setTextColor:[UIColor blackColor]];
        [mainLabel setFont:[mainLabel.font fontWithSize:14]];
        [mainLabel setTextAlignment:NSTextAlignmentCenter];
        [mainLabel setText:@"Track your clean up progres\nSee what areas need the most help\nFind an area to drop off what you pick up"];
        [self.view addSubview:mainLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 250, 260, 60)];
        [self.timeLabel setText:@"00:00:00"];
        [self.timeLabel setFont:[self.timeLabel.font fontWithSize:25]];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setTextColor:[UIColor blackColor]];
        [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:self.timeLabel];
        
        self.cleanUpToggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cleanUpToggleButton setFrame:CGRectMake(30, 320, 260, 45)];
        [self.cleanUpToggleButton setBackgroundImage:[UIImage imageNamed:@"Start.png"] forState:UIControlStateNormal];
        [self.cleanUpToggleButton setTitle:@"Start Cleaning" forState:UIControlStateNormal];
        [self.cleanUpToggleButton addTarget:self action:@selector(toggleCleanUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.cleanUpToggleButton];
        
        self.previousLoggingTimes = [[NSMutableArray alloc] init];
    }

    return self;
}


-(IBAction)toggleCleanUp:(id)sender
{
    if(![[[ContainerViewController sharedContainer] theMapViewController] logging])
    {
        if([[ContainerViewController sharedContainer] networkingReachability])
        {
            [[[ContainerViewController sharedContainer] theMapViewController] toggleLogging:nil];
            self.startDate = [NSDate date];
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cleanUpCounter:) userInfo:nil repeats:YES];
            
            [[ContainerViewController sharedContainer] switchMapViewAndDownloadData:TRUE];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Start Cleaning" message:@"You dont appear to have a network connection, please connect and try and start cleaning" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        [[[ContainerViewController sharedContainer] theMapViewController] toggleLogging:nil];
        
        [self.previousLoggingTimes addObject:[NSNumber numberWithDouble:(-1 * [self.startDate timeIntervalSinceNow])]];
        if([[[[ContainerViewController sharedContainer] theHomeViewController] view] frame].origin.x == 0 && [[[[ContainerViewController sharedContainer] theHomeViewController] view] frame].size.width != 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHomeMenuWithNewPreviousTimes" object:nil];
        }
    }
}

- (void)cleanUpCounter:(NSTimer*)theTimer
{
    // code is written so one can see everything that is happening
    // I am sure, some people would combine a few of the lines together
    NSDate *currentDate = [NSDate date];
    NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:self.startDate];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:elaspedTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    
    if(elaspedTime >= 1 && [[[ContainerViewController sharedContainer] theMapViewController] logging])
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%@", formattedDate];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
