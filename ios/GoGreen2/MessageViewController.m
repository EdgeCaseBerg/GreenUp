//
//  AboutViewController.m
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MessageViewController.h"
//#import "FSNConnection.h"
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
    
    for(int i = 0; i < 15; i++)
    {
        NetworkMessage *newMsg = [[NetworkMessage alloc] init];
        NSString *type = nil;
        int rand = arc4random() % 4;
        if(rand == 0)
        {
            type = Message_Cell_Type_A;
        }
        else if(rand == 1)
        {
            type = Message_Cell_Type_B;
        }
        else if(rand == 2)
        {
            type = Message_Cell_Type_C;
        }
        else
        {
            type = Message_Cell_Type_D;
        }

        newMsg.messageType = type;
        newMsg.messageContent = @"this is my first sample message test to see how long the text should be to fit inside the UILabel, this may not work but I sure hope it does!";
        
        [self.messages addObject:newMsg];
    }
    
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
    for(NetworkMessage *msg in self.messages)
    {
        NSLog(@"Message: %@", msg.messageContent);
    }
    
    [self getMessages];
    //[self.theTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Networking Delegates
-(void)getMessages
{
   // GET goes here
}

-(IBAction)post:(id)sender
{
    // POST goes here
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
