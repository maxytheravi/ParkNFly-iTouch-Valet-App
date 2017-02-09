//
//  GetFacilityConfigService.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 12/10/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetFacilityConfigService: GenericServiceManager {
    
    func getFacilityConfigWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetFacilityConfig>\n"
            + "<tem:FacilityCode></tem:FacilityCode>\n"
            + "<tem:DeviceCode></tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "</tem:GetFacilityConfig>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetFacilityConfig")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if (dict.getObjectFromDictionary(withKeys: ["GetFacilityConfigResponse","GetFacilityConfigResult"]) != nil) {
            let facilityConfigDict: NSDictionary = dict.getObjectFromDictionary(withKeys: ["GetFacilityConfigResponse","GetFacilityConfigResult"]) as! NSDictionary
            
            let facilityConfigBO: FacilityConfigBO = FacilityConfigBO()
            _ = facilityConfigBO.getFacilityConfigBOFromDictionary(facilityConfigDict)
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: facilityConfigBO)
            }
        }
        else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate?.didFailedWithError!(self.identifier, errorMessage: "")
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
