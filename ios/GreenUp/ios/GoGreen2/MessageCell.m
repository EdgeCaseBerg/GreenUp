//
//  MessageCell.m
//  GoGreen
//
//  Created by Jordan Rouille on 9/3/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MessageCell.h"
#import "UIFont+methods.h"

@implementation MessageCell

-(id)initWithMessage:(NetworkMessage *)messageObject isBackwards:(BOOL)backwards isFirst:(BOOL)first andResueIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        //Add Extra Top-Padding If First Cell
        int extraTop = 0;
        if(first)
            extraTop = 20;
        
        self.messageObject = messageObject;
        
        //Text Content Label
        self.textContentLabel = [[UILabel alloc] init];
        [self.textContentLabel setText:messageObject.messageContent];
        [self.textContentLabel setNumberOfLines:0];
        [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.textContentLabel setFont:[UIFont messageFont]];
        
        //Get Height of Text With Font And Set Frame
        CGSize contentSize = [messageObject.messageContent sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
        
        [self.textContentLabel setFrame:CGRectMake(15, 6 + extraTop, 260, contentSize.height)];

        NSLog(@"MESSAGE TYPE: %@", messageObject.messageType);
        if([messageObject.messageType isEqualToString:Message_Type_ADMIN])
        {
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_red_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_red_center.png"]]];
        
            //Buttom Slice
            if(backwards)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_red_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_red_bottom.png"]];
            }
            [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop, 300, 20)];
            
            //Add Subviews to ContentView
            [self.contentView addSubview:self.topBackgroundImage];
            [self.contentView addSubview:self.middleBackgroundImage];
            [self.contentView addSubview:self.bottomBackgroundImage];
            [self.contentView addSubview:self.textContentLabel];
        }
        else if([messageObject.messageType isEqualToString:Message_Type_MARKER])
        {
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_green_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_green_center.png"]]];
            
            //Buttom Slice
            if(backwards)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_green_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_green_bottom.png"]];
            }
            [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop, 300, 20)];
            
            //Add Subviews to ContentView
            [self.contentView addSubview:self.topBackgroundImage];
            [self.contentView addSubview:self.middleBackgroundImage];
            [self.contentView addSubview:self.bottomBackgroundImage];
            [self.contentView addSubview:self.textContentLabel];
            
            //Check If Selected
            UIImageView *validationBox = nil;
            if(messageObject.isValid)
            {
                validationBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notCheck.png"]];
            }
            else
            {
                validationBox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"check.png"]];
            }
            [validationBox setFrame:CGRectMake(280, extraTop + ((self.topBackgroundImage.frame.size.height + self.middleBackgroundImage.frame.size.height + (self.bottomBackgroundImage.frame.size.height - 14)) / 2) - 13, 26, 26)];
            self.toggleValidity = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.toggleValidity setFrame:CGRectMake(275, extraTop, 36, self.topBackgroundImage.frame.size.height + self.middleBackgroundImage.frame.size.height + self.bottomBackgroundImage.frame.size.height)];
            [self.toggleValidity addTarget:self action:@selector(toggleValidityOfMessage:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:validationBox];
            [self.contentView addSubview:self.toggleValidity];
        }
        else if([messageObject.messageType isEqualToString:Message_Type_COMMENT])
        {
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_orange_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_orange_center.png"]]];
            
            //Buttom Slice
            if(backwards)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_orange_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_orange_bottom.png"]];
            }
            [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop, 300, 20)];
            
            //Add Subviews to ContentView
            [self.contentView addSubview:self.topBackgroundImage];
            [self.contentView addSubview:self.middleBackgroundImage];
            [self.contentView addSubview:self.bottomBackgroundImage];
            [self.contentView addSubview:self.textContentLabel];
        }
    }
    
    return self;
}

-(IBAction)toggleValidityOfMessage:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMessageValidity" object:self.messageObject];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)clearCell
{
    for(UIView *subview in self.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
}

@end
