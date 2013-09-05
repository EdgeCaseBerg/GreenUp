//
//  AboutViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MessageViewController.h"
//#import "FSNConnection.h"
#import "CSocketController.h"
#import "greenhttp.h"
#import "ContainerViewController.h"
#import "MessageCell.h"
#import "UIFont+methods.h"
#import "NetworkMessage.h"
#import <QuartzCore/QuartzCore.h>

@interface MessageViewController () <UITextViewDelegate>

@end

@implementation MessageViewController

-(MessageViewController *)init
{
    self = [super initWithNibName:@"MessageView_IPhone" bundle:nil];
    self.title = @"About";

    self.messages = [[NSMutableArray alloc] init];
    self.keyboardIsOut = FALSE;
    
    [self getMessages];
    
    self.messageViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    NSLog(@"***************** %f", self.view.frame.size.height - 50);
    [self.messageViewContainer setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.messageViewContainer];
    
    /*
    UIView *messageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 250, 40)];
    [messageBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [[messageBackgroundView layer] setCornerRadius:5];
    [self.sendMessageView addSubview:messageBackgroundView];
    */
    
    self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 10, 200, 30)];
    self.messageTextView.delegate = self;
    [self.messageTextView setEditable:TRUE];
    [self.messageTextView setScrollEnabled:TRUE];
    [self.messageTextView setBackgroundColor:[UIColor whiteColor]];
    self.messageTextView.layer.cornerRadius = 4.0;
    self.messageTextView.clipsToBounds = YES;
    [self.messageTextView setAutoresizesSubviews:TRUE];
    self.messageTextView.font = [UIFont messageFont];
    self.messageTextView.returnKeyType = UIReturnKeyDone;
    self.messageTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.messageTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.messageTextView addObserver:self forKeyPath: @"contentSize" options:NSKeyValueObservingOptionOld context:NULL];
    self.messageTextView.contentOffset = CGPointMake(0, 5);

    [self.messageViewContainer addSubview:self.messageTextView];
    
    self.messageSendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.messageSendButton setTitle:@"Post" forState:UIControlStateNormal];
    [self.messageSendButton addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageSendButton setFrame:CGRectMake(265, 10, 50, 35)];
    [self.messageViewContainer addSubview:self.messageSendButton];
    
    self.messageTypeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.messageTypeButton setTitle:@"Type" forState:UIControlStateNormal];
    [self.messageTypeButton addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    [self.messageTypeButton setFrame:CGRectMake(210, 10, 50, 35)];
    [self.messageViewContainer addSubview:self.messageTypeButton];
    
    //Keyboard CallBacks
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillShow:)
                                                 name: UIKeyboardWillShowNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification
                                               object: nil];
    
    //Setting Message Type
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(setMessageType:)
                                                 name: @"messageTypeChanged"
                                               object: nil];
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking Delegates
-(void)getMessages
{
    //Remove Old Messages Incase Removed
    [self.messages removeAllObjects];
    
    //Get New Message List
    NSDictionary *response = [[CSocketController sharedCSocketController] performGETRequestToHost:BASE_HOST withRelativeURL:COMMENTS_RELATIVE_URL withPort:API_PORT withProperties:nil];
    
    NSString *statusCode = [response objectForKey:@"status_code"];
    if([statusCode integerValue] == 200)
    {
        NSArray *comments = [response objectForKey:@"comments"];
        for(NSDictionary *comment in comments)
        {
            NetworkMessage *newMessage = [[NetworkMessage alloc] init];
            newMessage.messageContent = [comment objectForKey:@"message"];
            newMessage.messageID = [comment objectForKey:@"id"];
            newMessage.messageTimeStamp = [comment objectForKey:@"timestamp"];
            newMessage.messageType = [comment objectForKey:@"type"];
            newMessage.pinID = [comment objectForKey:@"pin"];
            
            [self.messages addObject:newMessage];
        }
    }
    
#warning SORT MESSAGES BY TIME STAMP!
    
}

