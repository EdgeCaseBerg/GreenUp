//
//  MessageTypeSelectionView.h
//  GoGreen
//
//  Created by Jordan Rouille on 9/5/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"

typedef void (^VoidBlock)(void);

@interface MessageTypeSelectionView : UIView
@property (nonatomic, strong) NSString *currentType;

-(id)initWithWindowFrame:(CGRect)windowFrame andCurrent:(NSString *)current;

@end
