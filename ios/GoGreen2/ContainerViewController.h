//  ContainerViewController.h
//  GoGreen
//
//  Created by Aidan Melen on 7/12/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContainerView.h"
#import "HomeViewController.h"
#import "MapViewController.h"
#import "MessageViewController.h"
#import "MenuView.h"
//#import "GoGreenTabBar.h"

#define HOME_VIEW 0
#define Map_VIEW 1
#define MESSAGE_VIEW 2

#define API_PORT 30002
#define BASE_HOST @"localhost"
#define HEAT_MAP_RELATIVE_URL @"/api/heatmap"
#define COMMENTS_RELATIVE_URL @"/api/comments"

typedef void (^VoidBlock)(void);

@interface ContainerViewController : UIViewController <UITabBarDelegate>

@property (strong, nonatomic) NSArray *views;
@property (strong, nonatomic) UITabBar *theTabBar;
@property (strong, nonatomic) ContainerView *theView;
@property (strong, nonatomic) HomeViewController *theHomeViewController;
@property (strong, nonatomic) MapViewController *theMapViewController;
@property (strong, nonatomic) MessageViewController *theMessageViewController;
@property (strong, nonatomic) MenuView *theMenuView;

+(ContainerViewController *)sharedContainer;

-(IBAction)hideMenu:(id)sender;
-(IBAction)showMenu:(id)sender;

//Changing Views
-(void)switchHomeView;
-(void)switchMapView;
-(void)switchMessageView;
-(IBAction)shiftRight:(id)sender;
-(IBAction)shiftLeft:(id)sender;
-(void)hideAllButtHomeView;
-(void)hideAllButtMapView;
-(void)hideAllButtMessageView;
-(char *)getIPFromHost:(NSString *)host;

@end