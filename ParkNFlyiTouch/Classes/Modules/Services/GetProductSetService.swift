//
//  GetProductSetService.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/14/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetProductSetService: GenericServiceManager {
    
    /**
     This method will create GetProductSet request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getProductSetWebservice(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetProductSet>\n"
            + "<tem:FacilityCode></tem:FacilityCode>\n"
            + "<tem:DeviceCode></tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "</tem:GetProductSet>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "GetProductSet")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if ((dictionary.getObjectFromDictionary(withKeys: ["GetProductSetResponse","GetProductSetResult","a:ParkingType"]) as AnyObject).count > 0 ) {
            
            let parkingTypeArray = dictionary.getObjectFromDictionary(withKeys: ["GetProductSetResponse","GetProductSetResult","a:ParkingType"]) as! NSArray
            
            var parkingArray:[ProductSetServiceBO] = []
            
            for (_,value) in parkingTypeArray.enumerated() {
                
                var productSetServiceBO = ProductSetServiceBO()
                productSetServiceBO = productSetServiceBO.getProductSetServiceBOFromDictionary(value as! NSDictionary)
                parkingArray.append(productSetServiceBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: parkingArray as AnyObject)
            }
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate?.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
