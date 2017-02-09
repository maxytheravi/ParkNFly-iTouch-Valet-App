//
//  GetAllLocation.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/14/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetAllLocationService: GenericServiceManager {
    
    /**
     This method will create GetAllLocation request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getAllLocationWebservice(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetAllLocation>\n"
            + "<tem:FacilityCode></tem:FacilityCode>\n"
            + "<tem:DeviceCode></tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "</tem:GetAllLocation>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "GetAllLocation")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if (dictionary.getObjectFromDictionary(withKeys: ["GetAllLocationResponse","GetAllLocationResult","a:Location"]) as AnyObject).count > 0 {
            
            let allLocationArray = dictionary.getObjectFromDictionary(withKeys: ["GetAllLocationResponse","GetAllLocationResult","a:Location"]) as! NSArray
            
            var allLocationObjectArray:[LocationBO] = []
            
            for (_,value) in allLocationArray.enumerated() {
                
                var locationBO = LocationBO()
                locationBO = locationBO.getLocationBOFromDictionary(value as! NSDictionary)
                allLocationObjectArray.append(locationBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allLocationObjectArray as AnyObject)
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
