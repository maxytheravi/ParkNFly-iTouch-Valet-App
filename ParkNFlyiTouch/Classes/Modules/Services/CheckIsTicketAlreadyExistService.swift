//
//  CheckIsTicketAlreadyExistService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 3/30/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class CheckIsTicketAlreadyExistService: GenericServiceManager {
    
    /**
     This method will create CheckIsTicketAlreadyExist request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func checkIsTicketAlreadyExistWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        var customerProfileID: String?
        customerProfileID = naviController?.reservationDetails?.customerProfileID
        
        let customerProfileIDTag = customerProfileID != nil ? ("<tem:customerProfileID>" + "\(customerProfileID!)" + "</tem:customerProfileID>\n") : "<tem:customerProfileID xsi:nil=\"true\" />\n"
        var fpcardNo = ""
        if naviController?.reservationDetails?.fpCode?.characters.count > 0 {
            fpcardNo = (naviController?.reservationDetails?.fpCode)!
        }else {
            fpcardNo = (naviController?.reservationDetails?.fpCardNo)!
        }
        
        var reservationID = ""
        if naviController?.reservationDetails?.reservationCode?.characters.count > 0 {
            reservationID = (naviController?.reservationDetails?.reservationCode)!
        }
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:CheckIsTicketAlreadyExist>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + customerProfileIDTag
            + "<tem:IdentifierKey>" + fpcardNo + "</tem:IdentifierKey>\n"
            + "<tem:reservations>\n"
            + "<par:TicketReservation>\n"
            + "<par:_AppliedDate xsi:nil=\"true\" />\n"
            + "<par:_ReservationID>" + reservationID + "</par:_ReservationID>\n"
            + "<par:_ReservationPhone></par:_ReservationPhone>\n"
            + "<par:_Ticket xsi:nil=\"true\" />\n"
            + "<par:_TicketID>0</par:_TicketID>\n"
            + "<par:_TicketReservationID>0</par:_TicketReservationID>\n"
            + "</par:TicketReservation>\n"
            + "</tem:reservations>\n"
            + "</tem:CheckIsTicketAlreadyExist>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"CheckIsTicketAlreadyExist")
    }
    
    /**
     This method will create CheckIsTicketAlreadyExist request for onLot.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func checkIsTicketAlreadyExistWebServiceForOnLot(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        let reservationID = parameters["ReservationNumber"] as! String
        
        //        if naviController?.ticketBO?.reservationsArray?.count > 0 {
        //            let reservationObject:ReservationAndFPCardDetailsBO = (naviController?.ticketBO?.reservationsArray?.last)!
        //            reservationID = reservationObject.reservationCode!
        //        }
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:CheckIsTicketAlreadyExist>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:customerProfileID xsi:nil=\"true\" />\n"
            + "<tem:IdentifierKey></tem:IdentifierKey>\n"
            + "<tem:reservations>\n"
            + "<par:TicketReservation>\n"
            + "<par:_AppliedDate xsi:nil=\"true\" />\n"
            + "<par:_ReservationID>" + reservationID + "</par:_ReservationID>\n"
            + "<par:_ReservationPhone></par:_ReservationPhone>\n"
            + "<par:_Ticket xsi:nil=\"true\" />\n"
            + "<par:_TicketID>0</par:_TicketID>\n"
            + "<par:_TicketReservationID>0</par:_TicketReservationID>\n"
            + "</par:TicketReservation>\n"
            + "</tem:reservations>\n"
            + "</tem:CheckIsTicketAlreadyExist>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"CheckIsTicketAlreadyExist")
    }
    
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if dict.getObjectFromDictionary(withKeys: ["CheckIsTicketAlreadyExistResponse","CheckIsTicketAlreadyExistResult"]) != nil {
            
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
