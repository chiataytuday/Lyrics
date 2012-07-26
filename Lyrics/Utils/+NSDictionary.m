//
//  +NSDictionary.m
//

#import "+NSDictionary.h"

@implementation NSDictionary (Additions)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data {
	
	CFPropertyListRef plist = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data, kCFPropertyListImmutable, NULL);
	[((NSDictionary*)plist) autorelease];
	
	if ([(id)plist isKindOfClass:[NSDictionary class]]) {
		return (NSDictionary*)plist;
	} else {
		return nil;
	}

}

@end
