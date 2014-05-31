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

@interface ContainerViewController : UIViewController <UITabBarDelegate>

@property (strong, nonatomic) NSArray *views;
@property (strong, nonatomic) UITabBar *theTabBar;
@property (strong, nonatomic) ContainerView *theView;
@property (strong, nonatomic) HomeViewController *theHomeViewController;
@property (strong, nonatomic) MapViewController *theMapViewController;
@property (strong, nonatomic) MessageViewController *theMessageViewController;
@property (strong, nonatomic) MenuView *theMenuView;
@property (strong, nonatomic) UIView *loadingView;
@property (nonatomic, strong) UIView *statusBarFix;

@property int heightFix;

+(ContainerViewController *)sharedContainer;

-(IBAction)hideMenu:(id)sender;
-(IBAction)showMenu:(id)sender;

//Changing Views
-(void)switchHomeView;
-(void)switchMapViewAndDownloadData:(BOOL)downloadData;
-(void)switchMessageView;
-(IBAction)shiftRight:(id)sender;
-(IBAction)shiftLeft:(id)sender;
-(IBAction)hideAllButtHomeView:(id)sender;
-(IBAction)hideAllButtMapView:(id)sender;
-(IBAction)hideAllButtMessageView:(id)sender;

-(BOOL)networkingReachability;

-(void)showLoadingView;
-(void)hideLoadingViewAbrupt:(BOOL)abrupt;
-(void)removeLoadingViewFromView;

@end