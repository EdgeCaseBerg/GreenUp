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

@interface MessageViewController ()

@end

@implementation MessageViewController

-(MessageViewController *)init
{
    self = [super initWithNibName:@"MessageView_IPhone" bundle:nil];
    self.title = @"About";

    self.messages = [[NSMutableArray alloc] init];
    self.keyboardIsOut = FALSE;
    
    [self getMessages];
    
    self.sendMessageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, 320, 50)];
    [self.sendMessageView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:self.sendMessageView];
    
    UIView *messageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 250, 40)];
    [messageBackgroundView setBackgroundColor:[UIColor whiteColor]];
    [[messageBackgroundView layer] setCornerRadius:5];
    [self.sendMessageView addSubview:messageBackgroundView];
    
    self.messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, 240, 30)];
    self.messageTextField.delegate = self;
    [self.messageTextField setBackgroundColor:[UIColor clearColor]];
    [messageBackgroundView addSubview:self.messageTextField];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"Post" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setFrame:CGRectMake(260, 5, 55, 40)];
    [self.sendMessageView addSubview:sendButton];
    
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
}

-(IBAction)post:(id)sender
{
    if([self.messageTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Blank Message" message:@"Cannot post blank message" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"forum", self.messageTextField.text, nil] forKeys:[NSArray arrayWithObjects:@"type", @"message", nil]];
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
            self.messageTextField.text = @"";
            
            //Get New Messages
            [self getMessages];
            [self.theTableView reloadData];
        }
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.keyboardIsOut = TRUE;
    
    //Shift Subviews For Keyboard
    CGRect currentTableFrame = self.theTableView.frame;
    currentTableFrame.size.height -= 165;
    [self.theTableView setFrame:currentTableFrame];
    
    CGRect currentMessageFrame = self.sendMessageView.frame;
    currentMessageFrame.origin.y -= 165;
    [self.sendMessageView setFrame:currentMessageFrame];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //Shift Subviews For Keyboard
    if(self.keyboardIsOut)
        [self hideKeyboard];
}

-(void)hideKeyboard
{
    self.keyboardIsOut = FALSE;
    
    //Shift Subviews For Keyboard
    CGRect currentTableFrame = self.theTableView.frame;
    currentTableFrame.size.height += 165;
    [self.theTableView setFrame:currentTableFrame];
    
    CGRect currentMessageFrame = self.sendMessageView.frame;
    currentMessageFrame.origin.y += 165;
    [self.sendMessageView setFrame:currentMessageFrame];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.keyboardIsOut)
        [self hideKeyboard];
    
    [self.messageTextField resignFirstResponder];
}

@end
