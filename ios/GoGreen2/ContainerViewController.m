//
//  ContainerViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 7/12/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "ContainerViewController.h"
//#import "FSNConnection.h"
#import "greenhttp.h"
#import "Message.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface ContainerViewController ()

@property (nonatomic, strong) UITabBarItem *item1;
@property (nonatomic, strong) UITabBarItem *item2;
@property (nonatomic, strong) UITabBarItem *item3;

@end

@implementation ContainerViewController

static ContainerViewController* theContainerView = nil;

#pragma mark - Singlton Initilizer

+(ContainerViewController *)sharedContainer
{
    @synchronized([theContainerView class])
    {
        if (theContainerView == nil)
        {
            theContainerView = [[self alloc] init];
        }
        
        return theContainerView;
    }
    return nil;
}


-(void)viewDidLoad
{
    //Initilize the view
    self.theView = [[ContainerView alloc] initWithFrame:CGRectMake(20, 0, 320, 460)];
    self.view = self.theView;
    
    //Views
    self.theHomeViewController = [[HomeViewController alloc] init];
    self.theMapViewController = [[MapViewController alloc] init];
    self.theMessageViewController = [[MessageViewController alloc] init];
    [self.theHomeViewController.view setFrame:CGRectMake(0, 0, 320, self.theHomeViewController.view.frame.size.height)];
    [self.theMapViewController.view setFrame:CGRectMake(320, 0, 320, self.theMapViewController.view.frame.size.height)];
    [self.theMessageViewController.view setFrame:CGRectMake(640, 0, 320,self.theMessageViewController.view.frame.size.height)];
    self.views = [NSArray arrayWithObjects:self.theHomeViewController, self.theMapViewController, self.theMessageViewController, nil];
    for(UIViewController *vc in self.views)
    {
        [self.view addSubview:vc.view];
    }
    
    //Menu
    self.theMenuView = [[MenuView alloc] initWithFrame:CGRectMake(0, -140, self.view.frame.size.width, 171) andView:MENU_HOME_VIEW];
    [self.view addSubview:self.theMenuView];
    
    //TabBar
    self.theTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 411, 320, 49)];
    self.theTabBar.delegate = self;
    
    self.item1 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:nil] tag:HOME_VIEW];
    self.item2 = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:nil] tag:Map_VIEW];
    self.item3 = [[UITabBarItem alloc] initWithTitle:@"Messages" image:[UIImage imageNamed:nil] tag:MESSAGE_VIEW];
    [self.theTabBar setItems:[NSArray arrayWithObjects:self.item1, self.item2, self.item3, nil] animated:YES];
    [self.theTabBar setSelectedItem:[self.theTabBar.items objectAtIndex:0]];
    [self.view addSubview:self.theTabBar];
    
    //Up swipe to show settings
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideMenu:)];
    [upRecognizer setNumberOfTouchesRequired:1];
    [upRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:upRecognizer];
    
    //Down swipe to hide settings
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [downRecognizer setNumberOfTouchesRequired:1];
    [downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.view addGestureRecognizer:downRecognizer];
    
    //Left swipe to show settings
    UISwipeGestureRecognizer *leftReconizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shiftRight:)];
    [leftReconizer setNumberOfTouchesRequired:1];
    [leftReconizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:leftReconizer];
    
    //Right swipe to hide settings
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(shiftLeft:)];
    [rightRecognizer setNumberOfTouchesRequired:1];
    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:rightRecognizer];
}

#pragma - Tab Bar Delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    //NSLog(@"View: X: %f - Y: %f - Width: %f - Height: %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //NSLog(@"Home: X: %f - Y: %f - Width: %f - Height: %f", self.theHomeViewController.view.frame.origin.x, self.theHomeViewController.view.frame.origin.y, self.theHomeViewController.view.frame.size.width, self.theHomeViewController.view.frame.size.height);
    [self.theMenuView removeFromSuperview];
    
    if(item.tag == HOME_VIEW)
    {
        [self switchHomeView];
    }
    else if(item.tag == Map_VIEW)
    {
        [self switchMapView];
    }
    else if(item.tag == MESSAGE_VIEW)
    {
        [self switchMessageView];
    }
    
    [self.view addSubview:self.theMenuView];
}

