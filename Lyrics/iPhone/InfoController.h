//
//  InfoController.h
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import "FacebookManager.h"

//@class SA_OAuthTwitterEngine;

@interface InfoController : UIViewController <FacebookManagerDelegateMSG, SA_OAuthTwitterControllerDelegate> {
 
    SA_OAuthTwitterEngine  *_engine;
}

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblFacebookUser;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTwitterUser;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *cmdFacebookLogin;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *cmdTwitterLogin;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblFb1;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblFb2;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTw2;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTw1;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblUrl;

- (IBAction)cmdFacebookLogin_TouchUpInside:(id)sender;
- (IBAction)cmdTwitterLogin_TouchUpInside:(id)sender;

@end
