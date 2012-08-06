//
//  SettingsManager.h
//  Lyrics
//
//  Created by Daniel Cristolovean on 7/26/12.
//  Copyright (c) 2012 Daniel Cristolovean. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef LST
#define kOAuthConsumerKey @"O22hWB5dNKo5DI9VbPsIgg"
#define kOAuthConsumerSecret @"RMynSqY3OFN1fsuaEf6AM977jJJNQ6HSE77A8Z4kk"
#endif

#ifdef LRH
#define kOAuthConsumerKey @"ed3eT59xZbxTTpatdyAbfw"
#define kOAuthConsumerSecret @"G9XAjOxBlMCohWvyfBxJ61EjnMeDLCdlppyYeCnTwMU"
#endif

#ifdef LST
#define facebookAPI	@"262206833890576"
#endif

#ifdef LRH
#define facebookAPI	@"262206833890576"
#endif

#define AdWhirlAPI @"05c424ba45264acfb6625e9d982d4973"

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

- (void)setTextFontSize:(int)size;
- (int)getTextFontSize;

- (void)setVersion:(NSString *)version;
- (NSString *)getVersion;

+ (id)current;

@end
