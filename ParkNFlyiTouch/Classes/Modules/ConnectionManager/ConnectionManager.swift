//
//  ConnectionManager.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 12/10/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

@objc protocol ConnectionManagerDelegate {
    
    @objc optional func connectionDidFinishLoading(_ response: NSDictionary)
    @objc optional func didFailedWithError(_ error: AnyObject)
}

class ConnectionManager: NSObject {
    
    var delegate: ConnectionManagerDelegate?
    
    func callWebService(_ urlStr: String, soapMessage: String, soapActionName: String) {
        
        let url: URL = URL(string:urlStr as String)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url)
        
        let msgLength: String = "\(soapMessage.characters.count)"
        
        urlRequest.setValue("text/xml; charset=utf-8", forHTTPHeaderField:"Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("http://tempuri.org/IParkNFlyService/" + (soapActionName as String), forHTTPHeaderField:"SOAPAction")
        urlRequest.setValue(msgLength, forHTTPHeaderField:"Content-Length")
        urlRequest.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
        //        let loginSessionManager: AFURLSessionManager = ConnectionManager.defaultSessionManager()
        //        print(loginSessionManager)
        //
        //        loginSessionManager.dataTaskWithRequest(urlRequest, completionHandler: {(response, responseObject, error) in
        //
        //            if error == nil {
        //                let dict: NSDictionary = GenericXmlParser.dictionaryForXMLParser(responseObject as! NSXMLParser)
        //                print(dict)
        //                self.delegate!.connectionDidFinishLoading!(responseObject)
        //            } else {
        //                self.delegate!.didFailedWithError!(error)
        //            }
        //
        //        }).resume()
        
        let operation: AFHTTPRequestOperation = AFHTTPRequestOperation.init(request: urlRequest as URLRequest!)
        operation.responseSerializer = AFXMLParserResponseSerializer()
        
        operation.setCompletionBlockWithSuccess({ (operation, responseObject) -> Void in
            
            let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(responseObject as! XMLParser) as NSDictionary
            
            if dictionary.allKeys.count > 0 {
                if self.delegate?.connectionDidFinishLoading != nil {
                    self.delegate!.connectionDidFinishLoading!(dictionary)
                }
            } else {
                var error = NSString()
                error = klServerDownMsg as NSString
                
                if self.delegate?.didFailedWithError != nil {
                    self.delegate!.didFailedWithError!(error as AnyObject)
                }
            }
            
        }) { (operation, error) -> Void in
            
            if self.delegate?.didFailedWithError != nil {
                self.delegate!.didFailedWithError!(error as AnyObject)
            }
            print(error?.localizedDescription)
        }
        operation.start()
    }
    //    class func defaultSessionManager() -> AFURLSessionManager {
    //
    //        let sessionConfiguration : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    //        let sessionManager : AFURLSessionManager = AFURLSessionManager(sessionConfiguration: sessionConfiguration)
    //        sessionManager.responseSerializer = AFXMLParserResponseSerializer()
    //        
    //        return sessionManager
    //    }
}
