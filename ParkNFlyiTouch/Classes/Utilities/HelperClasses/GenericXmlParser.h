//
//  PNFXMLParser.h
//  ParkNFly
//
//  Created by Bhavesh on 10/11/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenericXmlParser : NSObject  <NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSString *textInProgress;
    NSDictionary* attributedDic;
}


+ (NSDictionary *)dictionaryForXMLString:(NSString *)string ;

+ (NSDictionary *)dictionaryParserXML:(NSXMLParser *)parser;
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data;

+(NSString*) getValue :(NSString*) key inDic:(NSDictionary*) dic;

+(NSString *)decodeHtmLEntities:(NSData *)htmlData;

+(NSString*) getAttributedValue :(NSString*) key inDic:(NSDictionary*) dic;


@end
