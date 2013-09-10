//
//  MapPinCommentView.m
//  GoGreen
//
//  Created by Jordan Rouille on 9/10/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MapPinCommentView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+methods.h"
#import "UIColor+methods.h"

@implementation MapPinCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //Start Invisible Then Fade In
        self.containerView = [[UIView alloc] initWithFrame:frame];
        [self.containerView setBackgroundColor:[UIColor blackColor]];
        [self.containerView setAlpha:.8];
        [self addSubview:self.containerView];
        
        [self setAlpha:0];
        
        UIView *labelBackground = [[UIView alloc] initWithFrame:CGRectMake(10, 50, 300, 90)];
        [labelBackground.layer setCornerRadius:5];
        [labelBackground setBackgroundColor:[UIColor darkGrayColor]];
        [self.containerView addSubview:labelBackground];
        
        self.labelField = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 290, 80)];
        [self.labelField setTextColor:[UIColor redColor]];
        [self.labelField setNumberOfLines:0];
        [self.labelField setTextAlignment:NSTextAlignmentCenter];
        [self.labelField setFont:[UIFont messageFont]];
        [self.labelField setBackgroundColor:[UIColor clearColor]];
        [self.labelField setText:@"Message Cannot Be Blank \nMessage Must Be Less Than 140 Characters \nMessage Cannot Be Deleted \nMessage Will Be Publicly Viewable"];
        [self.containerView addSubview:self.labelField];
        
        self.messageField = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, 255, 100)];
        [self.messageField.layer setCornerRadius:5];
        [self.messageField setBackgroundColor:[UIColor whiteColor]];
        [self.messageField setFont:[UIFont messageFont]];
        [self.containerView addSubview:self.messageField];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.doneButton setFrame:CGRectMake(270, 150, 40, 100)];
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.doneButton];
        
        //Set With Keyboard Out
        [self.messageField becomeFirstResponder];
        
        //Fade In
        VoidBlock animationBlock =
        ^{
            [self setAlpha:1];
        };
        [UIView animateWithDuration:.25 animations:animationBlock];
    }
    return self;
}

-(IBAction)doneButtonPressed:(id)sender
{
    //Fade OUT
    VoidBlock animationBlock =
    ^{
        [self setAlpha:0];
    };
    [UIView animateWithDuration:.25 animations:animationBlock];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.25];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
