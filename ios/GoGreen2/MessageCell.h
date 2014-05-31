//
//  MessageCell.h
//  GoGreen
//
//  Created by Jordan Rouille on 9/3/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHeaders.h"
#import "ThemeHeader.h"

@interface MessageCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *topBackgroundImage;
@property (nonatomic, strong) UIView *middleBackgroundImage;
@property (nonatomic, strong) UIImageView *bottomBackgroundImage;
@property (nonatomic, strong) UIButton *showPinOnMap;
@property (nonatomic, strong) Message *messageObject;
@property (nonatomic, strong) UILabel *textContentLabel;
@property (nonatomic, strong) UILabel *timeStampLabel;

-(id)initWithMessage:(Message *)messageObject isBackwards:(BOOL)backwards isFirst:(BOOL)first andResueIdentifier:(NSString *)reuseIdentifier;
-(void)updateCellWithMessage:(Message *)messageObject isBackwards:(BOOL)backwards isFirst:(BOOL)first andResueIdentifier:(NSString *)reuseIdentifier;

@end
