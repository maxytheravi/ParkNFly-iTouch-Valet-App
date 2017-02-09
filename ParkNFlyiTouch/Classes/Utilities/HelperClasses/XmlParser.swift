//
//  XMLParser.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/12/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class XMLParser: NSObject, XMLParserDelegate {
    
    var dictionaryStack:NSMutableArray = NSMutableArray()
    var textInProgress:NSString? = ""
    var attributedDic:NSDictionary? = NSDictionary()
    
    class func decodeHtmLEntities (_ htmlData:Data) -> NSString
    {
        let newString = NSString(data: htmlData, encoding: String.Encoding.utf8.rawValue)
        
        return newString!
    }

    class func dictionaryForXMLString (_ string:NSString) -> NSDictionary
    {
        let data:Data = string.data(using: String.Encoding.utf8.rawValue)!
        let reader = XMLParser()
        let rootDictionary = reader.objectWithData(data)
        return rootDictionary!
    }
    
    class func dictionaryForXMLParser (_ parser:Foundation.XMLParser) -> NSDictionary
    {
        let reader = XMLParser()
        let rootDictionary: NSDictionary = reader.objectWithXMLParser(parser)!
        return rootDictionary
    }
    
    class func dictionaryForXMLData (_ data:Data) -> NSDictionary
    {
        let reader = XMLParser()
        let rootDictionary = reader.objectWithData(data)
        return rootDictionary!
    }
    
    class func getValue (_ key:String, dictionary:Dictionary<String, AnyObject>) -> String
    {
        return (((dictionary[key] as! Dictionary<String, AnyObject>) [kInnerText] as! String) .trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
    }
    
    class func getAttributedValue (_ key:String, dictionary:Dictionary<String, AnyObject>) -> String
    {
        return ((dictionary[kAttributedData] as! Dictionary<String, AnyObject>) [key] as! String).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func objectWithData (_ data:Data) -> NSDictionary? {
        
        dictionaryStack = NSMutableArray()
        textInProgress = NSMutableString()
        
        dictionaryStack.add(NSMutableDictionary())
        
        let parser = Foundation.XMLParser(data: data)
        parser.delegate = self
        let success = parser.parse()
        
        if success {
            var resultDict = NSDictionary()
            
            if dictionaryStack.count > 0 {
                resultDict = dictionaryStack.object(at: 0) as! NSDictionary
            }
            
            var dictionary = (resultDict.object(forKey: "s:Envelope") as AnyObject).object(forKey: "s:Body")
            
            if !(dictionary != nil) {
                dictionary = (resultDict.object(forKey: "soap:Envelope") as AnyObject).object(forKey: "soap:Body")
            }
        }
        return nil
    }
    
    func objectWithXMLParser(_ parser:Foundation.XMLParser) -> NSDictionary?
    {
        dictionaryStack = NSMutableArray()
        textInProgress = NSMutableString()
        
        dictionaryStack.add(NSMutableDictionary())
        
        parser.delegate = self
        let success: Bool = parser.parse()
        
        if success {
            
            var resultDict: NSDictionary = NSDictionary()
            
            if dictionaryStack.count > 0 {
                resultDict = dictionaryStack.object(at: 0) as! NSDictionary
            }
            var dic = (resultDict.object(forKey: "s:Envelope") as AnyObject).object(forKey: "s:Body")
            
            if !(dic != nil) {
                dic = (resultDict.object(forKey: "soap:Envelope") as AnyObject).object(forKey: "soap:Body")
            }
            if !(dic != nil) {
                return resultDict
            }
            return dic as? NSDictionary
        }
        return nil
    }
    
    //MARK: NSXMLParserDelegate method
      func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        let parentDict = dictionaryStack.lastObject as! NSMutableDictionary
        let childDict = NSMutableDictionary()
        
        attributedDic = attributeDict as NSDictionary?
        
        // If there’s already an item for this key, it means we need to create an array
        if let existingValue = parentDict.object(forKey: elementName) {
            
            var array:NSMutableArray = NSMutableArray()
            if (existingValue as AnyObject) is NSMutableArray {
                
                array = existingValue as! NSMutableArray
            } else {
                
                array = NSMutableArray()
                array.add(existingValue)
                parentDict.setObject(array, forKey: elementName as NSCopying)
            }
            array.add(childDict)
        } else {
            parentDict.setObject(childDict, forKey: elementName as NSCopying)
        }
        dictionaryStack.add(childDict)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        let dictInProgress = dictionaryStack.lastObject as! NSMutableDictionary
        if textInProgress?.length > 0 {
            dictInProgress.setObject(textInProgress!, forKey: kInnerText as NSCopying)
            textInProgress = nil
        }
        if attributedDic!.count > 0 {
            dictInProgress.setObject(attributedDic!, forKey: kAttributedData as NSCopying)
            attributedDic = nil
        }
        // Pop the current dict
        dictionaryStack.removeLastObject()
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        textInProgress = string as NSString?
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
}



