//
//  LoadFrequentParkerByFPCardNoService.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/14/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class LoadFrequentParkerByFPCardNoService: GenericServiceManager {
    
    var parametersForFp = NSDictionary()
    
    func loadFrequentParkerByFPCardNoWebService(_ identifier: String ,parameters: NSDictionary) {
        
        parametersForFp = parameters
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        var reservationNumber:String = ""
        var phoneNumber:String = ""
        var soapMessage = ""
        var fpCardNumber:String = ""
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        switch identifier {
            
        case kLoadFrequentParkerByFPCardNoForReservation:
            
            reservationNumber = parameters["ReservationNumber"] as! String
            
            soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:LoadFrequentParkerByFPCardNo>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:fpCardNoOrPhoneNo>" + "" + "</tem:fpCardNoOrPhoneNo>"
                + "<tem:reservationCodeOrPhoneNo>" + reservationNumber + "</tem:reservationCodeOrPhoneNo>"
                + "</tem:LoadFrequentParkerByFPCardNo>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
            
        case kLoadFrequentParkerByFPCardNo:
            
            fpCardNumber = parameters["FPCardNumber"] as! String
            
            soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:LoadFrequentParkerByFPCardNo>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:fpCardNoOrPhoneNo>" + fpCardNumber + "</tem:fpCardNoOrPhoneNo>"
                + "<tem:reservationCodeOrPhoneNo>" + "" + "</tem:reservationCodeOrPhoneNo>"
                + "</tem:LoadFrequentParkerByFPCardNo>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            break
            
        case kLoadFrequentParkerByFPCardNoByPhoneNoOfReservation:
            
            phoneNumber = parameters["PhoneNumber"] as! String
            
            soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:LoadFrequentParkerByFPCardNo>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:fpCardNoOrPhoneNo>" + "" + "</tem:fpCardNoOrPhoneNo>"
                + "<tem:reservationCodeOrPhoneNo>" + phoneNumber + "</tem:reservationCodeOrPhoneNo>"
                + "</tem:LoadFrequentParkerByFPCardNo>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
            
        case kLoadFrequentParkerByFPCardNoByPhoneNoOfFpCard:
            
            phoneNumber = parameters["PhoneNumber"] as! String
            
            soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
                + "<soapenv:Header/>\n"
                + "<soapenv:Body>\n"
                + "<tem:LoadFrequentParkerByFPCardNo>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:fpCardNoOrPhoneNo>" + phoneNumber + "</tem:fpCardNoOrPhoneNo>"
                + "<tem:reservationCodeOrPhoneNo>" + "" + "</tem:reservationCodeOrPhoneNo>"
                + "</tem:LoadFrequentParkerByFPCardNo>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>"
            
            break
            
        default:
            break
        }
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"LoadFrequentParkerByFPCardNo")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        switch identifier {
            
        case kLoadFrequentParkerByFPCardNoForReservation:
            if dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"]) != nil {
                
                let loadFrequentParkerCardDict:NSDictionary = dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"]) as! NSDictionary
                
                let reservationAndFPCardDetailsBO: ReservationAndFPCardDetailsBO = ReservationAndFPCardDetailsBO()
                _ = reservationAndFPCardDetailsBO.getReservationAndFPCardDetailsBOFromDictionary(loadFrequentParkerCardDict)
                
                if self.delegate?.connectionDidFinishLoading != nil {
                    self.delegate!.connectionDidFinishLoading!(self.identifier, response: reservationAndFPCardDetailsBO)
                }
            }else {
                if self.delegate?.didFailedWithError != nil {
                    self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
                }
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNoByPhoneNoOfReservation:
            
            var phoneDetailArray = NSArray()
            
            if let phoneDetailsArray = dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"]) {
                
                if (phoneDetailsArray as AnyObject) is NSArray {
                    phoneDetailArray = phoneDetailsArray as! NSArray
                    
                } else if dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"]) != nil {
                    
                    let phonedetail = dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"])
                    phoneDetailArray = [phonedetail]
                }
                var allReservationArray:[ReservationAndFPCardDetailsBO] = []
                
                for (_,value) in phoneDetailArray.enumerated() {
                    
                    var reservationAndFPCardDetailsBO = ReservationAndFPCardDetailsBO()
                    reservationAndFPCardDetailsBO = reservationAndFPCardDetailsBO.getReservationAndFPCardDetailsBOFromDictionary(value as! NSDictionary)
                    
                    allReservationArray.append(reservationAndFPCardDetailsBO)
                }
                if self.delegate?.connectionDidFinishLoading != nil {
                    self.delegate?.connectionDidFinishLoading!(self.identifier, response: allReservationArray as AnyObject)
                }
                else {
                    if self.delegate?.didFailedWithError != nil {
                        self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
                    }
                }
            } else {
                self.loadFrequentParkerByFPCardNoWebService(kLoadFrequentParkerByFPCardNoByPhoneNoOfFpCard, parameters: parametersForFp)
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNo:
            
            var fpCardDetailWithReseravtionArray = NSArray()
            
            if let reservationDetailArray = dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"]) {
                
                //                if (reservationDetailArray as AnyObject).isKind(of: NSArray()){
                if (reservationDetailArray as AnyObject) is NSArray {
                    
                    fpCardDetailWithReseravtionArray = reservationDetailArray as! NSArray
                    
                } else if dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"]) != nil {
                    
                    let fpCarddetail = dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"])
                    fpCardDetailWithReseravtionArray = [fpCarddetail]
                }
                var allReservationArray:[ReservationAndFPCardDetailsBO] = []
                
                for (_,value) in fpCardDetailWithReseravtionArray.enumerated() {
                    
                    var reservationAndFPCardDetailsBO = ReservationAndFPCardDetailsBO()
                    reservationAndFPCardDetailsBO = reservationAndFPCardDetailsBO.getReservationAndFPCardDetailsBOFromDictionary(value as! NSDictionary)
                    
                    allReservationArray.append(reservationAndFPCardDetailsBO)
                }
                if self.delegate?.connectionDidFinishLoading != nil {
                    self.delegate?.connectionDidFinishLoading!(self.identifier, response: allReservationArray as AnyObject)
                }
                else {
                    if self.delegate?.didFailedWithError != nil {
                        self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
                    }
                }
            }else {
                if self.delegate?.didFailedWithError != nil {
                    self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
                }
            }
            
            break
            
        case kLoadFrequentParkerByFPCardNoByPhoneNoOfFpCard:
            if dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"]) != nil {
                
                let loadFrequentParkerCardDict:NSDictionary = dict.getObjectFromDictionary(withKeys: ["LoadFrequentParkerByFPCardNoResponse","LoadFrequentParkerByFPCardNoResult","a:CustomerInformation"]) as! NSDictionary
                
                let reservationAndFPCardDetailsBO: ReservationAndFPCardDetailsBO = ReservationAndFPCardDetailsBO()
                _ = reservationAndFPCardDetailsBO.getReservationAndFPCardDetailsBOFromDictionary(loadFrequentParkerCardDict)
                
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
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
