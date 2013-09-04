//
//  MessageCell.h
//  GoGreen
//
//  Created by Jordan Rouille on 9/3/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Message_Cell_Type_A @"typeA"
#define Message_Cell_Type_B @"typeB"
#define Message_Cell_Type_C @"typeC"
#define Message_Cell_Type_D @"typeD"

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *topBackgroundImage;
@property (nonatomic, strong) UIView *middleBackgroundImage;
@property (nonatomic, strong) UIImageView *bottomBackgroundImage;

@property (nonatomic, strong) UILabel *textContentLabel;

-(id)initWithMessageType:(NSString *)type isBackwards:(BOOL)backwards isFirstCell:(BOOL)first withText:(NSString *)text andResueIdentifier:(NSString *)reuseIdentifier;

@end
