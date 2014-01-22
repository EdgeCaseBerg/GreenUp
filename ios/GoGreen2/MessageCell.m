//
//  MessageCell.m
//  GoGreen
//
//  Created by Jordan Rouille on 9/3/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MessageCell.h"
#import "UIFont+methods.h"
#import "ContainerViewController.h"
#import "MessageTypes.h"
#import "MarkerTypes.h"

@implementation MessageCell

-(id)initWithMessage:(NetworkMessage *)messageObject isBackwards:(BOOL)backwards isFirst:(BOOL)first andResueIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        //Add Extra Top-Padding If First Cell
        int extraTop = 0;
        if(first)
            extraTop = 20;
        
        self.messageObject = messageObject;

        if([messageObject.messageType isEqualToString:MESSAGE_TYPE_PICK_UP])
        {
            //Text Content Label
            self.textContentLabel = [[UILabel alloc] init];
            [self.textContentLabel setText:messageObject.messageContent];
            [self.textContentLabel setNumberOfLines:0];
            [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
            [self.textContentLabel setFont:[UIFont messageFont]];
            
            //Get Height of Text With Font And Set Frame
            CGSize contentSize = [messageObject.messageContent sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
            
            [self.textContentLabel setFrame:CGRectMake(45, 6 + extraTop, 260, contentSize.height)];
            
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_green_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height + 20)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_green_center.png"]]];
        
            //Buttom Slice
            if(backwards)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_green_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_green_bottom.png"]];
            }
            [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop + 20, 300, 20)];
            
            self.timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.textContentLabel.frame.origin.y + self.textContentLabel.frame.size.height , 230, 20)];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:messageObject.messageTimeStamp];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:elaspedTime];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM dd yyyy hh:mm:ss a"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSString *formattedDate = [dateFormatter stringFromDate:date];
            [self.timeStampLabel setText:[NSString stringWithFormat:@"Posted %@", formattedDate]];
            [self.timeStampLabel setBackgroundColor:[UIColor clearColor]];
            [self.timeStampLabel setFont:[self.timeStampLabel.font fontWithSize:10]];
            [self.timeStampLabel setTextAlignment:NSTextAlignmentLeft];
            
            int height = self.textContentLabel.frame.size.height + self.timeStampLabel.frame.size.height;
            int origin = self.textContentLabel.frame.origin.y;
            origin += (height / 2) - 17;
            
            self.showPinOnMap = [[UIButton alloc] initWithFrame:CGRectMake(13, origin, 30, 34)];
            [self.showPinOnMap setBackgroundImage:[UIImage imageNamed:@"trashMarker.png"] forState:UIControlStateNormal];
            
            //Add Subviews to ContentView
            [self.contentView addSubview:self.topBackgroundImage];
            [self.contentView addSubview:self.middleBackgroundImage];
            [self.contentView addSubview:self.bottomBackgroundImage];
            [self.contentView addSubview:self.textContentLabel];
            [self.contentView addSubview:self.timeStampLabel];
            [self.contentView addSubview:self.showPinOnMap];
        }
        else if([messageObject.messageType isEqualToString:MESSAGE_TYPE_HAZARD])
        {
#warning NOT IMPLEMENTED YET!
            //Gesture Recognizer For Marking As Addressed
            UILongPressGestureRecognizer *addressedGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleAddressed:)];
            [addressedGesture setMinimumPressDuration:1];
            [self addGestureRecognizer:addressedGesture];
            
            //Text Content Label
            self.textContentLabel = [[UILabel alloc] init];
            [self.textContentLabel setText:messageObject.messageContent];
            [self.textContentLabel setNumberOfLines:0];
            [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
            [self.textContentLabel setFont:[UIFont messageFont]];
            
            //Get Height of Text With Font And Set Frame
            CGSize contentSize = [messageObject.messageContent sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
            
            [self.textContentLabel setFrame:CGRectMake(45, 6 + extraTop, 260, contentSize.height)];
            
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_red_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height + 20)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_red_center.png"]]];
            
            //Buttom Slice
            if(backwards)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_red_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_red_bottom.png"]];
            }
            [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop + 20, 300, 20)];
            
            self.timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.textContentLabel.frame.origin.y + self.textContentLabel.frame.size.height , 230, 20)];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:messageObject.messageTimeStamp];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:elaspedTime];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM dd yyyy hh:mm:ss a"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSString *formattedDate = [dateFormatter stringFromDate:date];
            [self.timeStampLabel setText:[NSString stringWithFormat:@"Posted %@", formattedDate]];
            [self.timeStampLabel setBackgroundColor:[UIColor clearColor]];
            [self.timeStampLabel setFont:[self.timeStampLabel.font fontWithSize:10]];
            [self.timeStampLabel setTextAlignment:NSTextAlignmentLeft];
            
            int height = self.textContentLabel.frame.size.height + self.timeStampLabel.frame.size.height;
            int origin = self.textContentLabel.frame.origin.y;
            origin += (height / 2) - 17;
            
            self.showPinOnMap = [[UIButton alloc] initWithFrame:CGRectMake(18, origin, 19, 29)];
            [self.showPinOnMap setBackgroundImage:[UIImage imageNamed:@"hazardMarker.png"] forState:UIControlStateNormal];
            [self.showPinOnMap addTarget:self action:@selector(bringMeToMapPin:) forControlEvents:UIControlEventTouchUpInside];
            
            //Add Subviews to ContentView
            [self.contentView addSubview:self.topBackgroundImage];
            [self.contentView addSubview:self.middleBackgroundImage];
            [self.contentView addSubview:self.bottomBackgroundImage];
            [self.contentView addSubview:self.textContentLabel];
            [self.contentView addSubview:self.timeStampLabel];
            [self.contentView addSubview:self.showPinOnMap];
        }
        else if([messageObject.messageType isEqualToString:MESSAGE_TYPE_USER_MARKER])
        {
            //Gesture Recognizer For Marking As Addressed
            UILongPressGestureRecognizer *addressedGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleAddressed:)];
            [addressedGesture setMinimumPressDuration:1];
            [self addGestureRecognizer:addressedGesture];
            
            //Text Content Label
            self.textContentLabel = [[UILabel alloc] init];
            [self.textContentLabel setText:messageObject.messageContent];
            [self.textContentLabel setNumberOfLines:0];
            [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
            [self.textContentLabel setFont:[UIFont messageFont]];
            
            //Get Height of Text With Font And Set Frame
            CGSize contentSize = [messageObject.messageContent sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
            
            [self.textContentLabel setFrame:CGRectMake(45, 6 + extraTop, 260, contentSize.height)];
            
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_blue_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height + 20)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_blue_center.png"]]];
            
            //Buttom Slice
            if(backwards)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_blue_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_blue_bottom.png"]];
            }
            [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop + 20, 300, 20)];
            
            self.timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.textContentLabel.frame.origin.y + self.textContentLabel.frame.size.height , 230, 20)];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:messageObject.messageTimeStamp];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:elaspedTime];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM dd yyyy hh:mm:ss a"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSString *formattedDate = [dateFormatter stringFromDate:date];
            [self.timeStampLabel setText:[NSString stringWithFormat:@"Posted %@", formattedDate]];
            [self.timeStampLabel setBackgroundColor:[UIColor clearColor]];
            [self.timeStampLabel setFont:[self.timeStampLabel.font fontWithSize:10]];
            [self.timeStampLabel setTextAlignment:NSTextAlignmentLeft];
            
            int height = self.textContentLabel.frame.size.height + self.timeStampLabel.frame.size.height;
            int origin = self.textContentLabel.frame.origin.y;
            origin += (height / 2) - 17;
            
            self.showPinOnMap = [[UIButton alloc] initWithFrame:CGRectMake(18, origin, 19, 29)];
            [self.showPinOnMap setBackgroundImage:[UIImage imageNamed:@"marker.png"] forState:UIControlStateNormal];
            [self.showPinOnMap addTarget:self action:@selector(bringMeToMapPin:) forControlEvents:UIControlEventTouchUpInside];
            
            //Add Subviews to ContentView
            [self.contentView addSubview:self.topBackgroundImage];
            [self.contentView addSubview:self.middleBackgroundImage];
            [self.contentView addSubview:self.bottomBackgroundImage];
            [self.contentView addSubview:self.textContentLabel];
            [self.contentView addSubview:self.timeStampLabel];
            [self.contentView addSubview:self.showPinOnMap];
        }
        else if([messageObject.messageType isEqualToString:MESSAGE_TYPE_MESSAGE])
        {
            //Text Content Label
            self.textContentLabel = [[UILabel alloc] init];
            [self.textContentLabel setText:messageObject.messageContent];
            [self.textContentLabel setNumberOfLines:0];
            [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
            [self.textContentLabel setFont:[UIFont messageFont]];
            
            //Get Height of Text With Font And Set Frame
            CGSize contentSize = [messageObject.messageContent sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX)];
            
            [self.textContentLabel setFrame:CGRectMake(15, 6 + extraTop, 290, contentSize.height)];
            
            //Top Slice
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_orange_top.png"]];
            [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
            
            //Variable Middle Slice
            self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height + 20)];
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_orange_center.png"]]];
            
            //Buttom Slice
            if(backwards)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_orange_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_orange_bottom.png"]];
            }
            [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop + 20, 300, 20)];
            
            self.timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.textContentLabel.frame.origin.y + self.textContentLabel.frame.size.height , 290, 20)];
            NSDate *currentDate = [NSDate date];
            NSTimeInterval elaspedTime = [currentDate timeIntervalSinceDate:messageObject.messageTimeStamp];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:elaspedTime];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM dd yyyy hh:mm:ss a"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSString *formattedDate = [dateFormatter stringFromDate:date];
            [self.timeStampLabel setText:[NSString stringWithFormat:@"Posted %@", formattedDate]];
            [self.timeStampLabel setBackgroundColor:[UIColor clearColor]];
            [self.timeStampLabel setFont:[self.timeStampLabel.font fontWithSize:10]];
            [self.timeStampLabel setTextAlignment:NSTextAlignmentLeft];
            
            //Add Subviews to ContentView
            [self.contentView addSubview:self.topBackgroundImage];
            [self.contentView addSubview:self.middleBackgroundImage];
            [self.contentView addSubview:self.bottomBackgroundImage];
            [self.contentView addSubview:self.textContentLabel];
            [self.contentView addSubview:self.timeStampLabel];
        }
    }
    
    return self;
}

-(IBAction)bringMeToMapPin:(UIButton *)sender
{
    [[ContainerViewController sharedContainer] showLoadingView];
    [[[ContainerViewController sharedContainer] theMapViewController] setPinIDToShow:self.messageObject.pinID];
    [[ContainerViewController sharedContainer] switchMapViewAndDownloadData:FALSE];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToMapPin" object:nil];
}


-(IBAction)toggleAddressed:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleMessageAddressed" object:self.messageObject];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)clearCell
{
    for(UIView *subview in self.contentView.subviews)
    {
        [subview removeFromSuperview];
    }
}

@end
