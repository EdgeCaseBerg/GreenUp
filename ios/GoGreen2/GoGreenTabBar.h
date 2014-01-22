//
//  GoGreenTabBar.h
//  GoGreen
//
//  Created by Aidan Melen on 7/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoGreenTabBar;

@protocol GoGreenTabBarDelegate<NSObject>

@required
-(void)goGreenTabBar:(GoGreenTabBar *)bar didSelectItem:(UITabBarItem *)item;

@end

@interface GoGreenTabBar : UIView

@property (nonatomic,assign) id <GoGreenTabBarDelegate>delegate;
@property (nonatomic, strong) NSArray *items;
@property int selectedItem;

-(GoGreenTabBar *)initWithItems:(NSArray *)items;

@end