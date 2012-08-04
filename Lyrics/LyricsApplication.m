//
//  LyricsApplication.m
//  Lyrics
//
//  Created by Daniel Cristolovean on 7/26/12.
//  Copyright (c) 2012 Daniel Cristolovean. All rights reserved.
//

#import "LyricsApplication.h"
#import "AppDelegate.h"

@implementation LyricsApplication

- (BOOL)openURL:(NSURL *)url {
    
    NSString *searchTerm = @"www.facebook.com";
    NSRange range = [[url absoluteString] rangeOfString:searchTerm];
    
    if (range.location != NSNotFound)
        return [super openURL:url];
    
    if ([(AppDelegate *)self.delegate openURL:url])
        return YES;
    else {
        return [super openURL:url];
    }
}

@end
