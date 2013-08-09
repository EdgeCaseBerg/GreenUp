//
//  HomeViewController.m
//  GoogleGreenMapTest
//
//  Created by Aidan Melen on 7/12/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "HomeViewController.h"
#import "ContainerViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"HomeView_IPhone" bundle:nil];
    if (self)
    {
        // Custom initialization
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
        [self.cleanUpToggleButton setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
        [self.cleanUpToggleButton setTitle:@"Start Cleaning" forState:UIControlStateNormal];
        [self.cleanUpToggleButton addTarget:self action:@selector(toggleCleanUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.cleanUpToggleButton];
    }

    return self;
}

-(IBAction)toggleCleanUp:(id)sender
{
    [[[ContainerViewController sharedContainer] theMapViewController] toggleLogging:nil];
    if([[[ContainerViewController sharedContainer] theMapViewController] logging])
    {
        [[ContainerViewController sharedContainer] switchMapView];
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
