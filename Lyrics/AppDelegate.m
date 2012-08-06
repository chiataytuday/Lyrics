//
//  AppDelegate.m
//  Lyrics
//
//  Created by Daniel Cristolovean on 7/26/12.
//  Copyright (c) 2012 Daniel Cristolovean. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthorsController.h"
#import "StorageManager.h"
#import "AuthorsController_iPad.h"
#import "PoemsListController_iPad.h"

#define RRFONTFUTURAMEDIUM18        [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20]
#define TEXTCOLOR  [UIColor colorWithRed:142.0f / 255.0f green:105.0f / 255.0f blue:40.0f / 255.0f alpha:1.0f]

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    NSDictionary *textAttr = [NSDictionary dictionaryWithObjectsAndKeys:RRFONTFUTURAMEDIUM18, UITextAttributeFont, [UIColor whiteColor], UITextAttributeTextColor, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:textAttr];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [[StorageManager current] getStuff];
        
        AuthorsController *authors = [[AuthorsController alloc] init];
        UINavigationController *navAuthors = [[UINavigationController alloc] initWithRootViewController:authors];
        self.window.rootViewController = navAuthors;
        
    } else {
        AuthorsController_iPad *mainView = [[AuthorsController_iPad alloc] init];
        UINavigationController *navAuthors = [[UINavigationController alloc] initWithRootViewController:mainView];
        
        PoemsListController_iPad *poems = [[PoemsListController_iPad alloc] init];
        UINavigationController *navPoems = [[UINavigationController alloc] initWithRootViewController:poems];        
        
        self.splitController = [[UISplitViewController alloc] init];
        
        self.splitController.viewControllers = [NSArray arrayWithObjects:navAuthors, navPoems, nil];
        self.splitController.delegate = poems;
        
        self.window.rootViewController = self.splitController;
    }
    
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Saves changes in the application's managed object context before the application terminates.
}

- (BOOL)openURL:(NSURL *)url {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openURL" object:url];
    return YES;
}

@end
