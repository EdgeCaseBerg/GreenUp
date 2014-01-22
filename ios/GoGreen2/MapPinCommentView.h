//
//  MapPinCommentView.h
//  GoGreen
//
//  Created by Jordan Rouille on 9/10/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapPinCommentView : UIView

@property (nonatomic, strong) UILabel *labelField;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextView *messageField;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UISegmentedControl *messageType;

@end
