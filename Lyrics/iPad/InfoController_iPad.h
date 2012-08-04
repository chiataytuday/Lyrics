//
//  InfoController_iPad.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import "FacebookManager.h"

@interface InfoController_iPad : UIViewController <FacebookManagerDelegateMSG, SA_OAuthTwitterControllerDelegate> {
    
    NSMutableArray* twitterInfor;
    SA_OAuthTwitterEngine  *_engine;
}


@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UILabel *lblFacebookUser;
@property (strong, nonatomic) IBOutlet UILabel *lblTwitterUser;
@property (strong, nonatomic) IBOutlet UIButton *cmdFacebookLogin;
@property (strong, nonatomic) IBOutlet UIButton *cmdTwitterLogin;
@property (strong, nonatomic) IBOutlet UITextView *lblUrl;
@property (strong, nonatomic) IBOutlet UILabel *lblFb1;
@property (strong, nonatomic) IBOutlet UILabel *lblFb2;
@property (strong, nonatomic) IBOutlet UILabel *lblTw1;
@property (strong, nonatomic) IBOutlet UILabel *lblTw2;

- (IBAction)cmdFacebookLogin_TouchUpInside:(id)sender;
- (IBAction)cmdTwitterLogin_TouchUpInside:(id)sender;

@end
