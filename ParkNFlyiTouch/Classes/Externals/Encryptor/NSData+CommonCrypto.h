//
//  Encryptor.h
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <Foundation/NSData.h>
#import <Foundation/NSError.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSError+CommonCryptoError.h"
#import "NSData+LowLevelCommonCyptor.h"
#import "NSData+CommonCrypto.h"
#import "NSData+LowLevelCommonCyptor.h"
#import "NSData+Base64.h"
#import "NSData+CommonDigest.h"

@interface NSData (CommonCryptor)

- (NSData *) AES256EncryptedData:  (NSError **) error;

- (NSData *) decryptedAES256Data: (NSError **) error;


@end

