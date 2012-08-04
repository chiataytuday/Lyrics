//
//  WebViewController.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {

    NSURL *url;
}

@property (nonatomic, strong) NSURL *url;
@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *webView;
@property (unsafe_unretained, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
