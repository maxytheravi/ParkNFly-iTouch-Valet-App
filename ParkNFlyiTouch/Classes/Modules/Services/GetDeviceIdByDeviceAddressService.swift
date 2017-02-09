//
//  GetDeviceIdByDeviceAddressService.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 12/10/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetDeviceIdByDeviceAddressService: GenericServiceManager {
    
    func getDeviceIdByDeviceAddressWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetDeviceIdByDeviceAddress>\n"
            + "<tem:FacilityCode></tem:FacilityCode>\n"
            + "<tem:DeviceCode></tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:DeviceAddress>" + "\(Utility.getDeviceIdentifier())" + "</tem:DeviceAddress>\n"
            + "</tem:GetDeviceIdByDeviceAddress>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetDeviceIdByDeviceAddress")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if dict.getObjectFromDictionary(withKeys: ["GetDeviceIdByDeviceAddressResponse","GetDeviceIdByDeviceAddressResult"]) != nil {
            
            let deviceIdByDeviceAddressDict: NSDictionary = dict.getObjectFromDictionary(withKeys: ["GetDeviceIdByDeviceAddressResponse","GetDeviceIdByDeviceAddressResult"]) as! NSDictionary
            
            let deviceIdByDeviceAddress: DeviceIdByDeviceAddressBO = DeviceIdByDeviceAddressBO()
            _ = deviceIdByDeviceAddress.getDeviceIdByDeviceAddressBOFromDictionary(deviceIdByDeviceAddressDict)
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: deviceIdByDeviceAddress)
            }
            
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate!.didFailedWithError!(self.identifier, errorMessage: "No records")
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
