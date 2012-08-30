//
//  FTURLOpener.h
//  URLSchemeTest
//
//  Created by Yuta OGIHARA on 12/08/30.
//  Copyright (c) 2012年 Yuta OGIHARA. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SKYPE_APPNAME @"skype"
#define SKYPE_URLSCHEME @"skype"
#define ADOBE_CONNECT_APPNAME @"adobeconnectmobileforios"
#define ADOBE_CONNECT_URLSCHEME @"connectpro"

typedef void (^FTOpenURLCompletion)(void);

@interface FTURLOpener : NSObject <UIWebViewDelegate>

+ (FTURLOpener *)sharedInstance;
- (void)openURL:(NSURL *)url;
- (void)openURL:(NSURL *)url completion:(FTOpenURLCompletion)completion;
- (BOOL)isAppURL:(NSURL *)url;
- (BOOL)canOpenURL:(NSURL *)url;

@end
