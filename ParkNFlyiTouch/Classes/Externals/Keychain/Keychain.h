//
// Keychain.h
//
//

#import <Foundation/Foundation.h>

@interface Keychain : NSObject {
}

+ (void)saveString:(NSString *)inputString forKey:(NSString	*)account;

+ (NSString *)getStringForKey:(NSString *)account;

+ (void)deleteStringForKey:(NSString *)account;

@end