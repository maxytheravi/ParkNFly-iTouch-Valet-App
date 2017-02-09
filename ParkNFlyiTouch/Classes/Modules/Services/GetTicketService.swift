//
//  GetTicketService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/19/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetTicketService: GenericServiceManager {
    
    /**
     This method will create GetTicket request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getTicketWebService(_ identifier: String ,parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        var soapMessage = ""
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        switch identifier {
            
        case kGetTicketForFPCardNo:
            
            soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:GetTicket>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:fpCardNoOrPhoneNo>" + (parameters["FPCardNumber"] as! String) + "</tem:fpCardNoOrPhoneNo>"
                + "<tem:resCodeOrPhoneNo></tem:resCodeOrPhoneNo>\n"
                + "<tem:licenceTag></tem:licenceTag>\n"
                + "<tem:creditCardFirstSixLastFour></tem:creditCardFirstSixLastFour>\n"
                + "</tem:GetTicket>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
            
        case kGetTicketForReservationNo:
            
            soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:GetTicket>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:fpCardNoOrPhoneNo></tem:fpCardNoOrPhoneNo>\n"
                + "<tem:resCodeOrPhoneNo>" + (parameters["ReservationNumber"] as! String) + "</tem:resCodeOrPhoneNo>\n"
                + "<tem:licenceTag></tem:licenceTag>\n"
                + "<tem:creditCardFirstSixLastFour></tem:creditCardFirstSixLastFour>\n"
                + "</tem:GetTicket>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
            
        default:
            break
            
        }
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetTicket")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        var ticketDictArray = NSArray()
        
        if let ticketsDictArr = dictionary.getObjectFromDictionary(withKeys: ["GetTicketResponse","GetTicketResult","a:TicketsInformations","a:TicketInfo"]) {
            
            if (ticketsDictArr as AnyObject) is NSArray {
                ticketDictArray = ticketsDictArr as! NSArray
            }
        } else {
            if dictionary.getObjectFromDictionary(withKeys: ["GetTicketResponse","GetTicketResult","a:TicketInfo"]) != nil {
                
                let ticket = dictionary.getObjectFromDictionary(withKeys: ["GetTicketResponse","GetTicketResult","a:TicketInfo"])
                ticketDictArray = [ticket]
            }
        }
        
        var ticketArray:[TicketBO] = []
        
        for (_,value) in ticketDictArray.enumerated() {
            
            var ticketBO = TicketBO()
            ticketBO = ticketBO.getTicketBOFromDictionary(value as! NSDictionary)
            ticketArray.append(ticketBO)
        }
        
        if ticketArray.count > 0 {
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: ticketArray as AnyObject)
            }
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate?.didFailedWithError!(self.identifier, errorMessage: klNoRecordFound)
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate?.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
    
}
