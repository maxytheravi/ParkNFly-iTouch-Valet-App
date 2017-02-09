//
//  GetAllReservationsBySearchParamService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/2/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetAllReservationsBySearchParamService: GenericServiceManager {
    
    /**
     This method will create GetAllReservationsBySearchParam request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func loadDetailsByLastNameWebService(_ identifier: String ,parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        var reservationNumber:String = ""
        var lastName:String = ""
        var soapMessage = ""
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        switch identifier {
            
        case kLoadDetailsByLastName:
            
            lastName = parameters["LastName"] as! String
            
            soapMessage = "<soapenv:Envelope  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:GetAllReservationsBySearchParam>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:fromDate xsi:nil=\"true\"></tem:fromDate>\n"
                + "<tem:toDate xsi:nil=\"true\"></tem:toDate>\n"
                + "<tem:reservationCode xsi:nil=\"true\"></tem:reservationCode>\n"
                + "<tem:firstName xsi:nil=\"true\"></tem:firstName>\n"
                + "<tem:lastName>" + lastName + "</tem:lastName>\n"
                + "<tem:emailId xsi:nil=\"true\"></tem:emailId>\n"
                + "<tem:fpCardNo xsi:nil=\"true\"></tem:fpCardNo>\n"
                + "<tem:barcode xsi:nil=\"true\"></tem:barcode>\n"
                + "<tem:resStartDate xsi:nil=\"true\"></tem:resStartDate>\n"
                + "<tem:resEndDate xsi:nil=\"true\"></tem:resEndDate>\n"
                + "<tem:isforResSearch>true</tem:isforResSearch>\n"
                + "<tem:creditCardTrackData xsi:nil=\"true\"></tem:creditCardTrackData>\n"
                + "</tem:GetAllReservationsBySearchParam>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
            
        case kLoadReservationDetailsByReservationForCheckout:
            
            reservationNumber = parameters["RESERVATION"] as! String
            
            soapMessage = "<soapenv:Envelope  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"  xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:GetAllReservationsBySearchParam>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:fromDate xsi:nil=\"true\"></tem:fromDate>\n"
                + "<tem:toDate xsi:nil=\"true\"></tem:toDate>\n"
                + "<tem:reservationCode>" + reservationNumber + "</tem:reservationCode>\n"
                + "<tem:firstName xsi:nil=\"true\"></tem:firstName>\n"
                + "<tem:lastName xsi:nil=\"true\"></tem:lastName>\n"
                + "<tem:emailId xsi:nil=\"true\"></tem:emailId>\n"
                + "<tem:fpCardNo xsi:nil=\"true\"></tem:fpCardNo>\n"
                + "<tem:barcode xsi:nil=\"true\"></tem:barcode>\n"
                + "<tem:resStartDate xsi:nil=\"true\"></tem:resStartDate>\n"
                + "<tem:resEndDate xsi:nil=\"true\"></tem:resEndDate>\n"
                + "<tem:isforResSearch>true</tem:isforResSearch>\n"
                + "<tem:creditCardTrackData xsi:nil=\"true\"></tem:creditCardTrackData>\n"
                + "</tem:GetAllReservationsBySearchParam>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
            
        default:
            break
        }
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetAllReservationsBySearchParam")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        switch identifier {
            
        case kLoadDetailsByLastName:
            
            var customerDetailsArray = NSArray()
            if dictionary.getObjectFromDictionary(withKeys: ["GetAllReservationsBySearchParamResponse","GetAllReservationsBySearchParamResult","a:Reservations"]) != nil {
                
                let loadcustomerDetailsArray = dictionary.getObjectFromDictionary(withKeys: ["GetAllReservationsBySearchParamResponse","GetAllReservationsBySearchParamResult","a:Reservations"])
                
                if loadcustomerDetailsArray is NSArray {
                    customerDetailsArray = loadcustomerDetailsArray as! NSArray
                    
                } else {
                    let customerDetails = dictionary.getObjectFromDictionary(withKeys: ["GetAllReservationsBySearchParamResponse","GetAllReservationsBySearchParamResult","a:Reservations"])
                    customerDetailsArray = [customerDetails]
                }
                
            }
            var allcustomerDetailsArray:[ReservationAndFPCardDetailsBO] = []
            
            for (_,value) in customerDetailsArray.enumerated() {
                
                var reservationAndFPCardDetailsBO = ReservationAndFPCardDetailsBO()
                reservationAndFPCardDetailsBO = reservationAndFPCardDetailsBO.getReservationAndFPCardDetailsBOFromDictionary(value as! NSDictionary)
                allcustomerDetailsArray.append(reservationAndFPCardDetailsBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: allcustomerDetailsArray as AnyObject)
            }
            else {
                if self.delegate?.didFailedWithError != nil {
                    self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
                }
            }
        case kLoadReservationDetailsByReservationForCheckout:
            
            if dictionary.getObjectFromDictionary(withKeys: ["GetAllReservationsBySearchParamResponse","GetAllReservationsBySearchParamResult","a:Reservations"]) != nil {
                let loadResevationDict:NSDictionary = dictionary.getObjectFromDictionary(withKeys: ["GetAllReservationsBySearchParamResponse","GetAllReservationsBySearchParamResult","a:Reservations"]) as! NSDictionary
                
                let reservationAndFPCardDetailsBO: ReservationAndFPCardDetailsBO = ReservationAndFPCardDetailsBO()
                _ = reservationAndFPCardDetailsBO.getReservationAndFPCardDetailsBOFromDictionary(loadResevationDict)
                
                if self.delegate?.connectionDidFinishLoading != nil {
                    self.delegate!.connectionDidFinishLoading!(self.identifier, response: reservationAndFPCardDetailsBO)
                }
            }else {
                if self.delegate?.didFailedWithError != nil {
                    self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
                }
            }
            
            break
            
        default:
            break
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate?.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
