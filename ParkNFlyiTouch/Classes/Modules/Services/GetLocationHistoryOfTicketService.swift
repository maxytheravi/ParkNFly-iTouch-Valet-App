//
//  GetLocationHistoryOfTicketService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/16/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetLocationHistoryOfTicketService: GenericServiceManager {
    
    /**
     This method will create GetLocationHistoryOfTicket request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func getLocationHistoryOfTicketWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        let tikcetNumber = parameters["TicketNumber"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetLocationHistoryOfTicket>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:barcode>" + tikcetNumber + "</tem:barcode>\n"
            + "</tem:GetLocationHistoryOfTicket>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetLocationHistoryOfTicket")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        var locationHistoryArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["GetLocationHistoryOfTicketResponse","GetLocationHistoryOfTicketResult","a:LocationHistoryOfTicket"]) != nil {
            
            let allLocationHistoryArray = dictionary.getObjectFromDictionary(withKeys: ["GetLocationHistoryOfTicketResponse","GetLocationHistoryOfTicketResult","a:LocationHistoryOfTicket"])
            
            //            if allLocationHistoryArray.isKind(of: NSArray){
            if allLocationHistoryArray is NSArray {
                locationHistoryArray = allLocationHistoryArray as! NSArray
            }else {
                let  locationHistory = dictionary.getObjectFromDictionary(withKeys: ["GetLocationHistoryOfTicketResponse","GetLocationHistoryOfTicketResult","a:LocationHistoryOfTicket"])
                locationHistoryArray = [locationHistory]
            }
            
            var allLocationHistoryObjectArray:[LocationHistoryBO] = []
            
            for (_,value) in locationHistoryArray.enumerated() {
                
                var locationHistoryBO = LocationHistoryBO()
                locationHistoryBO = locationHistoryBO.getLocationHistoryBOFromDictionary(value as! NSDictionary)
                allLocationHistoryObjectArray.append(locationHistoryBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allLocationHistoryObjectArray as AnyObject)
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
