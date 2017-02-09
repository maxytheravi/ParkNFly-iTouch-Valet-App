//
//  Encryptor.h
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "NSData+CommonCrypto.h"


@implementation NSData (CommonCryptor)

- (NSData *) AES256EncryptedData: (NSError **) error
{
	CCCryptorStatus status = kCCSuccess;
    
	NSData * result = [self dataEncryptedUsingAlgorithm: kCCAlgorithmAES128
                                                options: kCCOptionPKCS7Padding
                                                error: &status];
	
	if ( result != nil )
		return ( result );
	
	if ( error != NULL )
		*error = [NSError errorWithCCCryptorStatus: status];
	
	return ( nil );
}


- (NSData *) decryptedAES256Data: (NSError **) error
{
    CCCryptorStatus status = kCCSuccess;
    
    NSData * result = [self decryptedDataUsingAlgorithm: kCCAlgorithmAES128
                                                options: kCCOptionPKCS7Padding
                                                  error: &status];
    if ( result != nil )
        return ( result );
    
    if ( error != NULL )
        *error = [NSError errorWithCCCryptorStatus: status];
    
    return ( nil );
}

@end


