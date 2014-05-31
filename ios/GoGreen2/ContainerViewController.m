//
//  ContainerViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 7/12/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "ContainerViewController.h"
#import "CoreDataHeaders.h"
#import "ThemeHeader.h"
#import "AboutViewController.h"
#import "TutorialViewController.h"
#import "Reachability.h"

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
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAboutView) name:@"showAboutView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTutorial) name:@"showTutorial" object:nil];
    
    //Initilize the view
    self.heightFix = 11;
    if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
    {
        self.heightFix = 31;
    }
    
    
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        self.theView = [[ContainerView alloc] initWithFrame:CGRectMake(20, 0, 320, 548)];
    }
    else
    {
        self.theView = [[ContainerView alloc] initWithFrame:CGRectMake(20, 0, 320, 460)];
    }
    
    self.view = self.theView;
    
    //Views
    self.theHomeViewController = [[HomeViewController alloc] init];
    self.theMapViewController = [[MapViewController alloc] init];
    self.theMessageViewController = [[MessageViewController alloc] init];
    

    [self.theHomeViewController.view setFrame:CGRectMake(0, self.heightFix, 320, self.theHomeViewController.view.frame.size.height - self.heightFix)];
    [self.theMapViewController.view setFrame:CGRectMake(320, self.heightFix, 320, self.theMapViewController.view.frame.size.height - self.heightFix)];
    [self.theMessageViewController.view setFrame:CGRectMake(640, self.heightFix, 320,self.theMessageViewController.view.frame.size.height - self.heightFix)];
    self.views = [NSArray arrayWithObjects:self.theHomeViewController, self.theMapViewController, self.theMessageViewController, nil];
    for(UIViewController *vc in self.views)
    {
        [self.view addSubview:vc.view];
    }
    
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(self.theHomeViewController.view.frame.origin.x, 0, self.theHomeViewController.view.frame.size.width, self.theHomeViewController.view.frame.size.height + self.heightFix)];
                        
    [self.loadingView setBackgroundColor:[UIColor blackColor]];
    [self.loadingView setAlpha:0];
    
    //TabBar
    if([UIScreen mainScreen].bounds.size.height == 568)
    {
        if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
        {
            self.theTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 568 - 49, 320, 49)];
        }
        else
        {
            self.theTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 568 - 49 - 20, 320, 49)];
        }
    }
    else
    {
        if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
        {
            self.theTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 480 - 49, 320, 49)];
        }
        else
        {
            self.theTabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 480 - 49 - 20, 320, 49)];
        }
    }
    [self.theTabBar setBackgroundImage:[UIImage imageNamed:@"bottom_menu.png"]];
    
    self.theTabBar.delegate = self;
    
    [self.theTabBar setTintColor:[UIColor whiteColor]];
    
    self.item1 = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home_active.png"] tag:HOME_VIEW];
    [self.item1 setFinishedSelectedImage:[UIImage imageNamed:@"home_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home.png"]];
    self.item2 = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"map_active.png"] tag:Map_VIEW];
    [self.item2 setFinishedSelectedImage:[UIImage imageNamed:@"map_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"map.png"]];
    self.item3 = [[UITabBarItem alloc] initWithTitle:@"Messages" image:[UIImage imageNamed:@"comments_active.png"] tag:MESSAGE_VIEW];
    [self.item3 setFinishedSelectedImage:[UIImage imageNamed:@"comments_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"comments.png"]];
    [self.theTabBar setItems:[NSArray arrayWithObjects:self.item1, self.item2, self.item3, nil] animated:YES];
    [self.theTabBar setSelectedItem:[self.theTabBar.items objectAtIndex:0]];
    [self.view addSubview:self.theTabBar];
    
    //Menu
    if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
    {
        self.theMenuView = [[MenuView alloc] initWithFrame:CGRectMake(0, -120, self.view.frame.size.width, 171) andView:MENU_HOME_VIEW];
    }
    else
    {
        self.theMenuView = [[MenuView alloc] initWithFrame:CGRectMake(0, -140, self.view.frame.size.width, 171) andView:MENU_HOME_VIEW];
    }
    
    [self.view addSubview:self.theMenuView];
    
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
    
    //Notification Center
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMenu:) name:@"toggleMenu" object:nil];
    
    if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
    {
        self.statusBarFix = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
        [self.statusBarFix setBackgroundColor:[UIColor greenUpGreenColor]];
        [self.view addSubview:self.statusBarFix];
    }
    
    [self hideAllButtHomeView:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:TRUE];
}

#pragma mark - Tab Bar Delegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [self.theMenuView removeFromSuperview];
    
    if(item.tag == HOME_VIEW)
    {
        [self switchHomeView];
    }
    else if(item.tag == Map_VIEW)
    {
        [self switchMapViewAndDownloadData:TRUE];
    }
    else if(item.tag == MESSAGE_VIEW)
    {
        [self switchMessageView];
    }
    
    [self.view addSubview:self.theMenuView];
    [self.view bringSubviewToFront:self.statusBarFix];
}

