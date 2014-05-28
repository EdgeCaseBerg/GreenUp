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
#import "NetworkingController.h"

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
        
        self.mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 180, 260, 70)];
        [self.mainLabel  setNumberOfLines:4];
        [self.mainLabel  setBackgroundColor:[UIColor clearColor]];
        [self.mainLabel  setTextColor:[UIColor blackColor]];
        [self.mainLabel  setFont:[self.mainLabel .font fontWithSize:14]];
        [self.mainLabel  setTextAlignment:NSTextAlignmentCenter];
        [self.mainLabel  setText:@"Track your clean up progress\nSee what areas need the most help\nFind an area to drop off what you pick up"];
        [self.view addSubview:self.mainLabel ];
        
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedGettingHomeMessage:) name:@"finishedGettingHomeMessage" object:nil];
        
        [[NetworkingController shared] getHomeMessage];
        
        self.previousLoggingTimes = [[NSMutableArray alloc] init];
    }

    return self;
}

-(void)finishedGettingHomeMessage:(NSNotification *)message
{
    if([message.object isKindOfClass:[NSString class]])
    {
        //FAILED
        NSLog(@"FAILED");
    }
    else
    {
        NSDictionary *messages = message.object;
        NSLog(@"%@", messages);
        
        NSMutableString *updatdHomeMessage = [[NSMutableString alloc] init];
        [updatdHomeMessage appendFormat:@"%@", [messages objectForKey:@"message"]];
        [updatdHomeMessage appendFormat:@"\n"];
        [updatdHomeMessage appendFormat:@"Green Up Day Starts on %@", [messages objectForKey:@"date"]];
        
        [self.mainLabel setText:updatdHomeMessage];
    }
}

-(IBAction)toggleCleanUp:(id)sender
{
    if(![[[ContainerViewController sharedContainer] theMapViewController] logging])
    {
        NSLog(@"Action - Home: Starting Clean Up");
        NSDate *currentDate = [NSDate date];
        NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:self.startDate];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:elaspedTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        NSLog(@"Action - Home: Started Clean Up At: %@", formattedDate);
        
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
        NSDate *currentDate = [NSDate date];
        NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:self.startDate];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:elaspedTime];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSString *formattedDate = [dateFormatter stringFromDate:date];
        NSLog(@"Action - Home: Stopping Clean Up At: %@", formattedDate);
        NSLog(@"Message - Home: Total Clean Up Time: %f", (-1 * [self.startDate timeIntervalSinceNow]));
        
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
