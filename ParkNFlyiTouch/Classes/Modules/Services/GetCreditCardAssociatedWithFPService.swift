//
//  GetCreditCardAssociatedWithFPService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 1/20/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetCreditCardAssociatedWithFPService:GenericServiceManager {
    
    /**
     This method will create GetCreditCardAssociatedWithFP request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getCreditCardAssociatedWithFPNoWebService(_ identifier: String ,parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        let fpCardNumber = parameters["FPCardNumber"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetCreditCardAssociatedWithFP>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:FPCardNumber>" + fpCardNumber + "</tem:FPCardNumber>\n"
            + "</tem:GetCreditCardAssociatedWithFP>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetCreditCardAssociatedWithFP")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if dictionary.getObjectFromDictionary(withKeys: ["GetCreditCardAssociatedWithFPResponse","GetCreditCardAssociatedWithFPResult","a:CardNumber"]) != nil {
            
            let loadCreditCardDetails:NSDictionary = dictionary.getObjectFromDictionary(withKeys: ["GetCreditCardAssociatedWithFPResponse","GetCreditCardAssociatedWithFPResult"]) as! NSDictionary
            
            let creditCardDetailsBO: CreditCardInfoBO = CreditCardInfoBO()
            _ = creditCardDetailsBO.getCreditCardInfoBOFromDictionary(loadCreditCardDetails)
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: creditCardDetailsBO)
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

