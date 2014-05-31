//
//  AboutViewController.h
//  GoGreen
//
//  Created by Aidan Melen on 6/21/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHeaders.h"

@interface MessageViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (strong, nonatomic) UIView *messageViewContainer;
@property (strong, nonatomic) UITextView *messageTextView;
@property (strong, nonatomic) UIButton *messageSendButton;
@property (strong, nonatomic) NSString *currentMessageType;
@property (strong, nonatomic) NSString *nextPageURL;
@property (strong, nonatomic) Message *toggledMessageRef;
@property (strong, nonatomic) NSNumber *pinIDToShow;
@property (nonatomic, strong) UIView *moreMessagesAlertView;

@property BOOL appendingMessages;
@property BOOL keyboardIsOut;

-(MessageViewController *)init;

//NETWORKING
-(void)getMessages;

@end