-(void)switchHomeView
{
    NSLog(@"Action - Container: Switching To Home View");
    
    [self.item1 setImage:[UIImage imageNamed:@"home_active.png"]];
    [self.item2 setImage:[UIImage imageNamed:@"map.png"]];
    [self.item3 setImage:[UIImage imageNamed:@"comments.png"]];
    [self.theMenuView fadeViewToView:MENU_HOME_VIEW];
    [self.theHomeViewController.view setHidden:FALSE];
    [self.theMapViewController.view setHidden:FALSE];
    [self.theTabBar setSelectedItem:self.item1];
    //Animate Block
    VoidBlock animate = ^
    {
        [self.theHomeViewController.view setFrame:CGRectMake(0, self.theHomeViewController.view.frame.origin.y, 320, self.theHomeViewController.view.frame.size.height)];
        [self.theMapViewController.view setFrame:CGRectMake(320, self.theMapViewController.view.frame.origin.y, 320, self.theMapViewController.view.frame.size.height)];
        [self.theMessageViewController.view setFrame:CGRectMake(640, self.theMessageViewController.view.frame.origin.y, 320, self.theMessageViewController.view.frame.size.height)];
    };

    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
    
    [self performSelector:@selector(hideAllButtHomeView:) withObject:nil afterDelay:.3];
}
-(void)switchMapViewAndDownloadData:(BOOL)downloadData
{
    NSLog(@"Action - Container: Switching To Map View Downloading Data %d", downloadData);
    
    //Update HeatMap
    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchedToMap" object:[NSNumber numberWithBool:downloadData]];
    
    [self.item1 setImage:[UIImage imageNamed:@"home.png"]];
    [self.item2 setImage:[UIImage imageNamed:@"map_active.png"]];
    [self.item3 setImage:[UIImage imageNamed:@"comments.png"]];
    [self.theMenuView fadeViewToView:MENU_MAP_VIEW];
    [self.theMapViewController.view setHidden:FALSE];
    [self.theTabBar setSelectedItem:self.item2];
    //Animate Block
    VoidBlock animate = ^
    {
        [self.theHomeViewController.view setFrame:CGRectMake(-320, self.theHomeViewController.view.frame.origin.y, 320, self.theHomeViewController.view.frame.size.height)];
        [self.theMapViewController.view setFrame:CGRectMake(0, self.theMapViewController.view.frame.origin.y, 320, self.theMapViewController.view.frame.size.height)];
        [self.theMessageViewController.view setFrame:CGRectMake(320, self.theMessageViewController.view.frame.origin.y, 320, self.theMessageViewController.view.frame.size.height)];
    };
    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
    
    [self performSelector:@selector(hideAllButtMapView:) withObject:nil afterDelay:.3];
}
-(void)switchMessageView
{
    NSLog(@"Action - Container: Switching To MEssage View");
    
    //Update Messages
    [[NSNotificationCenter defaultCenter] postNotificationName:@"switchedToMessages" object:nil];
    
    [self.item1 setImage:[UIImage imageNamed:@"home.png"]];
    [self.item2 setImage:[UIImage imageNamed:@"map.png"]];
    [self.item3 setImage:[UIImage imageNamed:@"comments_active.png"]];
    [self.theMenuView fadeViewToView:MENU_MESSAGE_VIEW];
    [self.theMessageViewController.view setHidden:FALSE];
    [self.theMapViewController.view setHidden:FALSE];
    [self.theTabBar setSelectedItem:self.item3];
    //Animate Block
    VoidBlock animate = ^
    {
        [self.theHomeViewController.view setFrame:CGRectMake(-640, self.theHomeViewController.view.frame.origin.y, 320, self.theHomeViewController.view.frame.size.height)];
        [self.theMapViewController.view setFrame:CGRectMake(-320, self.theMapViewController.view.frame.origin.y, 320, self.theMapViewController.view.frame.size.height)];
        [self.theMessageViewController.view setFrame:CGRectMake(0, self.theMessageViewController.view.frame.origin.y, 320, self.theMessageViewController.view.frame.size.height)];
    };
    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
    
    [self performSelector:@selector(hideAllButtMessageView:) withObject:nil afterDelay:.3];
}

