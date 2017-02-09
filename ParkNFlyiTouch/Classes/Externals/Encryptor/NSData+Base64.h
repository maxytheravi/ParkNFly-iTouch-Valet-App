//
//  Encryptor.h
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64Additions)

+ (NSData *)getBase64DataFromString:(NSString *)string;

@end