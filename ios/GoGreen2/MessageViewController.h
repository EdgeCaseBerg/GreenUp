//
//  AboutViewController.h
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkMessage.h"

@interface MessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) UIView *messageViewContainer;
@property (strong, nonatomic) UITextView *messageTextView;
@property (strong, nonatomic) UIButton *messageSendButton;
@property (strong, nonatomic) NSString *currentMessageType;
@property (strong, nonatomic) NSString *nextPageURL;
@property (strong, nonatomic) NetworkMessage *toggledMessageRef;
@property (strong, nonatomic) NSNumber *pinIDToShow;

@property BOOL keyboardIsOut;

-(MessageViewController *)init;

//NETWORKING
-(void)getMessages;
-(void)post;

@end
