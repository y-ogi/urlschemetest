//
//  FTURLOpener.m
//  URLSchemeTest
//
//  Created by Yuta OGIHARA on 12/08/30.
//  Copyright (c) 2012年 Yuta OGIHARA. All rights reserved.
//

#import "FTURLOpener.h"
@interface FTURLOpener()

- (id)init;
- (void)loadURL:(NSURL *)url completion:(FTOpenURLCompletion)completion;

@property (nonatomic, copy) FTOpenURLCompletion completion;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation FTURLOpener

@synthesize webView = _webView;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

+ (FTURLOpener *)sharedInstance
{
    static FTURLOpener* _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FTURLOpener alloc] init];
    });
    return _sharedInstance;
}


#pragma mark - Public Method
- (void)openURL:(NSURL *)url {
    [self openURL:url completion:nil];
}

- (void)openURL:(NSURL *)url completion:(FTOpenURLCompletion)completion {

    NSURL *target = nil;
    if ([self canOpenURL:url]) {
        target = [url copy];
    } else {
        if ([ADOBE_CONNECT_URLSCHEME isEqualToString:url.scheme]) {
            target = [NSURL URLWithString:@"itms-apps://itunes.com/apps/adobeconnectmobileforios"];
        }
        if ([SKYPE_URLSCHEME isEqualToString:url.scheme]) {
            target = [NSURL URLWithString:@"itms-apps://itunes.com/apps/skype"];
        }
    }
    
    if ([ADOBE_CONNECT_URLSCHEME isEqualToString:target.scheme]) {
        [self loadURL:target completion:completion];
    } else {
        [[UIApplication sharedApplication] openURL:target];
        if (completion) {
            completion();
        }
    }
}


- (BOOL)canOpenURL:(NSURL *)url {
    return [[UIApplication sharedApplication] canOpenURL:url];
}

- (BOOL)isAppURL:(NSURL *)url {
    NSString *scheme = url.scheme;
    return [SKYPE_URLSCHEME isEqualToString:scheme] || [ADOBE_CONNECT_URLSCHEME isEqualToString:scheme];
}

#pragma mark - Private Method
- (void)loadURL:(NSURL *)url completion:(FTOpenURLCompletion)completion {
    NSURL *target = [NSURL URLWithString:[[url description] stringByReplacingOccurrencesOfString:url.scheme withString:@"http"]];
    NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:target];
    
    _webView = [[UIWebView alloc] init];
    _webView.delegate = self;
    _completion = completion;
    
    [_webView loadRequest:request];
}

#pragma mark - UIWebView Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"URL:%@", request.URL);
    if (![@"http" isEqualToString:request.URL.scheme] && ![@"https" isEqualToString:request.URL.scheme]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        _completion();
        return NO;
    }
    return YES;
}

@end
