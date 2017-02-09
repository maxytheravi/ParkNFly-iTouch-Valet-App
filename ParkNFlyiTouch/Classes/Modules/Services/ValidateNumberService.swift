//
//  ValidateNumberService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 11/19/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ValidateNumberService: GenericServiceManager {
    
    /**
     This method will create ValidateNumber request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func validateNumberWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        let prePrintedNumber = parameters["PriprintedNumber"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:ValidateNumber>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:scanValue>" + prePrintedNumber + "</tem:scanValue>\n"
            + "</tem:ValidateNumber>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"ValidateNumber")
    }
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if dict.getObjectFromDictionary(withKeys: ["ValidateNumberResponse","ValidateNumberResult"]) != nil {
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: dict)
            }
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate!.didFailedWithError!(self.identifier, errorMessage: klServerDownMsg)
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
