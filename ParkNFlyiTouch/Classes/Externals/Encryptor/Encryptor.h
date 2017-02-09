//
//  Encryptor.h
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+CommonCrypto.h"
#import "NSString+Base64.h"

@interface Encryptor : NSObject

+ (NSString *)encrypt:(NSString *)message;

+ (NSString *)decrypt:(NSString *)base64EncodedString;

@end
