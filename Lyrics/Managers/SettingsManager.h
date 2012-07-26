//
//  SettingsManager.h
//  Lyrics
//
//  Created by Daniel Cristolovean on 7/26/12.
//  Copyright (c) 2012 Daniel Cristolovean. All rights reserved.
//

#import <Foundation/Foundation.h>

//#ifdef RO
//#define kOAuthConsumerKey @"ELQfngrNIj0a06JepctsIQ"
//#define kOAuthConsumerSecret @"fHA25Oidkb5PwZ7FpKJrtcCnilrVqaxkolgc7d1nEg"
//#endif

//#ifdef RO
//#define facebookAPI	@"150201851764819"
//#endif

@interface SettingsManager : NSObject {
    NSMutableDictionary* settings;
}

- (void)saveToNSUserDefaults:(NSString*)appName;
- (void)loadFromNSUserDefaults:(NSString*)appName;

- (NSString *)getString:(NSString*)keyString;
- (int)getInt:(NSString*)keyString;
- (float)getFloat:(NSString*)keyString;
- (double)getDouble:(NSString*)keyString;
- (bool)getBool:(NSString*)keyString;

- (void)setString:(NSString*)value keyString:(NSString *)keyString;
- (void)setInteger:(int)value keyString:(NSString*)keyString;
- (void)setFloat:(float)value keyString:(NSString*)keyString;
- (void)setDouble:(double)value keyString:(NSString*)keyString;
- (void)setBool:(bool)value keyString:(NSString*)keyString;

- (NSString *)getFacebookURL;
- (NSString *)getFacebookImageURL;
- (NSString *)getFacebookName;
- (NSString *)getTwitterTitle;
- (NSString *)getAuthorsTitle;
- (NSString *)getInformationsTitle;
- (NSString *)getFavoritesTitle;
- (NSString *)getCommentsTitle;

- (void)setTextFontSize:(int)size;
- (int)getTextFontSize;

- (void)setVersion:(NSString *)version;
- (NSString *)getVersion;

+ (id)current;

@end
