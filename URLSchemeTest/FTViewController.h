//
//  FTViewController.h
//  URLSchemeTest
//
//  Created by Yuta OGIHARA on 12/08/22.
//  Copyright (c) 2012年 Yuta OGIHARA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTViewController : UIViewController <UIWebViewDelegate>

// IBOutlet
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end
