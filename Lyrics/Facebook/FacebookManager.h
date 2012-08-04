//
//  FacebookManager.h
//  MSG Varsity
//
//  Created by Bei Cao on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBConnect.h"

@interface FacebookManager : NSObject <FBRequestDelegateMSG,FBDialogDelegateMSG,FBSessionDelegateMSG> {
    
    id delegate;
    FacebookMSG* facebook1;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) FacebookMSG *facebook1;

+ (FacebookManager *)current;
- (void)facebookLogin;
- (void)facebookLogout;
- (NSMutableArray*)getfbInfo;
- (void)getfbName;
- (void)publishStream:(NSMutableDictionary*) params;
- (BOOL)userIsLoggedIn;

@end

@protocol FacebookManagerDelegateMSG @optional

- (void)fbLoaded:(NSString *)msg;
- (void)fbFailedWithError:(NSError *)error;

@end
