//
//  InfoController.m
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoController.h"
#import "SettingsManager.h"

@implementation InfoController

@synthesize lblFb1, lblFb2, lblTw2, lblTw1, lblUrl;
@synthesize lblFacebookUser, lblTwitterUser, cmdTwitterLogin, cmdFacebookLogin;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Info";
    }
    return self;
}

- (void)setFbLogin:(BOOL)isLoggedIn {
    
    lblFb1.hidden = !isLoggedIn;
    lblFb2.hidden = !isLoggedIn;
    
    if (!isLoggedIn) {
        lblFacebookUser.text = @"";
        [cmdFacebookLogin setImage:[UIImage imageNamed:@"login-facebook.png"] forState:UIControlStateNormal];
    } else {
        [cmdFacebookLogin setImage:[UIImage imageNamed:@"logout-facebook.png"] forState:UIControlStateNormal];
    }
}

- (void)setTwLogin:(BOOL)isLoggedIn {
    
    lblTw1.hidden = !isLoggedIn;
    lblTw2.hidden = !isLoggedIn;
    
    if (!isLoggedIn) {
        lblTwitterUser.text = @"";
        [cmdTwitterLogin setImage:[UIImage imageNamed:@"login-twitter.png"] forState:UIControlStateNormal];
    } else {
        [cmdTwitterLogin setImage:[UIImage imageNamed:@"logout-twitter.png"] forState:UIControlStateNormal];
    }
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {

    [FacebookManager current].delegate = self;
    
    if ([[FacebookManager current] userIsLoggedIn]) {
        NSMutableArray *fbInfo = [[FacebookManager current] getfbInfo];
        NSString *fbStr = [fbInfo objectAtIndex:0];
        if ([fbStr length] > 0) {
            lblFacebookUser.text = [NSString stringWithFormat:@"%@",[fbInfo  objectAtIndex:1]];
            [self setFbLogin:YES];
        }
    } else {
        [self setFbLogin:NO];
    }   
    
    if (!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;  
    }  	
    
    SettingsManager *sm = [SettingsManager current];
    
    if ([_engine isAuthorized])  {            
        [[SettingsManager current] loadFromNSUserDefaults:@"MSGSettings"];
        lblTwitterUser.text = [NSString stringWithFormat:@"%@",[sm getString:@"twitterName"]];
        [self setTwLogin:YES];
    } else {
        [self setTwLogin:NO];
        [sm setString:@"" keyString:@"twitterAuthData"];
        [sm setString:@"" keyString:@"twitterName"];
        [sm saveToNSUserDefaults:@"MSGSettings"];        
    }   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lblUrl.text = [[SettingsManager current] getFacebookURL];
    lblFb1.text = @"is connected to";
    lblTw1.text = @"is connected to";
}

- (void)viewDidUnload {
    [self setLblFacebookUser:nil];
    [self setLblTwitterUser:nil];
    [self setCmdFacebookLogin:nil];
    [self setCmdTwitterLogin:nil];
    [self setLblFb1:nil];
    [self setLblFb2:nil];
    [self setLblTw2:nil];
    [self setLblTw1:nil];
    [self setLblUrl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cmdFacebookLogin_TouchUpInside:(id)sender {
    if ([[FacebookManager current] userIsLoggedIn]) {
        [[FacebookManager current] facebookLogout];
    } else {
        [[FacebookManager current] facebookLogin];
    }
}

- (IBAction)cmdTwitterLogin_TouchUpInside:(id)sender {
    if (!_engine){  
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey = kOAuthConsumerKey;  
        _engine.consumerSecret = kOAuthConsumerSecret;  
    }  	
    
    if (![_engine isAuthorized]){  
        
        UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        if (controller){ 
            self.parentViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentModalViewController:controller animated:YES];  
        }  
    } else {
        SettingsManager *sm = [SettingsManager current];	
        [sm setString:@"" keyString:@"twitterAuthData"];
        [sm setString:@"" keyString:@"twitterName"];
        [sm saveToNSUserDefaults:@"MSGSettings"];
        
        [_engine clearAccessToken];
        
        [self setTwLogin:NO];
    }
}

- (void)fbLoaded:(NSString *)msg {
    
    if ([msg isEqualToString:@"logined"])
        return;
    
    if ([msg isEqualToString:@"fbDidLogin"]) {
        [[FacebookManager current] getfbName];
        NSMutableArray *fbInfo = [[FacebookManager current] getfbInfo];
        if (fbInfo.count > 1) {
            lblFacebookUser.text = [NSString stringWithFormat:@"%@",[fbInfo  objectAtIndex:1]];
            [self setFbLogin:YES];
        }
        return;        
    }
    
    if ([msg isEqualToString:@"fbDidLogout"]) {
        [self setFbLogin:NO];       
        return;        
    }
    
    if (msg != @"") {
        lblFacebookUser.text = msg;
        [self setFbLogin:YES];
    }
}

- (void)fbFailedWithError:(NSError *)error {
    
    NSString *errorDescription = [error localizedDescription];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Connect Fail" message:errorDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void)storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    SettingsManager *sm = [SettingsManager current];	
    [sm setString:data keyString:@"twitterAuthData"];
    [sm setString:username keyString:@"twitterName"];
    [sm saveToNSUserDefaults:@"MSGSettings"];
    
    lblTwitterUser.text = username;
    [self setTwLogin:YES];   
}

- (NSString *)cachedTwitterOAuthDataForUsername: (NSString *) username {
    SettingsManager *sm = [SettingsManager current];
	[[SettingsManager current] loadFromNSUserDefaults:@"MSGSettings"];   
	return [sm getString:@"twitterAuthData"];
}

#pragma mark TwitterEngineDelegate

- (void)requestSucceeded:(NSString *)requestIdentifier {
    NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
    NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}

@end
