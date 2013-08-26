//
//  BDHost.h
//  GoGreen
//
//  Created by Jordan Rouille on 8/18/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDHost : NSObject

+ (NSString *)addressForHostname:(NSString *)hostname;

+ (NSArray *)addressesForHostname:(NSString *)hostname;
+ (NSString *)hostnameForAddress:(NSString *)address;

+ (NSArray *)hostnamesForAddress:(NSString *)address;

+ (NSArray *)ipAddresses;

+ (NSArray *)ethernetAddresses;

@end
