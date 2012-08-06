//
//  SettingsManager.m
//  Lyrics
//
//  Created by Daniel Cristolovean on 7/26/12.
//  Copyright (c) 2012 Daniel Cristolovean. All rights reserved.
//

#import "SettingsManager.h"

static SettingsManager *current = nil;

@implementation SettingsManager

- (void)purgeSettings {
	[settings removeAllObjects];
}

- (void)saveToNSUserDefaults:(NSString *)appName {
    if (settings == nil)
		settings = [[NSMutableDictionary alloc] initWithCapacity:5];
	[[NSUserDefaults standardUserDefaults] setObject:settings forKey:appName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadFromNSUserDefaults:(NSString *)appName {
    if (settings == nil)
		settings = [[NSMutableDictionary alloc] initWithCapacity:5];
	[self purgeSettings];
	[settings addEntriesFromDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:appName]];
}

- (NSString *)getString:(NSString*)keyString {
	return [settings objectForKey:keyString];
}

- (int)getInt:(NSString*)keyString {
	return [[settings objectForKey:keyString] intValue];
}

- (float)getFloat:(NSString*)keyString {
	return [[settings objectForKey:keyString] floatValue];
}

- (double)getDouble:(NSString*)keyString {
	return [[settings objectForKey:keyString] doubleValue];
}

- (bool)getBool:(NSString*)keyString {
	return [[settings objectForKey:keyString] boolValue];
}

- (void)setString:(NSString*)value keyString:(NSString *)keyString {
	[settings setObject:value forKey:keyString];
}

- (void)setInteger:(int)value keyString:(NSString*)keyString {
	[settings setObject:[NSString stringWithFormat:@"%d",value] forKey:keyString];
}

- (void)setFloat:(float)value keyString:(NSString*)keyString {
	[settings setObject:[NSString stringWithFormat:@"%f",value] forKey:keyString];
}

- (void)setDouble:(double)value keyString:(NSString*)keyString {
	[settings setObject:[NSString stringWithFormat:@"%f",value] forKey:keyString];
}

- (void)setBool:(bool)value keyString:(NSString*)keyString {
	[settings setObject:[NSString stringWithFormat:@"%d",value] forKey:keyString];
}

- (void)setTextFontSize:(int)size {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:[NSString stringWithFormat:@"%d", size] forKey:@"FontSize"];
}

- (int)getTextFontSize {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [[preferences stringForKey:@"FontSize"] intValue];
}

- (void)setVersion:(NSString *)version {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setValue:version forKey:@"Version"];
}

- (NSString *)getVersion {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences stringForKey:@"Version"];
}

#pragma mark - Sharing

- (NSString *)getFacebookURL {
    
#ifdef LST
    return @"http://www.facebook.com/lyrics.stm";
#endif
    
#ifdef LRH
    return @"http://www.facebook.com/lyrics.rhr";
#endif
    
    return @"";
}

- (NSString *)getFacebookImageURL {
    
#ifdef LST
    return @"http://rockabilly.ro/img/poezii-romanesti/launch-icon-114.png";
#endif

#ifdef LRH
    return @"http://rockabilly.ro/img/poezii-romanesti/launch-icon-114.png";
#endif
    
    return @"";
}

- (NSString *)getFacebookName {
    
#ifdef LST
    return @"Lyrics - Speed & Thrash Metal";
#endif
    
#ifdef LRH
    return @"Lyrics - Rock & Hard Rock";
#endif
    
    return @"";
}

- (NSString *)getTwitterTitle {
    
#ifdef LST
    return @"From Lyrics - Speed & Thrash Metal:";
#endif
    
#ifdef LRH
    return @"From Lyrics - Rock & Hard Rock";
#endif
    
    return @"";
    
}

#pragma mark - Singleton

+ (id)current {
	@synchronized(self) {
		if (current == nil)
			current = [[super allocWithZone:NULL] init];
	}
	return current;
}

@end
