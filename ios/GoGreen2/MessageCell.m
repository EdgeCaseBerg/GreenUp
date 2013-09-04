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

-(id)initWithMessageType:(NSString *)type isBackwards:(BOOL)backwards isFirstCell:(BOOL)first withText:(NSString *)text andResueIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        //Add Extra Top-Padding If First Cell
        int extraTop = 0;
        if(first)
            extraTop = 20;

        
        //Text Content Label
        self.textContentLabel = [[UILabel alloc] init];
        [self.textContentLabel setText:text];
        [self.textContentLabel setNumberOfLines:0];
        [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.textContentLabel setFont:[UIFont messageFont]];
        
        //Get Height of Text With Font And Set Frame
        CGSize contentSize = [text sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX)];
        
        [self.textContentLabel setFrame:CGRectMake(15, 6 + extraTop, 290, contentSize.height)];

        if([type isEqualToString:Message_Cell_Type_A])
        {
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_red_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_red_center"]]];
        
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
        }
        else if([type isEqualToString:Message_Cell_Type_B])
        {
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_green_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_green_center"]]];
            
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
        }
        else if([type isEqualToString:Message_Cell_Type_C])
        {
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_orange_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_orange_center"]]];
            
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
        }
        else
        {
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_yellow_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_yellow_center"]]];
            
            //Buttom Slice
            if(backwards)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_yellow_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_yellow_bottom.png"]];
            }
            [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop, 300, 20)];
        }
        
        //Add Subviews to ContentView
        [self.contentView addSubview:self.topBackgroundImage];
        [self.contentView addSubview:self.middleBackgroundImage];
        [self.contentView addSubview:self.bottomBackgroundImage];
        [self.contentView addSubview:self.textContentLabel];
    }
    
    return self;
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
