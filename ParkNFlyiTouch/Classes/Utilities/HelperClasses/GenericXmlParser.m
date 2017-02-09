//
//  PNFXMLParser.m
//  ParkNFly
//
//  Created by Bhavesh on 10/11/14.
//  Copyright (c) 2014 Cybage. All rights reserved.
//

#import "GenericXmlParser.h"
//#import "NSString+Extras.h"

#define innerText @"innerText"
#define attributedData @"attributedData"

@implementation GenericXmlParser

+(NSString *)decodeHtmLEntities:(NSData *)htmlData
{
    NSString *string = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
//    string = [string stringByDecodingHTMLEntities];
    
//    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
//    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
//    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    return string;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    GenericXmlParser *reader = [[GenericXmlParser alloc] init];
    
    NSDictionary *rootDictionary = [reader objectWithData:data];
    
    return rootDictionary;
}

+ (NSDictionary *)dictionaryParserXML:(NSXMLParser *)parser
{
    
    GenericXmlParser *reader = [[GenericXmlParser alloc] init];
    
    NSDictionary *rootDictionary = [reader objectWithXMLParser:parser];
    
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data
{
    
    GenericXmlParser *reader = [[GenericXmlParser alloc] init];
    
    NSDictionary *rootDictionary = [reader objectWithData:data];
    
    return rootDictionary;
}

+(NSString*) getValue :(NSString*) key inDic:(NSDictionary*) dic
{
    return [[[dic objectForKey:key]objectForKey:innerText] stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
}

+(NSString*) getAttributedValue :(NSString*) key inDic:(NSDictionary*) dic
{
    return [[[dic objectForKey:attributedData]objectForKey:key] stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
}

#pragma mark -
#pragma mark Parsing

- (NSDictionary *)objectWithXMLParser:(NSXMLParser *)parser
{
    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // Return the stack’s root dictionary on success
    if (success)
    {
        NSDictionary *resultDict;
        if (dictionaryStack.count > 0)
            resultDict = [dictionaryStack objectAtIndex:0] ;
        
        NSDictionary* dic = [[resultDict objectForKey:@"s:Envelope"] objectForKey:@"s:Body"];
        
        if(!dic)
            dic =  [[resultDict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"];
        
        if(!dic) {
            return resultDict;
        }
        
        return dic;
    }
    
    return nil;
}

- (NSDictionary *)objectWithData:(NSData *)data
{
    
    dictionaryStack = [[NSMutableArray alloc] init];
    textInProgress = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStack addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // Return the stack’s root dictionary on success
    if (success)
    {
        NSDictionary *resultDict;
        if (dictionaryStack.count > 0)
           resultDict = [dictionaryStack objectAtIndex:0] ;
        
        NSDictionary* dic = [[resultDict objectForKey:@"s:Envelope"] objectForKey:@"s:Body"];
        
        if(!dic)
            dic =  [[resultDict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"];
        
        return dic;
    }
    
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStack lastObject];
    
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    
    attributedDic = attributeDict;
    
    // If there’s already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    
    if (existingValue)
    {
        NSMutableArray *array = nil;
        
        if ([existingValue isKindOfClass:[NSMutableArray class]])
            array = (NSMutableArray *) existingValue;
        
        else
        {
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            [parentDict setObject:array forKey:elementName];
        }
        
        [array addObject:childDict];
    }
    else
        [parentDict setObject:childDict forKey:elementName];
    
    [dictionaryStack addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSMutableDictionary *dictInProgress = [dictionaryStack lastObject];
    
    if ([textInProgress length] > 0)
    {
        [dictInProgress setObject:textInProgress forKey:innerText];
        
        textInProgress =nil;
    }
    
    if(attributedDic.count > 0)
    {
        [dictInProgress setObject:attributedDic forKey:attributedData];
        
        attributedDic =nil;
    }
    
    // Pop the current dict
    [dictionaryStack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    textInProgress = string;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"%@",parseError);
    
}

@end
