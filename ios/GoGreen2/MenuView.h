//
//  MenuView.h
//  GoGreen
//
//  Created by Aidan Melen on 7/18/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_HOME_VIEW @"MenuHomeView"
#define MENU_MAP_VIEW @"MenuMapView"
#define MENU_MESSAGE_VIEW @"MenuMessageView"


@interface MenuView : UIView

- (id)initWithFrame:(CGRect)frame andView:(NSString *)view;

-(void)fadeViewToView:(NSString *)view;

@property (nonatomic, strong) UIImageView *topBarImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) NSMutableArray *previousTimeIntervals;

@end
