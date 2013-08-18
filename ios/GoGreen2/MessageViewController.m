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

@interface MessageViewController ()

@end

@implementation MessageViewController

-(MessageViewController *)init
{
    self = [super initWithNibName:@"MessageView_IPhone" bundle:nil];
    self.title = @"About";

    self.messages = [[NSMutableArray alloc] init];
    
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    for(Message *msg in self.messages)
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

#pragma - Networking Delegates

-(void)getMessages
{
   // GET was here
}

-(void)post
{
    
}

#pragma - TABLE VIEW DATA SOURCE

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
    static NSString *CellIdentifier = @"CountryCell";
    
    UITableViewCell *cell = [self.theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    else
    {
        for(UIView *view in cell.contentView.subviews)
        {
            [view removeFromSuperview];
        }
    }
 
    NSString *message = [[self.messages objectAtIndex:indexPath.row] messageContent];
    NSString *type = [[self.messages objectAtIndex:indexPath.row] messageType];
    NSString *pinID = [[[self.messages objectAtIndex:indexPath.row] pinID] stringValue];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 60)];
    [messageLabel setText:message];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [messageLabel setFont:[messageLabel.font fontWithSize:12]];
    [cell.contentView addSubview:messageLabel];
    
    UILabel *pinIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 310, 10)];
    [pinIDLabel setText:pinID];
    [pinIDLabel setBackgroundColor:[UIColor clearColor]];
    [pinIDLabel setFont:[pinIDLabel.font fontWithSize:8]];
    
    NSLog(@"MESSAGE %@", message);
    
    [cell.contentView addSubview:pinIDLabel];
    
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
    return 85;
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
