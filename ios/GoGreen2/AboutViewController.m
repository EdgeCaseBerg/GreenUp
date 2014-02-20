//
//  AboutViewController.m
//  GoGreen
//
//  Created by Jordan Rouille on 2/20/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        if([UIScreen mainScreen].bounds.size.height == 568.0)
        {
            if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
            {
                [self.view setFrame:CGRectMake(0, 20, 320, 548)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 20, 320, 568)];
            }
        }
        else
        {
            if([[UIDevice currentDevice] systemVersion].integerValue >= 7.0)
            {
                [self.view setFrame:CGRectMake(0, 20, 320, 460)];
            }
            else
            {
                [self.view setFrame:CGRectMake(0, 20, 320, 480)];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //FOR HTML [[VERSION_BUILD]]
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [webView setUserInteractionEnabled:FALSE];
    [webView setBackgroundColor:[UIColor blackColor]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"http:www.google.com" ofType:@"html"];
    
    //-- Set up the web view with some content
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    NSMutableString *htmlString = [[NSMutableString alloc] initWithData:
                                   [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    NSURL	 *baseURL  = [NSURL fileURLWithPath:basePath];
    [webView loadHTMLString:htmlString baseURL:baseURL];
    
    NSString *buildNumber = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    [htmlString replaceOccurrencesOfString:@"[[VERSION_BUILD]]"
                                withString:buildNumber
                                   options:NSLiteralSearch
                                     range:NSMakeRange(0, [htmlString length])];
    
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
