//
//  GetAllTicketBySearchParamService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/1/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetAllTicketBySearchParamService: GenericServiceManager {
    
    /**
     This method will create GetAllTicketsBySearchParam request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func loadAllTicketsBySearchWebService(_ identifier: String ,parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        var soapMessage = ""
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        switch identifier {
            
        case kLoadTicketsByPhoneNumber:
            
            soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:GetAllTicketsBySearchParam>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:firstName></tem:firstName>\n"
                + "<tem:lastName></tem:lastName>\n"
                + "<tem:emailId></tem:emailId>\n"
                + "<tem:phoneNumber>" + (parameters["PhoneNumber"] as! String) + "</tem:phoneNumber>\n"
                + "</tem:GetAllTicketsBySearchParam>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
            
        case kLoadTicketsByLastName:
            
            soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:GetAllTicketsBySearchParam>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:firstName></tem:firstName>\n"
                + "<tem:lastName>" + (parameters["LastName"] as! String) + "</tem:lastName>\n"
                + "<tem:emailId></tem:emailId>\n"
                + "<tem:phoneNumber></tem:phoneNumber>\n"
                + "</tem:GetAllTicketsBySearchParam>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
        default:
            break
        }
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetAllTicketsBySearchParam")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        var ticketArray = NSArray()
        
        if dictionary.getObjectFromDictionary(withKeys: ["GetAllTicketsBySearchParamResponse","GetAllTicketsBySearchParamResult","a:TicketsInformation"]) != nil {
            
            let loadticketArray = dictionary.getObjectFromDictionary(withKeys: ["GetAllTicketsBySearchParamResponse","GetAllTicketsBySearchParamResult","a:TicketsInformation"])
            
            if loadticketArray is NSArray {
                ticketArray = loadticketArray as! NSArray
                
            } else {
                let ticket = dictionary.getObjectFromDictionary(withKeys: ["GetAllTicketsBySearchParamResponse","GetAllTicketsBySearchParamResult","a:TicketsInformation"])
                ticketArray = [ticket]
            }
            
        }
        var allTicketArray:[TicketBO] = []
        
        for (_,value) in ticketArray.enumerated() {
            
            var ticketsBO = TicketBO()
            ticketsBO = ticketsBO.getTicketBOFromDictionary(value as! NSDictionary)
            allTicketArray.append(ticketsBO)
        }
        
        if self.delegate?.connectionDidFinishLoading != nil {
            self.delegate!.connectionDidFinishLoading!(self.identifier, response: allTicketArray as AnyObject)
        }
            
        else {
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
