//
//  GetContractCardService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas on 11/29/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetContractCardService : GenericServiceManager {
    
    /**
     This method will create ValidateNumber request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func getContractCardWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        let contractCardNumber = parameters["CONTRACTCARDNUMBER"] as! String
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        let facilityCode = naviController?.facilityConfig?.facilityCode
        
        let soapMessage =  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:tem=\"http://tempuri.org/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetContractCard>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:cardNumber>" + contractCardNumber + "</tem:cardNumber>\n"
            + "<tem:ticketPrintDateTime xsi:nil=\"true\" />\n"
            + "</tem:GetContractCard>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetContractCard")
    }
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if dict.getObjectFromDictionary(withKeys: ["GetContractCardResponse","GetContractCardResult","a:Result"]) != nil {
            
            let contractCardDict: NSDictionary = dict.getObjectFromDictionary(withKeys: ["GetContractCardResponse","GetContractCardResult","a:Result"]) as! NSDictionary
            
            let contractCardBO: ContractCardInfoBO = ContractCardInfoBO()
            _ = contractCardBO.getContractCardInfoBOFromDictionary(contractCardDict)
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: contractCardBO)
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
