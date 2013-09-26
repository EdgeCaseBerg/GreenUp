//
//  MessageTypeSelectionView.m
//  GoGreen
//
//  Created by Jordan Rouille on 9/5/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MessageTypeSelectionView.h"

@implementation MessageTypeSelectionView

-(id)initWithWindowFrame:(CGRect)windowFrame andCurrent:(NSString *)current
{
    CGRect myFrame = windowFrame;
    myFrame.size.height = 62;
    myFrame.size.width = 204;
    myFrame.origin.x = (windowFrame.size.width / 2) - (204 / 2);
    myFrame.origin.y = (windowFrame.size.height / 2) - (62 / 2);
    
    self = [super initWithFrame:windowFrame];
    if (self)
    {
        //The BackgroundView With The 80% Fade
        UIView *backgroundView = [[UIView alloc] initWithFrame:windowFrame];
        [backgroundView setBackgroundColor:[UIColor blackColor]];
        [backgroundView setAlpha:.8];
        [self addSubview: backgroundView];
        
        //The Smaller Centered Content View That Contains The Buttons
        UIView *contentSubView = [[UIView alloc] initWithFrame:myFrame];

        UIButton *trashButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [trashButton addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
        trashButton.tag = 0;
        [trashButton setTitle:@"Trash" forState:UIControlStateNormal];
        [trashButton setFrame:CGRectMake(0, 0, 100, 30)];
        [contentSubView addSubview:trashButton];
        if([current isEqualToString:Message_Type_ADMIN])
        {
            [trashButton setBackgroundColor:[UIColor greenColor]];
            self.currentType = Message_Type_ADMIN;
        }
        
        UIButton *forumButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [forumButton addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
        forumButton.tag = 1;
        [forumButton setTitle:@"Forum" forState:UIControlStateNormal];
        [forumButton setFrame:CGRectMake(104, 0, 100, 30)];
        [contentSubView addSubview:forumButton];
        if([current isEqualToString:Message_Type_MARKER])
        {
            [forumButton setBackgroundColor:[UIColor greenColor]];
            self.currentType = Message_Type_MARKER;
        }
        
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [commentButton addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
        commentButton.tag = 2;
        [commentButton setTitle:@"Comment" forState:UIControlStateNormal];
        [commentButton setFrame:CGRectMake(0, 32, 100, 30)];
        [contentSubView addSubview:commentButton];
        if([current isEqualToString:Message_Cell_Type_C])
        {
            [commentButton setBackgroundColor:[UIColor greenColor]];
            self.currentType = Message_Cell_Type_C;
        }
        
        UIButton *pickUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [pickUpButton addTarget:self action:@selector(selectedType:) forControlEvents:UIControlEventTouchUpInside];
        pickUpButton.tag = 3;
        [pickUpButton setTitle:@"Pick Up" forState:UIControlStateNormal];
        [pickUpButton setFrame:CGRectMake(104, 32, 100, 30)];
        [contentSubView addSubview:pickUpButton];
        if([current isEqualToString:Message_Cell_Type_D])
        {
            [pickUpButton setBackgroundColor:[UIColor greenColor]];
            self.currentType = Message_Cell_Type_D;
        }
        
        [backgroundView addSubview:contentSubView];
    }
    return self;
}

-(IBAction)selectedType:(UIButton *)sender
{
    //This is the universal button callback when a user selects a button
    if(sender.tag == 0)
    {
        self.currentType = Message_Type_ADMIN;
    }
    else if(sender.tag == 1)
    {
        self.currentType = Message_Type_MARKER;
    }
    else if(sender.tag == 2)
    {
        self.currentType = Message_Cell_Type_C;
    }
    else
    {
        self.currentType = Message_Cell_Type_D;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageTypeChanged" object:self.currentType];
    
    VoidBlock animationBlock =
    ^{
        [self setAlpha:0];
    };
    
    [UIView animateWithDuration:.25 animations: animationBlock];
    
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.25];
}

-(IBAction)removeViewForGood:(id)sender
{
    [self removeFromSuperview];
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
