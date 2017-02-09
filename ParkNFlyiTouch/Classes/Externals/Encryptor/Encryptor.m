//
//  Encryptor.m
//  ParkNFly
//
//  Created by Bhavesh on 27/03/15.
//  Copyright (c) 2015 Cybage. All rights reserved.
//

#import "Encryptor.h"

@implementation Encryptor

+ (NSString *)encrypt:(NSString *)message
{
    
    NSError* error;
    
    NSData* enData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedData:&error];
    
//    NSLog(@"Encryption Error %@", error);
    
    NSString *enString = [NSString getBase64StringFromData:enData length:[enData length]];
    
    return enString;
    
}

+ (NSString *)decrypt:(NSString *)base64EncodedString
{
    NSData *enData = [NSData getBase64DataFromString:base64EncodedString];
    
    NSError* err;
    
    NSData *decryptedData = [enData decryptedAES256Data:&err];
    
//     NSLog(@"decryption Error %@", err);
    
    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

@end