-(IBAction)post:(id)sender
{
    if([self.messageTextView.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank Message" message:@"Cannot post blank message" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(self.currentMessageType == nil || [self.currentMessageType isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Type Selected" message:@"Cannot post a message with no type" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if(self.currentMessageType == nil)
            self.currentMessageType = Message_Cell_Type_A;
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.currentMessageType, self.messageTextView.text, nil] forKeys:[NSArray arrayWithObjects:@"type", @"message", nil]];
        NSDictionary *response = [[CSocketController sharedCSocketController] performPOSTRequestToHost:BASE_HOST withRelativeURL:COMMENTS_RELATIVE_URL withPort:API_PORT withProperties:parameters];
        
        NSString *statusCode = [response objectForKey:@"status_code"];
        if([statusCode integerValue] != 200)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Failed" message:@"An unknown error occured please try again" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            //Reset Message Field
            self.messageTextView.text = @"";
            
            //Get New Messages
            [self getMessages];
            [self.theTableView reloadData];
        }
        
        //Clear Old Message Type
        self.currentMessageType = nil;
    }
}


#pragma mark - TABLE VIEW DATA SOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Count: %d", self.messages.count);
    
    return self.messages.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellID";
    
    UITableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil)
    {
        for(UIView *subview in cell.contentView.subviews)
        {
            [subview removeFromSuperview];
        }
    }
    
    NetworkMessage *msg = [self.messages objectAtIndex:indexPath.row];
    
    if(indexPath.row % 2 == 0)
    {
        if(indexPath.row == 0)
        {
            cell = [[MessageCell alloc] initWithMessageType:msg.messageType isBackwards:TRUE isFirstCell:TRUE withText:msg.messageContent andResueIdentifier:CellIdentifier];
        }
        else
        {
            cell = [[MessageCell alloc] initWithMessageType:msg.messageType isBackwards:TRUE isFirstCell:FALSE withText:msg.messageContent andResueIdentifier:CellIdentifier];
        }
    }
    else
    {
        if(indexPath.row == 0)
        {
            cell = [[MessageCell alloc] initWithMessageType:msg.messageType isBackwards:FALSE isFirstCell:TRUE withText:msg.messageContent andResueIdentifier:CellIdentifier];
        }
        else
        {
            cell = [[MessageCell alloc] initWithMessageType:msg.messageType isBackwards:FALSE isFirstCell:FALSE withText:msg.messageContent andResueIdentifier:CellIdentifier];
        }
    }
    return cell;
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
}

#pragma - TABLE VIEW DELEGATE

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
}*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetworkMessage *msg = [self.messages objectAtIndex:indexPath.row];
    
    CGSize size = [[msg messageContent] sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)];
    size.height += + 20 + 6;
    NSLog(@"SIZE HEIGHT: %f - WIDTH: %f", size.height, size.width);
    //return size;
    
    if(indexPath.row == 0)
    {
        return size.height + 25;
    }
    else
    {
        return size.height + 5;
    }
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    
}
 
 */

