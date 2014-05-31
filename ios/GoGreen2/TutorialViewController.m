//
//  TutorialViewController.m
//  GoGreen
//
//  Created by Jordan Rouille on 2/20/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "TutorialViewController.h"
#import "ThemeHeader.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)initWithNavRef:(UINavigationController *)nav
{
    self = [super init];
    if (self)
    {
        self.currentIndex = 0;
        self.navigationController = nav;
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
            {
                [self.view setFrame:CGRectMake(0, 20, 320, 548)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 568)];
            }
        }
        else
        {
            if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
            {
                [self.view setFrame:CGRectMake(0, 20, 320, 460)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 0, 320, 480)];
            }
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:FALSE];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:TRUE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*
    //Left swipe to show settings
    UISwipeGestureRecognizer *leftReconizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [leftReconizer setNumberOfTouchesRequired:1];
    [leftReconizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftReconizer];
    
    //Right swipe to hide settings
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [rightRecognizer setNumberOfTouchesRequired:1];
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightRecognizer];
    */
    
    //[self.navigationController setNavigationBarHidden:FALSE];
    
    //Create Image Array
    self.tutorialImages = [[NSMutableArray alloc] init];
    
    self.currentIndex = 0;
    
    [self.tutorialImages addObject:@"homeIntro.png"];
    [self.tutorialImages addObject:@"homeStartAndMenu.png"];
    [self.tutorialImages addObject:@"homeWithMenu.png"];
    [self.tutorialImages addObject:@"homeCleaning.png"];
    [self.tutorialImages addObject:@"mapHeatMapAndMarkers.png"];
    [self.tutorialImages addObject:@"mapWithToolBar.png"];
    [self.tutorialImages addObject:@"mapWithLongPress.png"];
    [self.tutorialImages addObject:@"messagesGeneralMessage.png"];
    [self.tutorialImages addObject:@"messagesHelpNeeded.png"];
    [self.tutorialImages addObject:@"messagesAddressed.png"];
    [self.tutorialImages addObject:@"messagesWithMenu.png"];
    
    self.tutorialImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.tutorialImages objectAtIndex:self.currentIndex]]];
    [self.tutorialImage setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.tutorialImage];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.leftButton setBackgroundColor:[UIColor blueColor]];
    [self.leftButton setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.leftButton addTarget:self action:@selector(swipeRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leftButton];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.rightButton setBackgroundColor:[UIColor redColor]];
    [self.rightButton setFrame:CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height)];
    [self.rightButton addTarget:self action:@selector(swipeLeft:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rightButton];
}
#pragma mark - Swipe CallBacks
-(IBAction)swipeLeft:(id)sender
{
    if(self.currentIndex == self.tutorialImages.count - 1)
    {
        NSLog(@"ACTION - Tutorial: End of tutorial going back to app");
        [self.navigationController popViewControllerAnimated:FALSE];
    }
    else
    {
        self.currentIndex++;
        
        NSLog(@"ACTION - Tutorial: showing next tutorial image: %d", self.currentIndex);
        [self.tutorialImage setImage:[UIImage imageNamed:[self.tutorialImages objectAtIndex:self.currentIndex]]];
    }
}

-(IBAction)swipeRight:(id)sender
{
    if(self.currentIndex == 0)
    {
        NSLog(@"ACTION - Tutorial: User wanted to skip tutorial :(");
        [self.navigationController popViewControllerAnimated:FALSE];
    }
    else
    {
        self.currentIndex--;
        
        NSLog(@"ACTION - Tutorial: going back in tutorial showing image: %d", self.currentIndex);
        [self.tutorialImage setImage:[UIImage imageNamed:[self.tutorialImages objectAtIndex:self.currentIndex]]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
