//
//  WebViewController.m
//  TalkinToTheNet
//
//  Created by Daniel Distant on 10/2/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <UIWebViewDelegate, WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    self.navigationItem.title = @"Website";
    
    [self.webView loadRequest: [NSURLRequest requestWithURL:self.url]];
}

@end
