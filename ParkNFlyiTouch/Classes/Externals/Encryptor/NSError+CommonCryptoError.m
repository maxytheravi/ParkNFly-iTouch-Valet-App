//
//  NSError+CommonCryptoError.m
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "NSError+CommonCryptoError.h"

NSString * const kCommonCryptoErrorDomain = @"CommonCryptoErrorDomain";

@implementation NSError (CommonCryptoErrorDomain)

+ (NSError *) errorWithCCCryptorStatus: (CCCryptorStatus) status
{
	NSString * description = nil, * reason = nil;
	
	switch ( status )
	{
		case kCCSuccess:
			description = NSLocalizedString(@"Success", @"Error description");
			break;
			
		case kCCParamError:
			description = NSLocalizedString(@"Parameter Error", @"Error description");
			reason = NSLocalizedString(@"Illegal parameter supplied to encryption/decryption algorithm", @"Error reason");
			break;
			
		case kCCBufferTooSmall:
			description = NSLocalizedString(@"Buffer Too Small", @"Error description");
			reason = NSLocalizedString(@"Insufficient buffer provided for specified operation", @"Error reason");
			break;
			
		case kCCMemoryFailure:
			description = NSLocalizedString(@"Memory Failure", @"Error description");
			reason = NSLocalizedString(@"Failed to allocate memory", @"Error reason");
			break;
			
		case kCCAlignmentError:
			description = NSLocalizedString(@"Alignment Error", @"Error description");
			reason = NSLocalizedString(@"Input size to encryption algorithm was not aligned correctly", @"Error reason");
			break;
			
		case kCCDecodeError:
			description = NSLocalizedString(@"Decode Error", @"Error description");
			reason = NSLocalizedString(@"Input data did not decode or decrypt correctly", @"Error reason");
			break;
			
		case kCCUnimplemented:
			description = NSLocalizedString(@"Unimplemented Function", @"Error description");
			reason = NSLocalizedString(@"Function not implemented for the current algorithm", @"Error reason");
			break;
			
		default:
			description = NSLocalizedString(@"Unknown Error", @"Error description");
			break;
	}
	
	NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
	[userInfo setObject: description forKey: NSLocalizedDescriptionKey];
	
	if ( reason != nil )
		[userInfo setObject: reason forKey: NSLocalizedFailureReasonErrorKey];
	
	NSError * result = [NSError errorWithDomain: kCommonCryptoErrorDomain code: status userInfo: userInfo];
 	
	return ( result );
}

@end

