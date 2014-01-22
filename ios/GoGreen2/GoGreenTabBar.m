//
//  GoGreenTabBar.m
//  GoGreen
//
//  Created by Aidan Melen on 7/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "GoGreenTabBar.h"

@interface GoGreenTabBar ()

@end

@implementation GoGreenTabBar

-(GoGreenTabBar *)initWithItems:(NSArray *)items
{
    if(self = [super init])
    {
        //DO STUFF
        self.items = items;
    }
    return self;
}

-(void)goGreenTabBar:(GoGreenTabBar *)bar didSelectItem:(UITabBarItem *)item;
{
    
}


@end
