//
//  GetAllTicketNotesService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/18/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetAllTicketNotesService: GenericServiceManager {
    
    /**
     This method will create GetAllTicketNotes request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func getAllTicketNotesWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        let tikcetNumber = parameters["TicketNumber"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetAllTicketNotes>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:barcode>" + tikcetNumber + "</tem:barcode>\n"
            + "</tem:GetAllTicketNotes>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>\n"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetAllTicketNotes")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        var notesHistoryArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["GetAllTicketNotesResponse","GetAllTicketNotesResult","a:GetAllTicketNotes"]) != nil {
            
            let allNotesHistoryArray = dictionary.getObjectFromDictionary(withKeys: ["GetAllTicketNotesResponse","GetAllTicketNotesResult","a:GetAllTicketNotes"])
            
            if allNotesHistoryArray is NSArray {
                notesHistoryArray = allNotesHistoryArray as! NSArray
            }else {
                let notesHistory = dictionary.getObjectFromDictionary(withKeys: ["GetAllTicketNotesResponse","GetAllTicketNotesResult","a:GetAllTicketNotes"])
                notesHistoryArray = [notesHistory]
            }
            
            var allNotesHistoryObjectArray:[NotesHistoryBO] = []
            
            for (_,value) in notesHistoryArray.enumerated() {
                
                var notesHistoryBO = NotesHistoryBO()
                notesHistoryBO = notesHistoryBO.getNotesHistoryBOFromDictionary(value as! NSDictionary)
                allNotesHistoryObjectArray.append(notesHistoryBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allNotesHistoryObjectArray as AnyObject)
            }
            
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate?.didFailedWithError!(self.identifier, errorMessage: "")
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate?.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
    
}
