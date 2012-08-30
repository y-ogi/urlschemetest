//
//  FTViewController.m
//  URLSchemeTest
//
//  Created by Yuta OGIHARA on 12/08/22.
//  Copyright (c) 2012年 Yuta OGIHARA. All rights reserved.
//

#import "FTViewController.h"
#import "FTURLOpener.h"

@interface FTViewController ()

@end

@implementation FTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load the html
    NSString *html =
    @"<html><body>"
    "<ul>"
    "   <li><a href=\"skype:\">Skype</a></li>"
    "   <li><a href=\"connectpro://[adobe connect url]\">Adobe Connect</a></li>"
    "</ul>"
    "</body></html>";
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Open Application

#define SKYPE_APPNAME @"skype"
#define SKYPE_URLSCHEME @"skype"
#define ADOBE_CONNECT_APPNAME @"adobeconnectmobileforios"
#define ADOBE_CONNECT_URLSCHEME @"connectpro"

- (BOOL)isAppURLSchemeWithURL:(NSURL *)url {
    NSString *scheme = url.scheme;
    return [SKYPE_URLSCHEME isEqualToString:scheme] || [ADOBE_CONNECT_URLSCHEME isEqualToString:scheme];
}

- (void)openAppOrStoreWithURL: (NSURL *)url {
    
    NSURL *target = nil;
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        target = [url copy];
    } else {
        if ([ADOBE_CONNECT_URLSCHEME isEqualToString:url.scheme]) {
            target = [NSURL URLWithString:@"itms-apps://itunes.com/apps/adobeconnectmobileforios"];
        }
        if ([SKYPE_URLSCHEME isEqualToString:url.scheme]) {
            target = [NSURL URLWithString:@"itms-apps://itunes.com/apps/skype"];
        }
    }
    [[UIApplication sharedApplication] openURL:target];
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    BOOL canOpenURL = [[UIApplication sharedApplication] canOpenURL:request.URL];
    NSLog(@"URL       :%@", request.URL);
    NSLog(@"URL Scheme:%@", request.URL.scheme);
    NSLog(@"Can Open  :%@", canOpenURL? @"YES": @"NO");
    
    if ([[FTURLOpener sharedInstance] isAppURL:request.URL]) {
        [[FTURLOpener sharedInstance] openURL:request.URL completion:^{
            NSLog(@"Finish Finish Finish");
        }];
        return NO;
    }
   
    return YES;
}

@end
