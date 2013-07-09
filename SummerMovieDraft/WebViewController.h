//
//  WebViewController.h
//  SummerMovieDraft
//
//  Created by Chris Tot on 6/19/13.
//  Copyright (c) 2013 christurnage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webViewIMDB;

@property (strong, nonatomic) NSString *urlAddress;
@property (strong, nonatomic) NSString *storedMovieTitle;

@end
