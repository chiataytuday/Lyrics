//
//  +NSString.m
//

#import "+NSString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

#pragma mark basic impl

+ (BOOL)isEmpty:(NSString *)value {
    return value == nil ||
           value == (id)[NSNull null] ||
           value == @"" ||
           ([value respondsToSelector:@selector(length)] && [(NSData *)value length] == 0) ||
           ([value respondsToSelector:@selector(count)] && [(NSArray *)value count] == 0);
}

+ (NSString *)stringWithUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidVal = (__bridge NSString *)CFUUIDCreateString(nil , uuidObj);    
    //NSLog (@"Device id generated -> %@" ,uuidVal);
    CFRelease(uuidObj);
    return uuidVal;    
}

+ (BOOL)IsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (NSString *)stringFromMD5 {
        if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

- (NSString *)capitalizedFirstLetter {
	NSString *first = [self substringToIndex:1];
	NSString *rest = [self substringFromIndex:1];
	first = [first uppercaseString];
	return [first stringByAppendingString:rest];
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions) options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *)string {
    return [self containsString:string options:0];
}

@end
