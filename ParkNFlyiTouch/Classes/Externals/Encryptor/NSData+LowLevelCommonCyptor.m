//
//  NSData+LowLevelCommonCyptor.m
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "NSData+LowLevelCommonCyptor.h"

@implementation NSData (LowLevelCommonCryptor)

- (NSData *) runCryptor: (CCCryptorRef) cryptor result: (CCCryptorStatus *) status
{
	size_t bufsize = CCCryptorGetOutputLength( cryptor, (size_t)[self length], true );
	void * buf = malloc( bufsize );
	size_t bufused = 0;
    size_t bytesTotal = 0;
	*status = CCCryptorUpdate( cryptor, [self bytes], (size_t)[self length],
                              buf, bufsize, &bufused );
	if ( *status != kCCSuccess )
	{
		free( buf );
		return ( nil );
	}
    
    bytesTotal += bufused;
	
	// From Brent Royal-Gordon (Twitter: architechies):
	//  Need to update buf ptr past used bytes when calling CCCryptorFinal()
	*status = CCCryptorFinal( cryptor, buf + bufused, bufsize - bufused, &bufused );
	if ( *status != kCCSuccess )
	{
		free( buf );
		return ( nil );
	}
    
    bytesTotal += bufused;
	
	return ( [NSData dataWithBytesNoCopy: buf length: bytesTotal] );
}


- (NSData *) dataEncryptedUsingAlgorithm: (CCAlgorithm) algorithm
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error
{
	CCCryptorRef cryptor = NULL;
	CCCryptorStatus status = kCCSuccess;
		
    const char myKey[] = {
        166,31,166,123,
        40,137,250,192,
        140,198,45,243,
        254,118,252,101,
        238,194,75,238,
        216,110,20,65,
        221,115,37,97,
        228,9,226,24
    };
    
    const char myIV[] = {
        27,176,241,166,
        91,187,172,156,
        90,25,51,114,
        42,160,31,67
    };
    
	status = CCCryptorCreate(kCCEncrypt,
                             algorithm,
                             options,
                             myKey,
                             32,
                             myIV,
                             &cryptor );
	
	if ( status != kCCSuccess )
	{
		if ( error != NULL )
			*error = status;
		return ( nil );
	}
	
	NSData * result = [self runCryptor: cryptor result: &status];
	if ( (result == nil) && (error != NULL) )
		*error = status;
	
	CCCryptorRelease( cryptor );
	
	return ( result );
}


- (NSData *) decryptedDataUsingAlgorithm: (CCAlgorithm) algorithm
                                 options: (CCOptions) options
                                   error: (CCCryptorStatus *) error
{
	CCCryptorRef cryptor = NULL;
	CCCryptorStatus status = kCCSuccess;
	
    const char myKey[] = {
                            166,31,166,123,
                            40,137,250,192,
                            140,198,45,243,
                            254,118,252,101,
                            238,194,75,238,
                            216,110,20,65,
                            221,115,37,97,
                            228,9,226,24
    };
    
    const char myIV[] = {
                            27,176,241,166,
                            91,187,172,156,
                            90,25,51,114,
                            42,160,31,67
    };
    
	status = CCCryptorCreate( kCCDecrypt,
                             algorithm,
                             options,
                             myKey,
                             32,
                             myIV,
                             &cryptor );
	
	if ( status != kCCSuccess )
	{
		if ( error != NULL )
			*error = status;
		return ( nil );
	}
	
	NSData * result = [self runCryptor: cryptor result: &status];
	if ( (result == nil) && (error != NULL) )
		*error = status;
	
	CCCryptorRelease( cryptor );
	
	return ( result );
}


@end

