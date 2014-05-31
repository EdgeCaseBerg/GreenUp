//
//  AboutViewController.m
//  GoGreen
//
//  Created by Jordan Rouille on 2/20/14.
//  Copyright (c) 2014 Xenon Apps. All rights reserved.
//

#import "AboutViewController.h"
#import "ThemeHeader.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNavRef:(UINavigationController *)nav
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.navigationController = nav;
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
                [self.view setFrame:CGRectMake(0, 0, 320, 400)];
            }
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:FALSE];
    
    int adjustment = 0;
    if([[UIDevice currentDevice] systemVersion].integerValue < 7.0)
    {
        adjustment = 44;
    }
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height - adjustment)];
    [webView setDelegate:self];
    //[webView setUserInteractionEnabled:FALSE];
    [webView setBackgroundColor:[UIColor blackColor]];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"aboutUs" ofType:@"html"];
    
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

#pragma mark - UIWebViewDelegate
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}
@end
