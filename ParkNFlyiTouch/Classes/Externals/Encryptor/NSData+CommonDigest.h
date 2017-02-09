//
//  NSData+CommonDigest.h
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (CommonDigest)

- (NSData *) SHA256Hash;

@end
