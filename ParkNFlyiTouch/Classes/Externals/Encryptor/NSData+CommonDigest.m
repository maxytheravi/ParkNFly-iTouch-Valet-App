//
//  NSData+CommonDigest.m
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "NSData+CommonDigest.h"

@implementation NSData (CommonDigest)

- (NSData *) SHA256Hash
{
	unsigned char hash[CC_SHA256_DIGEST_LENGTH];
    
	(void) CC_SHA256( [self bytes], (CC_LONG)[self length], hash );
    
	return ( [NSData dataWithBytes: hash length: CC_SHA256_DIGEST_LENGTH] );
    
}


@end
