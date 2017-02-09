//
//  Encryptor.h
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <Foundation/NSString.h>

@interface NSString (Base64Additions)

+ (NSString *)getBase64StringFromData:(NSData *)data length:(NSUInteger)length;

@end