#pragma mark - UITextField Observer

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id) object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString: @"contentSize"] && object == self.messageTextView)
    {
        CGSize oldContentSize = [[change objectForKey: NSKeyValueChangeOldKey] CGSizeValue];
        float heightDiff = self.messageTextView.contentSize.height - oldContentSize.height;

        CGSize newContentSize = self.messageTextView.contentSize;
        NSLog(@"OLD: %f - New: %f - DIFF: %f", oldContentSize.height, self.messageTextView.contentSize.height, heightDiff);

        if(heightDiff != 0)
        {
            VoidBlock animationBlock =
            ^{
                //Reposition Post Button
                CGRect newFrame = self.messageSendButton.frame;
                newFrame.origin.y += (heightDiff / 2);
                [self.messageSendButton setFrame:newFrame];
                
                //Reposition Type Button
                CGRect newFrame5 = self.messageTypeButton.frame;
                newFrame5.origin.y += (heightDiff / 2);
                [self.messageTypeButton setFrame:newFrame5];
                
                //Reposition MessageBackground
                CGRect newFrame4 = self.messageViewContainer.frame;
                newFrame4.origin.y -= heightDiff;
                newFrame4.size.height += heightDiff;
                [self.messageViewContainer setFrame:newFrame4];
                
                //Reposition Textfield
                CGRect newFrame2 = self.messageTextView.frame;
                newFrame2.size.height += heightDiff;
                [self.messageTextView setFrame:newFrame2];
                
                //Reposition TableView
                CGRect newFrame3 = self.theTableView.frame;
                newFrame3.size.height -= heightDiff;
                [self.theTableView setFrame:newFrame3];
            };
            
            [UIView animateWithDuration: 0.25 animations: animationBlock];
        }
    }
    
    NSLog(@"OBSERVER: %f", self.messageViewContainer.frame.size.height);
    
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [self.messageTextView resignFirstResponder];
        return FALSE;
    }
    else if(textView.text.length > 140)
    {
        if([string isEqualToString:@""] && range.length == 1)
        {
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }
    else
    {
        return TRUE;
    }
}

#pragma mark - Message Methods

-(IBAction)changeType:(id)sender
{
    //Remove Keyboard
    [self.messageTextView resignFirstResponder];
    
    //Create Popover View and Animate It In
    self.messageTypePopoverView = [[MessageTypeSelectionView alloc] initWithWindowFrame:self.view.window.frame andCurrent:self.currentMessageType];
    [self.messageTypePopoverView setAlpha:0];
    [self.view.window addSubview:self.messageTypePopoverView];
    
    VoidBlock animationBlock =
    ^{
        [self.messageTypePopoverView setAlpha:1];
    };
    
    [UIView animateWithDuration:.25 animations: animationBlock];
}

-(IBAction)setMessageType:(NSNotification *)notificationRecieved
{
    self.currentMessageType = notificationRecieved.object;
}

#pragma mark - KEYBOARD CALL BACKS
-(IBAction)keyboardWillShow:(id)sender
{
    self.keyboardIsOut = TRUE;
    
    //Shift Subviews For Keyboard
    CGRect currentTableFrame = self.theTableView.frame;
    NSLog(@"message container height: %f", self.messageViewContainer.frame.size.height);
    currentTableFrame.size.height = (((self.view.frame.size.height - self.theTableView.frame.origin.y) - self.messageViewContainer.frame.size.height) - 165);
    [self.theTableView setFrame:currentTableFrame];
    
    CGRect currentMessageFrame = self.messageViewContainer.frame;
    currentMessageFrame.origin.y = self.view.frame.size.height - self.messageViewContainer.frame.size.height - 165;
    [self.messageViewContainer setFrame:currentMessageFrame];
}
 
-(IBAction)keyboardWillHide:(id)sender
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    self.keyboardIsOut = FALSE;
    
    NSLog(@"HIDE KEYBORAD: %f", self.messageTextView.frame.size.height);
    
    
    //Shift Subviews For Keyboard
    CGRect currentTableFrame = self.theTableView.frame;
    currentTableFrame.size.height = (self.view.frame.size.height - self.theTableView.frame.origin.y) - self.messageViewContainer.frame.size.height;
    [self.theTableView setFrame:currentTableFrame];
    
    CGRect currentMessageViewFrame = self.messageViewContainer.frame;
    currentMessageViewFrame.origin.y = self.view.frame.size.height - self.messageViewContainer.frame.size.height;
    [self.messageViewContainer setFrame:currentMessageViewFrame];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    if(self.keyboardIsOut)
        [self hideKeyboard];
    
    [self.messageTextView resignFirstResponder];
     */
}

@end
