//
//  NSData+LowLevelCommonCyptor.h
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>

@interface NSData (LowLevelCommonCryptor)

- (NSData *) dataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;



- (NSData *) decryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error;

@end
