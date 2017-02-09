//
//  AddTicketNotesService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/26/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class AddTicketNotesService: GenericServiceManager {
    
    /**
     This method will create AddTicketNotes request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func addTicketNotesWebservice(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        let noteDescription = parameters["Note"] as! String
        let authenticateUser = naviController?.authenticateUser
        let userName = naviController?.userName
        let ticketNumber = parameters["TicketNumber"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
//        + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
//        + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
//        + "<tem:LanguageCode></tem:LanguageCode>\n"
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:AddTicketNotes>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:notes>" + noteDescription + "</tem:notes>\n"
            + "<tem:cashierUserName>" + authenticateUser! + "\\" + userName! + "</tem:cashierUserName>\n"
            + "<tem:ticketBarcode>" + ticketNumber + "</tem:ticketBarcode>\n"
            + "</tem:AddTicketNotes>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "AddTicketNotes")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if (dict.getStringFromDictionary(withKeys: ["AddTicketNotesResponse","AddTicketNotesResult","a:Result"]) as NSString) != "" {
            
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
