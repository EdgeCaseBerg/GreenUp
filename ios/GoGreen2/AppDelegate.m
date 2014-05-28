//
//  AppDelegate.m
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "MapViewController.h"
#import "MessageViewController.h"
#import "HeatMapView.h"
#import "NetworkingController.h"
#import "TutorialViewController.h"

#import "TestFlight.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"************* Application Starting ************* ");
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    //{
        self.customContainer = [ContainerViewController sharedContainer];
    
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.customContainer];
        if ([nav respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            nav.interactivePopGestureRecognizer.enabled = NO;
        }
    
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
        {
            NSLog(@"ACTION - AppDelegate: First launch showing tutorial!");
            [[NSUserDefaults standardUserDefaults] setObject: @YES forKey: @"HasLaunchedOnce"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            TutorialViewController *tutorialVC = [[TutorialViewController alloc] initWithNavRef:nav];
            [nav pushViewController:tutorialVC animated:FALSE];
        }
    
        [nav setNavigationBarHidden:TRUE];
    
        self.window.rootViewController = nav;
        
        [TestFlight takeOff:@"60fa253d-8284-496a-97c3-34b3f1cb179c"];
    //}
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    /*
    NSLog(@"to background");
    
    self.appInBackground = TRUE;
    
    UIBackgroundTaskIdentifier bgTask = 0;
    
    UIApplication *app = [UIApplication sharedApplication];
    
    
    // Request permission to run in the background. Provide an
    // expiration handler in case the task runs long.
    NSAssert(bgTask == UIBackgroundTaskInvalid, nil);
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        // Synchronize the cleanup call on the main thread in case
        // the task actually finishes at around the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (bgTask != UIBackgroundTaskInvalid)
            {
                [app endBackgroundTask:bgTask];
                __block UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task.
        
        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [locationManager startMonitoringSignificantLocationChanges];
        [locationManager startUpdatingLocation];
        
        NSLog(@"App staus: applicationDidEnterBackground");
        // Synchronize the cleanup call on the main thread in case
        // the expiration handler is fired at the same time.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                [app endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    NSLog(@"backgroundTimeRemaining: %.0f", [[UIApplication sharedApplication] backgroundTimeRemaining]);
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
