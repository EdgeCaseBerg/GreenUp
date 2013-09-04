//
//  AboutViewController.h
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkMessage.h"
@interface MessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) UIView *sendMessageView;
@property (strong, nonatomic) UITextField *messageTextField;
@property BOOL keyboardIsOut;

-(MessageViewController *)init;

//NETWORKING
-(void)getMessages;
-(void)post;

@end
