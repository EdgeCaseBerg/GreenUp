//
//  MessageCell.m
//  GoGreen
//
//  Created by Jordan Rouille on 9/3/13.
//  Copyright (c) 2013 Aidan Melen. All rights reserved.
//

#import "MessageCell.h"
#import "ThemeHeader.h"
#import "ContainerViewController.h"

@implementation MessageCell

-(id)initWithMessage:(Message *)messageObject isBackwards:(BOOL)backwards isFirst:(BOOL)first andResueIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
    {
        [self updateCellWithMessage:messageObject isBackwards:backwards isFirst:first andResueIdentifier:reuseIdentifier];
    }
    
    return self;
}



-(IBAction)bringMeToMapPin:(UIButton *)sender
{
    [[ContainerViewController sharedContainer] showLoadingView];
    [[[ContainerViewController sharedContainer] theMapViewController] setPinIDToShow:self.messageObject.markerID];
    [[ContainerViewController sharedContainer] switchMapViewAndDownloadData:FALSE];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToMapPin" object:nil];
}

-(void)updateCellWithMessage:(Message *)messageObject isBackwards:(BOOL)backwards isFirst:(BOOL)first andResueIdentifier:(NSString *)reuseIdentifier
{
    //Add Extra Top-Padding If First Cell
    int extraTop = 0;
    if(first)
        extraTop = 20;
    
    self.messageObject = messageObject;

    NSString *contentText = self.messageObject.message;
    
    if([messageObject.messageType isEqualToString:MESSAGE_TYPE_3_NETWORK_NAME])
    {
        //Text Content Label
        self.textContentLabel = [[UILabel alloc] init];

        [self.textContentLabel setText:contentText];
        [self.textContentLabel setNumberOfLines:10];
        [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.textContentLabel setFont:[UIFont messageFont]];
        
        //Get Height of Text With Font And Set Frame
        CGSize contentSize = [messageObject.message sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
        
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
        [self.timeStampLabel setText:[self buildTimeSinceString]];
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
    else if([messageObject.messageType isEqualToString:MESSAGE_TYPE_2_NETWORK_NAME])
    {
        //Gesture Recognizer For Marking As Addressed
        UILongPressGestureRecognizer *addressedGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleAddressed:)];
        [addressedGesture setMinimumPressDuration:1];
        [self addGestureRecognizer:addressedGesture];
        
        //Text Content Label
        self.textContentLabel = [[UILabel alloc] init];
        [self.textContentLabel setText:contentText];
        [self.textContentLabel setNumberOfLines:0];
        [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.textContentLabel setFont:[UIFont messageFont]];
        
        //Get Height of Text With Font And Set Frame
        CGSize contentSize = [messageObject.message sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
        
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
        [self.timeStampLabel setText:[self buildTimeSinceString]];
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
    else if([messageObject.messageType isEqualToString:MESSAGE_TYPE_1_NETWORK_NAME])
    {
        //Gesture Recognizer For Marking As Addressed
        UILongPressGestureRecognizer *addressedGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleAddressed:)];
        [addressedGesture setMinimumPressDuration:1];
        [self addGestureRecognizer:addressedGesture];
        
        //Text Content Label
        self.textContentLabel = [[UILabel alloc] init];
        [self.textContentLabel setText:contentText];
        [self.textContentLabel setNumberOfLines:0];
        [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.textContentLabel setFont:[UIFont messageFont]];
        
        //Get Height of Text With Font And Set Frame
        CGSize contentSize = [messageObject.message sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(260, CGFLOAT_MAX)];
        
        [self.textContentLabel setFrame:CGRectMake(45, 6 + extraTop, 260, contentSize.height)];
        
        //Top Slice
        if(messageObject.addressed)
        {
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_gray_top.png"]];
        }
        else
        {
            self.topBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_blue_top.png"]];
        }
        [self.topBackgroundImage setFrame:CGRectMake(10, extraTop, 300, 6)];
        
        //Variable Middle Slice
        self.middleBackgroundImage = [[UIView alloc] initWithFrame:CGRectMake(10, 6 + extraTop, 300, contentSize.height + 20)];
        if(messageObject.addressed)
        {
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_gray_center.png"]]];
        }
        else
        {
            [self.middleBackgroundImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bubble_blue_center.png"]]];
        }
        
        //Buttom Slice
        if(backwards)
        {
            if(messageObject.addressed)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_gray_bottom_reverse.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_blue_bottom_reverse.png"]];
            }
        }
        else
        {
            if(messageObject.addressed)
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_gray_bottom.png"]];
            }
            else
            {
                self.bottomBackgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble_blue_bottom.png"]];
            }
        }
        [self.bottomBackgroundImage setFrame:CGRectMake(10, contentSize.height + 6 + extraTop + 20, 300, 20)];
        
        self.timeStampLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.textContentLabel.frame.origin.y + self.textContentLabel.frame.size.height , 230, 20)];
        [self.timeStampLabel setText:[self buildTimeSinceString]];
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
    else if([messageObject.messageType isEqualToString:MESSAGE_TYPE_4_NETWORK_TYPE])
    {
        //Text Content Label
        self.textContentLabel = [[UILabel alloc] init];
        [self.textContentLabel setText:contentText];
        [self.textContentLabel setNumberOfLines:0];
        [self.textContentLabel setBackgroundColor:[UIColor clearColor]];
        [self.textContentLabel setFont:[UIFont messageFont]];
        
        //Get Height of Text With Font And Set Frame
        CGSize contentSize = [messageObject.message sizeWithFont:[UIFont messageFont] constrainedToSize:CGSizeMake(290, CGFLOAT_MAX)];
        
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
        
        [self.timeStampLabel setText:[self buildTimeSinceString]];
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

-(NSString *)buildTimeSinceString
{
#warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    NSDictionary *elaspedTime = nil;
    //NSDictionary *elaspedTime = [self timeBetween:self.messageObject.messageTimeStamp and:[NSDate date]];
    NSString *timeString = nil;
    if(![[elaspedTime objectForKey:@"days"] isEqualToNumber:@0])
    {
        timeString = [NSString stringWithFormat:@"Posted: %ld days ago", (long)((NSNumber *)[elaspedTime objectForKey:@"days"]).integerValue];
    }
    else if(![[elaspedTime objectForKey:@"hours"] isEqualToNumber:@0])
    {
        timeString = [NSString stringWithFormat:@"Posted: %ld hours ago", (long)((NSNumber *)[elaspedTime objectForKey:@"hours"]).integerValue];
    }
    else if(![[elaspedTime objectForKey:@"minutes"] isEqualToNumber:@0])
    {
        timeString = [NSString stringWithFormat:@"Posted: %ld minutes ago", (long)((NSNumber *)[elaspedTime objectForKey:@"minutes"]).integerValue];
    }
    else if(![[elaspedTime objectForKey:@"seconds"] isEqualToNumber:@0])
    {
        timeString = [NSString stringWithFormat:@"Posted: %ld seconds ago", (long)((NSNumber *)[elaspedTime objectForKey:@"seconds"]).integerValue];
    }
    else
    {
        timeString = [NSString stringWithFormat:@"Posted: Just Now"];
    }
    return timeString;
}

- (NSDictionary *)timeBetween:(NSDate *)dt1 and:(NSDate *)dt2
{
    NSUInteger secondUnit =  NSSecondCalendarUnit;
    NSUInteger minuteUnit =  NSMinuteCalendarUnit;
    NSUInteger hourUnit =  NSHourCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSNumber *seconds = nil;
    NSNumber *minutes = nil;
    NSNumber *hours = nil;
    NSNumber *days = nil;
    if(dt1 == nil)
    {
        seconds = @0;
        minutes = @0;
        hours = @0;
        days = @0;
    }
    else
    {
        seconds = @([[calendar components:secondUnit fromDate:dt1 toDate:dt2 options:0] second] % 60);
        minutes = @([[calendar components:minuteUnit fromDate:dt1 toDate:dt2 options:0] minute] % 60);
        hours = @([[calendar components:hourUnit fromDate:dt1 toDate:dt2 options:0] hour] % 60);
        days = @(floor(hours.floatValue / 24));
    }
    
    NSDictionary *components = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:seconds, minutes, hours, days, nil] forKeys:[NSArray arrayWithObjects:@"seconds", @"minutes", @"hours", @"days", nil]];
    
    return components;
}

-(IBAction)toggleAddressed:(UILongPressGestureRecognizer *)sender
{
    if(sender.state == UIGestureRecognizerStateBegan && [self.messageObject.messageType isEqualToString:MESSAGE_TYPE_1_NETWORK_NAME])
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