-(IBAction)hideAllButtHomeView:(id)sender
{
    [self.theMapViewController.view setHidden:TRUE];
    [self.theMessageViewController.view setHidden:TRUE];
}

-(IBAction)hideAllButtMapView:(id)sender
{
    [self.theHomeViewController.view setHidden:TRUE];
    [self.theMessageViewController.view setHidden:TRUE];
}

-(IBAction)hideAllButtMessageView:(id)sender
{
    [self.theHomeViewController.view setHidden:TRUE];
    [self.theMapViewController.view setHidden:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tutorial & About Screen
-(void)showTutorial
{
    NSLog(@"ACTION - Home: Showing Tutorial View Controller");

    TutorialViewController *tutorialVC = [[TutorialViewController alloc] initWithNavRef:self.navigationController];
    [self.navigationController pushViewController:tutorialVC animated:FALSE];
}

-(void)showAboutView
{
    NSLog(@"ACTION - Home: Showing About View Controller");
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNavRef:self.navigationController];
    [self.navigationController pushViewController:aboutVC animated:FALSE];
}

#pragma mark - Menu

-(IBAction)toggleMenu:(id)sender
{
    NSLog(@"y: %f", self.theMenuView.frame.origin.y);
    if(self.theMenuView.frame.origin.y < 0)
    {
        [self showMenu:nil];
    }
    else
    {
        [self hideMenu:nil];
    }
}

-(IBAction)hideMenu:(id)sender
{
    NSLog(@"Action - Container: Hiding Menu");
    
    VoidBlock animate2 = ^{
        if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
        {
            [self.theMenuView setFrame:CGRectMake(0, -120, self.theMenuView.frame.size.width, self.theMenuView.frame.size.height)];
        }
        else
        {
           [self.theMenuView setFrame:CGRectMake(0, -140, self.theMenuView.frame.size.width, self.theMenuView.frame.size.height)];
        }};
    [UIView animateWithDuration:.2 animations:animate2];
}

-(IBAction)showMenu:(id)sender
{
    NSLog(@"Action - Container: Showing Menu");
    
    VoidBlock animate2 = ^{
        if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
        {
            [self.theMenuView setFrame:CGRectMake(0, 20, self.theMenuView.frame.size.width, self.theMenuView.frame.size.height)];
        }
        else
        {
            [self.theMenuView setFrame:CGRectMake(0, 0, self.theMenuView.frame.size.width, self.theMenuView.frame.size.height)];
        }};
    [UIView animateWithDuration:.2 animations:animate2];
}

#pragma mark - Shifting Views

-(IBAction)shiftRight:(id)sender
{
    for(UIViewController *vc in self.views)
    {
        if(vc.view.frame.origin.x == 0)
        {
            if([vc isKindOfClass:[HomeViewController class]])
            {
                [self switchMapViewAndDownloadData:TRUE];
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
                [self switchMapViewAndDownloadData:TRUE];
                break;
            }
        }
    }
}

#pragma mark - Loading View
-(void)showLoadingView
{
    [self.loadingView setAlpha:0];
    [self.theMapViewController.view addSubview:self.loadingView];
    VoidBlock animate = ^
    {
        [self.loadingView setAlpha:0.8];
    };
    //Perform Animations
    [UIView animateWithDuration:.3 animations:animate];
}

-(void)hideLoadingViewAbrupt:(BOOL)abrupt
{
    [self.view addSubview:self.loadingView];
    VoidBlock animate = ^
    {
        [self.loadingView setAlpha:0];
    };
    //Perform Animations
    if(abrupt)
    {
        [UIView animateWithDuration:0 animations:animate];
        [self performSelector:@selector(removeLoadingViewFromView) withObject:nil afterDelay:0];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:animate];
        [self performSelector:@selector(removeLoadingViewFromView) withObject:nil afterDelay:.3];
    }
    
}

-(void)removeLoadingViewFromView
{
    [self.loadingView removeFromSuperview];
}

#pragma mark - Network Reachability
-(BOOL)networkingReachability
{
    return TRUE;
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        return FALSE;
    }
    else
    {
        return TRUE;
    }
}



@end