//
//  MapPinCommentView.m
//  GoGreen
//
//  Created by Jordan Rouille on 9/10/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MapPinCommentView.h"
#import <QuartzCore/QuartzCore.h>
#import "ThemeHeader.h"
#import "MessageTypes.h"

#define ANIMATION_DURATION .5

UIColor *defaultTint = nil;

@implementation MapPinCommentView

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"Message - MapCommentView: Showing Pin Comment View");
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setAlpha:0];
        
        //Start Invisible Then Fade In
        self.containerView = [[UIView alloc] initWithFrame:frame];
        [self.containerView setBackgroundColor:[UIColor blackColor]];
        [self.containerView setAlpha:.8];
        [self addSubview:self.containerView];
        
        self.labelField = [[UILabel alloc] initWithFrame:CGRectMake(-320, 25, 290, 110)];
        [self.labelField setTextColor:[UIColor whiteColor]];
        [self.labelField setNumberOfLines:0];
        [self.labelField setTextAlignment:NSTextAlignmentCenter];
        [self.labelField setFont:[UIFont messageFont]];
        [self.labelField setBackgroundColor:[UIColor clearColor]];
        [self.labelField setText:@"Post messages to the community\nHelp Needed:\t\"Asking for help with large items.\"\nHazards:\t\"Alerting the GreenUp organizers of dangerous materials.\"\nMessage must be less than 140 characters."];
        [self addSubview:self.labelField];
        
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            self.messageField = [[UITextView alloc] initWithFrame:CGRectMake(10 + 320, 140, 300, 158)];
        }
        else
        {
            self.messageField = [[UITextView alloc] initWithFrame:CGRectMake(10 + 320, 140, 300, 70)];
        }
        [self.messageField.layer setCornerRadius:5];
        [self.messageField setBackgroundColor:[UIColor whiteColor]];
        [self.messageField setFont:[UIFont messageFont]];
        self.messageField.returnKeyType = UIReturnKeyDone;
        self.messageField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.messageField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self addSubview:self.messageField];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.doneButton setImage:[UIImage imageNamed:@"postButton.png"] forState:UIControlStateNormal];
        [self.doneButton setTitle:@"Post" forState:UIControlStateNormal];
        [self.doneButton setFrame:CGRectMake(10 + 170 + 5 + 60 + 5 + 320, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 60, 45)];
        [self.doneButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton setImage:[UIImage imageNamed:@"cancelButton.png"] forState:UIControlStateNormal];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton setFrame:CGRectMake(10 + 170 + 5 + 320, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 60, 45)];
        [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        self.messageType = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Help", @"Hazard", nil]];
        defaultTint = self.messageType.tintColor;
        [self.messageType setFrame:CGRectMake(10 + 320, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 170, 45)];
        [self.messageType setSelectedSegmentIndex:0];
        [self.messageType addTarget:self action:@selector(typeChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.messageType];
        
        //Set With Keyboard Out
        [self.messageField becomeFirstResponder];
        
        //Fade In
        VoidBlock animationBlock =
        ^{
            [self setAlpha:1];
            [self.labelField setFrame:CGRectMake(15, 25, 290, 110)];
            if([UIScreen mainScreen].bounds.size.height == 568.0)
            {
                [self.messageField setFrame:CGRectMake(10, 140, 300, 158)];
            }
            else
            {
                [self.messageField setFrame:CGRectMake(10, 140, 300, 70)];
            }
            
            [self.doneButton setFrame:CGRectMake(10 + 170 + 5 + 60 + 5, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 60, 45)];
            [self.cancelButton setFrame:CGRectMake(10 + 170 + 5, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 60, 45)];
            
            [self.messageType setFrame:CGRectMake(10, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 170, 45)];
        };
        [UIView animateWithDuration:ANIMATION_DURATION animations:animationBlock];
    }
    return self;
}

-(IBAction)typeChanged:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex == 0)
    {
        [self.messageType setTintColor:defaultTint];
    }
    else
    {
        [self.messageType setTintColor:[UIColor redColor]];
    }
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
        NSLog(@"Message - MapCommentView: Message > 140 Chars (%lu chars)", (unsigned long)self.messageField.text.length);
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
    
        NSString *messageType = nil;
        if(self.messageType.selectedSegmentIndex == 0)
        {
            messageType = MESSAGE_TYPE_USER_MARKER;
        }
        else
        {
            messageType = MESSAGE_TYPE_HAZARD;
        }
        
        NSString *msg = [[self.messageField.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]componentsJoinedByString:@" "];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postMarker" object:[NSArray arrayWithObjects:msg, messageType, nil]];
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
        [self.labelField setFrame:CGRectMake(-320, 25, 290, 110)];
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            [self.messageField setFrame:CGRectMake(10 + 320, 140, 300, 158)];
        }
        else
        {
            [self.messageField setFrame:CGRectMake(10 + 320, 140, 300, 70)];
        }
        
        [self.doneButton setFrame:CGRectMake(10 + 170 + 5 + 60 + 5 + 320, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 60, 45)];
        [self.cancelButton setFrame:CGRectMake(10 + 170 + 5 + 320, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 60, 45)];
        [self.messageType setFrame:CGRectMake(10 + 320, self.messageField.frame.origin.y + self.messageField.frame.size.height + 5, 170, 45)];
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
