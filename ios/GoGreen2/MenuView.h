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

typedef void (^VoidBlock)(void);

@interface MenuView : UIView

- (id)initWithFrame:(CGRect)frame andView:(NSString *)view;
-(void)buildViewForHome;
-(void)buildViewForMap;
-(void)buildViewForMessages;


@end
