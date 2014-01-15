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

#define ANIMATION_DURATION .5

@implementation MapPinCommentView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"Message - MapCommentView: Showing Pin Comment View");
    
    self = [super initWithFrame:frame];
    if (self)
    {
        //Start Invisible Then Fade In
        self.containerView = [[UIView alloc] initWithFrame:frame];
        [self.containerView setBackgroundColor:[UIColor blackColor]];
        [self.containerView setAlpha:.8];
        [self addSubview:self.containerView];
        
        [self setAlpha:0];
        
        self.labelBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10 - 320, 50, 300, 90)];
        [self.labelBackgroundView.layer setCornerRadius:5];
        [self.labelBackgroundView setBackgroundColor:[UIColor darkGrayColor]];
        [self.containerView addSubview:self.labelBackgroundView];
        
        self.labelField = [[UILabel alloc] initWithFrame:CGRectMake(15, 55, 290, 80)];
        [self.labelField setTextColor:[UIColor redColor]];
        [self.labelField setNumberOfLines:0];
        [self.labelField setTextAlignment:NSTextAlignmentCenter];
        [self.labelField setFont:[UIFont messageFont]];
        [self.labelField setBackgroundColor:[UIColor clearColor]];
        [self.labelField setText:@"Message Cannot Be Blank \nMessage Must Be Less Than 140 Characters \nMessage Cannot Be Deleted \nMessage Will Be Publicly Viewable"];
        [self.containerView addSubview:self.labelField];
        
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            self.messageField = [[UITextView alloc] initWithFrame:CGRectMake(10 + 320, 150, 255, 188)];
            
        }
        else
        {
            self.messageField = [[UITextView alloc] initWithFrame:CGRectMake(10 + 320, 150, 255, 100)];
        }
        [self.messageField.layer setCornerRadius:5];
        [self.messageField setBackgroundColor:[UIColor whiteColor]];
        [self.messageField setFont:[UIFont messageFont]];
        [self.containerView addSubview:self.messageField];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        [self.doneButton setFrame:CGRectMake(270 + 320, 150, 40, 48)];
        [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.doneButton];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setImage:[UIImage imageNamed:@"notCheck.png"] forState:UIControlStateNormal];
        [self.cancelButton setFrame:CGRectMake(270 + 320, 202, 40, 48)];
        [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.containerView addSubview:self.cancelButton];
        
        //Set With Keyboard Out
        [self.messageField becomeFirstResponder];
        
        //Fade In
        VoidBlock animationBlock =
        ^{
            [self setAlpha:1];
            [self.labelBackgroundView setFrame:CGRectMake(10, 50, 300, 90)];
            if([UIScreen mainScreen].bounds.size.height == 568.0)
            {
                [self.messageField setFrame:CGRectMake(10, 150, 255, 188)];
            }
            else
            {
                [self.messageField setFrame:CGRectMake(10, 150, 255, 100)];
            }
            [self.doneButton setFrame:CGRectMake(270, 150, 40, 48)];
            [self.cancelButton setFrame:CGRectMake(270, 202, 40, 48)];
        };
        [UIView animateWithDuration:ANIMATION_DURATION animations:animationBlock];
    }
    return self;
}

-(IBAction)doneButtonPressed:(id)sender
{
    NSLog(@"Action - MapCommentView: Done Button Pressed");
    //Check if Message Meets Criteria
    if(self.messageField.text == nil || [self.messageField.text isEqualToString:@""])
    {
        NSLog(@"Message - MapCommentView: Blank Message");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank Message" message:@"You cannot post a blank message" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(self.messageField.text.length > 140)
    {
        NSLog(@"Message - MapCommentView: Message > 140 Chars (%d chars)", self.messageField.text.length);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message To Large" message:@"You cannot post a message over 140 charecters" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSLog(@"Message - MapCommentView: Removing Show Pin Comment View");
        //Fade OUT
        VoidBlock animationBlock =
        ^{
            [self setAlpha:0];
        };
        [UIView animateWithDuration:ANIMATION_DURATION animations:animationBlock];
        [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:ANIMATION_DURATION];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postMarker" object:self.messageField.text];
    }
}

-(IBAction)cancelButtonPressed:(id)sender
{
    NSLog(@"Action - MapCommentView: Cancle Button Pressed");
    NSLog(@"Message - MapCommentView: Removing Show Pin Comment View");
    //Fade OUT
    VoidBlock animationBlock =
    ^{
        [self setAlpha:0];
        [self.labelBackgroundView setFrame:CGRectMake(10 - 320, 50, 300, 90)];
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            [self.messageField setFrame:CGRectMake(10 + 320, 150, 255, 188)];
        }
        else
        {
            [self.messageField setFrame:CGRectMake(10 + 320, 150, 255, 100)];
        }
        [self.doneButton setFrame:CGRectMake(270 + 320, 150, 40, 48)];
        [self.cancelButton setFrame:CGRectMake(270 + 320, 202, 40, 48)];
    };
    
    [self.messageField resignFirstResponder];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:animationBlock];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:ANIMATION_DURATION];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"markerCanceled" object:nil];
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
