//
//  WebViewController.m
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/19/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize urlAddress, storedMovieTitle, webViewIMDB;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = storedMovieTitle;
    
    //Create a URL object
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Request Object
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [webViewIMDB loadRequest:requestURL];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[MBProgressHUD showHUDAddedTo:webViewIMDB animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[MBProgressHUD hideHUDForView:webViewIMDB animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[MBProgressHUD hideHUDForView:webViewIMDB animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
