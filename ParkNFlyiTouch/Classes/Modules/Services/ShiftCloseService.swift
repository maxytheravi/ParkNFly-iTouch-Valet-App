//
//  ShiftCloseService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 3/17/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ShiftCloseService: GenericServiceManager {
    
    /**
     This method will create ShiftClose request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func shiftCloseWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        let authenticateUser = (naviController?.authenticateUser)! as String
        let userName = (naviController?.userName)! as String
        let shiftcode = (naviController?.shiftCode)! as String
        let deviceID = (naviController?.deviceIdByDeviceByDeviceAddress?.deviceId)!
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:ShiftClose>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:shiftCode>" + shiftcode + "</tem:shiftCode>\n"
            + "<tem:amount>0</tem:amount>\n"
            + "<tem:cashierUserName>" + authenticateUser + "\\" + userName + "</tem:cashierUserName>\n"
            + "<tem:deviceId>" + "\(deviceID)" + "</tem:deviceId>\n"
            + "</tem:ShiftClose>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"ShiftClose")
    }
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if dict.getObjectFromDictionary(withKeys: ["ShiftCloseResponse","ShiftCloseResult"]) != nil {
            
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
