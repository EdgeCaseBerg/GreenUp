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

@interface MessageViewController ()

@end

@implementation MessageViewController

-(MessageViewController *)init
{
    self = [super initWithNibName:@"MessageView_IPhone" bundle:nil];
    self.title = @"About";

    self.messages = [[NSMutableArray alloc] init];
    
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
        newMsg.messageContent = @"sample message kfhsdjf sdjfsd kfjhsafklj sdflsd fks dlkjf jksdfl ksadjklb lkjbsdfkjl dljkfhs djkafja sdfk faf dfkjs dlkfkldf jdfkl dslf  df dlfsd";
        
        [self.messages addObject:newMsg];
    }
    
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

-(void)post
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
        cell = [[MessageCell alloc] initWithMessageType:msg.messageType isBackwards:TRUE withText:msg.messageContent andResueIdentifier:CellIdentifier];
    }
    else
    {
        cell = [[MessageCell alloc] initWithMessageType:msg.messageType isBackwards:FALSE withText:msg.messageContent andResueIdentifier:CellIdentifier];
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
    
    return size.height + 5;
}
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    
}
 
 */
@end
