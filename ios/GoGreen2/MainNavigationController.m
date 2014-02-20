//
//  MainNavigationController.m
//  GoGreen
//
//  Created by Jordan Rouille on 2/20/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "MainNavigationController.h"
#import "AboutViewController.h"
#import "TutorialViewController.h"
#import "UIColor+methods.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBarHidden:TRUE];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAboutView) name:@"showAboutView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTutorial) name:@"showTutorial" object:nil];
    
    if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
    {
        self.statusBarFix = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        [self.statusBarFix setBackgroundColor:[UIColor greenUpGreenColor]];
        [self.view addSubview:self.statusBarFix];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)showTutorial
{
    TutorialViewController *tutorialVC = [[TutorialViewController alloc] init];
    [self pushViewController:tutorialVC animated:TRUE];
}

-(void)showAboutView
{
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    [self pushViewController:aboutVC animated:TRUE];
}

@end
