//
//  AboutViewController.h
//  GoGreen
//
//  Created by Jordan Rouille on 2/20/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;

- (id)initWithNavRef:(UINavigationController *)nav;

@end
