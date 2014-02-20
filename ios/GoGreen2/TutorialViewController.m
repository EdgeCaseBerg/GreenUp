//
//  TutorialViewController.m
//  GoGreen
//
//  Created by Jordan Rouille on 2/20/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
            {
                [self.view setFrame:CGRectMake(0, 20, 320, 548)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 20, 320, 568)];
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
                [self.view setFrame:CGRectMake(0, 20, 320, 480)];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, 320, 20)];
    [test setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
