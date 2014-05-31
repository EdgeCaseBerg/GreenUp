//
//  HomeViewController.h
//  GoogleGreenMapTest
//
//  Created by Aidan Melen on 7/12/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UILabel *mainLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UIButton *cleanUpToggleButton;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSMutableArray *previousLoggingTimes;

-(IBAction)toggleCleanUp:(id)sender;

@end
