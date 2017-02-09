//
//  LoadMultipleFrequnetParkerByFPCardNoService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/16/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class LoadMultipleFrequnetParkerByFPCardNoService: GenericServiceManager {
    
    /**
     This method will create LoadMultipleFrequentParkerByFPCardNo request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func loadMultilpeFrequentParkerByFPCardNoWebService(_ identifier: String ,parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        let fpCardNumber = parameters["FPCardNumber"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:LoadMultipleFrequentParkerByFPCardNo>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:fpCardNo>" + fpCardNumber + "</tem:fpCardNo>"
            + "</tem:LoadMultipleFrequentParkerByFPCardNo>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"LoadMultipleFrequentParkerByFPCardNo")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        var fpcardArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["LoadMultipleFrequentParkerByFPCardNoResponse","LoadMultipleFrequentParkerByFPCardNoResult","a:LoadMultipleFPCardNoResult"]) != nil {
            
            let loadMultipleFrequentParkerArray = dictionary.getObjectFromDictionary(withKeys: ["LoadMultipleFrequentParkerByFPCardNoResponse","LoadMultipleFrequentParkerByFPCardNoResult","a:LoadMultipleFPCardNoResult"])
            
            if loadMultipleFrequentParkerArray is NSArray {
                fpcardArray = loadMultipleFrequentParkerArray as! NSArray
                
            } else {
                let fpcard = dictionary.getObjectFromDictionary(withKeys: ["LoadMultipleFrequentParkerByFPCardNoResponse","LoadMultipleFrequentParkerByFPCardNoResult","a:LoadMultipleFPCardNoResult"])
                fpcardArray = [fpcard]
            }
        }
        var allFpCardArray:[ReservationAndFPCardDetailsBO] = []
        
        for (_,value) in fpcardArray.enumerated() {
            
            var reservationAndFPCardDetailsBO = ReservationAndFPCardDetailsBO()
            reservationAndFPCardDetailsBO = reservationAndFPCardDetailsBO.getReservationAndFPCardDetailsBOFromDictionary(value as! NSDictionary)
            allFpCardArray.append(reservationAndFPCardDetailsBO)
        }
        
        if self.delegate?.connectionDidFinishLoading != nil {
            self.delegate!.connectionDidFinishLoading!(self.identifier, response: allFpCardArray as AnyObject)
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


