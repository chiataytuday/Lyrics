//
//  WebViewController_iPad.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController_iPad : UIViewController <UIWebViewDelegate> {
    
    NSURL *url;
}

@property (nonatomic, strong) NSURL *url;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
