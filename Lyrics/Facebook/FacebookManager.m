//
//  FacebookManager.m
//  MSG Varsity
//
//  Created by Bei Cao on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacebookManager.h"
#import "SettingsManager.h"

@implementation FacebookManager

@synthesize facebook1, delegate;

static FacebookManager *current = nil;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {   
    return [facebook1 handleOpenURL:url]; 
}

- (NSMutableArray *)getfbInfo {    
    SettingsManager *sm = [SettingsManager current];
	[[SettingsManager current] loadFromNSUserDefaults:@"MSGSettings"];
    NSString *FBAccessTokenKey = [sm getString:@"FBAccessTokenKey"];
    NSString *FBName = [sm getString:@"FBName"];
    NSMutableArray *fbInfo = [[NSMutableArray alloc] initWithObjects:FBAccessTokenKey,FBName, nil]; 
    return fbInfo;
}

- (BOOL)userIsLoggedIn {
    
    if (facebook1 == nil)
        self.facebook1 = [[FacebookMSG alloc] initWithAppId:facebookAPI];
    
    NSMutableArray *fbInfo = [self getfbInfo]; 
    if (fbInfo.count > 0) {
        NSString *fbStr = [fbInfo objectAtIndex:0];
        if (fbStr.length > 0) {
            return YES;                                      
        }
    }
    
    return NO;
}

- (void)facebookLogin {  
    
    if (facebook1 == nil)
        self.facebook1 = [[FacebookMSG alloc] initWithAppId:facebookAPI];
    
    NSMutableArray * fbInfo = [self getfbInfo]; 
    if (fbInfo.count > 1) {
        NSString *fbStr = [fbInfo objectAtIndex:0];
       if (fbStr.length > 0) {
          if ([[self delegate] respondsToSelector:@selector(fbLoaded:)]) {
             [[self delegate] fbLoaded:@"logined"];            
             [fbInfo release];
             fbInfo = nil;
             return;
          }          
       }
    }
   
    [fbInfo release];
    fbInfo = nil;

    NSArray* permissions = [[NSArray arrayWithObjects:@"publish_stream", @"offline_access", nil] retain];
    [facebook1 authorize:permissions delegate:self appAuth:NO safariAuth:NO];
    [permissions release];
}

- (void)fbDidLogout {
    SettingsManager *sm = [SettingsManager current];	
    [sm setString:@"" keyString:@"FBAccessTokenKey"];
    [sm setString:@"" keyString:@"FBName"];
  	[sm saveToNSUserDefaults:@"MSGSettings"];
    
    if ([[self delegate] respondsToSelector:@selector(fbLoaded:)]) {
        [[self delegate] fbLoaded:@"fbDidLogout"];
    }
}

- (void)fbDidLogin {    
    SettingsManager *sm = [SettingsManager current];	
    [sm setString:facebook1.accessToken keyString:@"FBAccessTokenKey"];
	[sm saveToNSUserDefaults:@"MSGSettings"];
    
    if ([[self delegate] respondsToSelector:@selector(fbLoaded:)]) {
        [[self delegate] fbLoaded:@"fbDidLogin"];
    }
}

- (void)getfbName {     
    [facebook1 requestWithGraphPath:@"me" andDelegate:self];
}

- (void)facebookLogout {      
    [facebook1 logout:self];    
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    // NSLog(@"did not login");
}
/**
 * Open an inline dialog that allows the logged in user to publish a story to his or
 * her wall.
 */
- (void)publishStream:(NSMutableDictionary *)params {
   [facebook1 dialog:@"feed" andParams:params andDelegate:self];
   // NSLog(@"%@", params);
}

////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequestMSG *)request didReceiveResponse:(NSURLResponse *)response {
   // NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequestMSG *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
   
    SettingsManager *sm = [SettingsManager current];	
    [sm setString:[result objectForKey:@"name"] keyString:@"FBName"];
    [sm saveToNSUserDefaults:@"MSGSettings"];
    if ([[self delegate] respondsToSelector:@selector(fbLoaded:)]) {
        [[self delegate] fbLoaded:[result objectForKey:@"name"]];
    }
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequestMSG *)request didFailWithError:(NSError *)error {
   // [self.label setText:[error localizedDescription]];
    if ([[self delegate] respondsToSelector:@selector(fbFailedWithError:)]) {
        [[self delegate] fbFailedWithError:error];
    }
};


////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialogMSG *)dialog {
    //[self.label setText:@"publish successfully"];
   
}


/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialogMSG*)dialog didFailWithError:(NSError *)error {
    if([[self delegate] respondsToSelector:@selector(fbFailedWithError:)]) {
        [[self delegate] fbFailedWithError:error];
    }
}

//singleton

#pragma mark - Singleton

+ (id)current {
	@synchronized(self) {
		if (current == nil)
			current = [[super allocWithZone:NULL] init];                
	}
	return current;
}

@end