-(void)switchHomeView
{
    //[self.theMenuView buildViewForHome];
    [self.theHomeViewController.view setHidden:FALSE];
    [self.theMapViewController.view setHidden:FALSE];
    [self.theTabBar setSelectedItem:self.item1];
    //Animate Block
    VoidBlock animate = ^
    {
        [self.theHomeViewController.view setFrame:CGRectMake(0, 0, 320, self.theHomeViewController.view.frame.size.height)];
        [self.theMapViewController.view setFrame:CGRectMake(320, 0, 320, self.theMapViewController.view.frame.size.height)];
        [self.theMessageViewController.view setFrame:CGRectMake(640, 0, 320, self.theMessageViewController.view.frame.size.height)];
    };
    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
    
    [self performSelector:@selector(hideAllButtHomeView:) withObject:nil afterDelay:.3];
}
-(void)switchMapView
{
    //[self.theMenuView buildViewForMap];
    [self.theMapViewController.view setHidden:FALSE];
    [self.theTabBar setSelectedItem:self.item2];
    //Animate Block
    VoidBlock animate = ^
    {
        [self.theHomeViewController.view setFrame:CGRectMake(-320, 0, 320, self.theHomeViewController.view.frame.size.height)];
        [self.theMapViewController.view setFrame:CGRectMake(0, 0, 320, self.theMapViewController.view.frame.size.height)];
        [self.theMessageViewController.view setFrame:CGRectMake(320, 0, 320, self.theMessageViewController.view.frame.size.height)];
    };
    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
    
    [self performSelector:@selector(hideAllButtMapView:) withObject:nil afterDelay:.3];

}
-(void)switchMessageView
{
    //[self.theMenuView buildViewForMessages];
    [self.theMessageViewController.view setHidden:FALSE];
    [self.theMapViewController.view setHidden:FALSE];
    [self.theTabBar setSelectedItem:self.item3];
    //Animate Block
    VoidBlock animate = ^
    {
        [self.theHomeViewController.view setFrame:CGRectMake(-640, 0, 320, self.theHomeViewController.view.frame.size.height)];
        [self.theMapViewController.view setFrame:CGRectMake(-320, 0, 320, self.theMapViewController.view.frame.size.height)];
        [self.theMessageViewController.view setFrame:CGRectMake(0, 0, 320, self.theMessageViewController.view.frame.size.height)];
    };
    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
    
    [self performSelector:@selector(hideAllButtMessageView:) withObject:nil afterDelay:.3];
}

-(IBAction)hideAllButtHomeView:(id)sender;
{
    [self.theMapViewController.view setHidden:TRUE];
    [self.theMessageViewController.view setHidden:TRUE];
}

-(IBAction)hideAllButtMapView:(id)sender;
{
    [self.theHomeViewController.view setHidden:TRUE];
    [self.theMessageViewController.view setHidden:TRUE];
}

-(IBAction)hideAllButtMessageView:(id)sender;
{
    [self.theHomeViewController.view setHidden:TRUE];
    [self.theMapViewController.view setHidden:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Menu

-(IBAction)hideMenu:(id)sender
{
    VoidBlock animate2 = ^{[self.theMenuView setFrame:CGRectMake(0, -140, self.theMenuView.frame.size.width, self.theMenuView.frame.size.height)];};
    [UIView animateWithDuration:.2 animations:animate2];
}

-(IBAction)showMenu:(id)sender
{
    VoidBlock animate2 = ^{[self.theMenuView setFrame:CGRectMake(0, 0, self.theMenuView.frame.size.width, self.theMenuView.frame.size.height)];};
    [UIView animateWithDuration:.2 animations:animate2];
}

#pragma - Shifting Views

-(IBAction)shiftRight:(id)sender
{
    for(UIViewController *vc in self.views)
    {
        if(vc.view.frame.origin.x == 0)
        {
            if([vc isKindOfClass:[HomeViewController class]])
            {
                [self switchMapView];
                break;
            }
            else if([vc isKindOfClass:[MapViewController class]])
            {
                [self switchMessageView];
                break;
            }
            else if([vc isKindOfClass:[MessageViewController class]])
            {
                //Do Nothing Cant Move More Right
                break;
            }
        }
    }
}

-(IBAction)shiftLeft:(id)sender
{
    for(UIViewController *vc in self.views)
    {
        if(vc.view.frame.origin.x == 0)
        {
            if([vc isKindOfClass:[HomeViewController class]])
            {
                //Do Nothing Cant Move More Right
                break;
            }
            else if([vc isKindOfClass:[MapViewController class]])
            {
                [self switchHomeView];
                break;
            }
            else if([vc isKindOfClass:[MessageViewController class]])
            {
                [self switchMapView];
                break;
            }
        }
    }
}



@end
