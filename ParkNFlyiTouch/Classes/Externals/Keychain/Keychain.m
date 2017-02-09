//
// Keychain.h
//

#import "Keychain.h"
#import <Security/Security.h>

@implementation Keychain

+ (void)saveString:(NSString *)inputString forKey:(NSString	*)account {
	NSAssert(account != nil, @"Invalid account");
	NSAssert(inputString != nil, @"Invalid string");
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:account forKey:(__bridge id)kSecAttrAccount];
	[query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
	
	OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, NULL);
	if (error == errSecSuccess) {
		// do update
		NSDictionary *attributesToUpdate = [NSDictionary dictionaryWithObject:[inputString dataUsingEncoding:NSUTF8StringEncoding] 
																	  forKey:(__bridge id)kSecValueData];
        
		SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributesToUpdate);
	} else if (error == errSecItemNotFound) {
		// do add
		[query setObject:[inputString dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
		SecItemAdd((__bridge CFDictionaryRef)query, NULL);
	} else {
		//NSAssert1(NO, @"SecItemCopyMatching failed: %d", error);
	}
}

+ (NSString *)getStringForKey:(NSString *)account {
	NSAssert(account != nil, @"Invalid account");
	
	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:account forKey:(__bridge id)kSecAttrAccount];
	[query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];

	CFTypeRef *dataFromKeychain = nil;
	OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef) query, (CFTypeRef *)&dataFromKeychain);
	
	NSString *stringToReturn = nil;
	if (error == errSecSuccess) {
        NSData *resultNSData = (__bridge NSData *)(CFDataRef)dataFromKeychain;
		stringToReturn = [[NSString alloc] initWithData:resultNSData encoding:NSUTF8StringEncoding];
	}
	return stringToReturn;
}

+ (void)deleteStringForKey:(NSString *)account {
	NSAssert(account != nil, @"Invalid account");

	NSMutableDictionary *query = [NSMutableDictionary dictionary];
	
	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:account forKey:(__bridge id)kSecAttrAccount];
		
	OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
	if (status != errSecSuccess) {
		//DLog(@"SecItemDelete failed: %d", status);
	}
}



@end