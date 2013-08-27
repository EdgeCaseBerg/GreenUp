//
//  Message.h
//  GoGreen
//
//  Created by Aidan Melen on 7/22/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (strong, nonatomic) NSString *messageContent;
@property (strong, nonatomic) NSString *messageType;
@property (strong, nonatomic) NSNumber *pinID;

@end
