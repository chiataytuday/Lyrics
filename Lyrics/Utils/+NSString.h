//
//  +NSString.h
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

+ (BOOL)isEmpty:(NSString *)value;
+ (NSString *)stringWithUUID;
+ (BOOL)IsValidEmail:(NSString *)checkString;

- (NSString *)stringFromMD5;
- (NSString *)capitalizedFirstLetter;
- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions) options;

@end
