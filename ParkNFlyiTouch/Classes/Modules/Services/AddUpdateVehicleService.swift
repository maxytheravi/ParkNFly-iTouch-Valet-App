//
//  AddUpdateVehicleService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/29/16.
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


class AddUpdateVehicleService: GenericServiceManager {
    
    /**
     This method will create AddUpdateVehicleService request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func addUpdateVehicleWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        var customerProfileID: String?
        customerProfileID = naviController?.reservationDetails?.customerProfileID
        
        let customerProfileIDTag = customerProfileID != nil ? ("<par:CustomerProfileID>" + "\(customerProfileID!)" + "</par:CustomerProfileID>\n") : "<par:CustomerProfileID xsi:nil=\"true\" />\n"
        
        let customerProfileIDTem = customerProfileID != nil ? ("<tem:customerProfileID>" + "\(customerProfileID!)" + "</tem:customerProfileID>\n") : "<tem:customerProfileID xsi:nil=\"true\" />\n"
        
        
        let color: String = naviController?.vehicleDetails?.vehicleColor != nil ? ("<par:Color>" + (naviController?.vehicleDetails?.vehicleColor)! + "</par:Color>\n") : "<par:Color xsi:nil=\"true\" />\n"
        
        let licenceNumber: String = naviController?.vehicleDetails?.licenseNumber != nil ? ("<par:LicenseNumber>" + (naviController?.vehicleDetails?.licenseNumber)! + "</par:LicenseNumber>\n") : "<par:LicenseNumber xsi:nil=\"true\" />\n"
        
        let make: String = naviController?.vehicleDetails?.vehicleMake != nil ? ("<par:Make>" + (naviController?.vehicleDetails?.vehicleMake)! + "</par:Make>\n") : "<par:Make xsi:nil=\"true\" />\n"
        
        let model: String = naviController?.vehicleDetails?.vehicleModel != nil ? ("<par:Model>" + (naviController?.vehicleDetails?.vehicleModel)! + "</par:Model>\n") : "<par:Model xsi:nil=\"true\" />\n"
        
        let year: String = naviController?.vehicleDetails?.vehicleYear != nil ? ("<par:Year>" + (naviController?.vehicleDetails?.vehicleYear)! + "</par:Year>\n") : "<par:Year xsi:nil=\"true\" />\n"
        
        let vehicleID: String = naviController?.vehicleDetails?.vehicleID != nil ? ("<par:VehicleID>" + (naviController?.vehicleDetails?.vehicleID)! + "</par:VehicleID>\n") : "<par:VehicleID>0</par:VehicleID>\n"
        
        let isOversizeVehicle = naviController?.vehicleDetails?.isOversized == true ? "true" : "false"
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:AddUpdateVehicle>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:vehicleinfo>\n"
            + color
            + customerProfileIDTag
            + "<par:FriendlyName xsi:nil=\"true\" />\n"
            + "<par:GuestCustomerID>0</par:GuestCustomerID>\n"
            + "<par:IsPrimary>false</par:IsPrimary>\n"
            + licenceNumber
            + make
            + "<par:Mileage xsi:nil=\"true\" />\n"
            + model
            + "<par:Oversized>" + isOversizeVehicle + "</par:Oversized>\n"
            + vehicleID
            + year
            + "</tem:vehicleinfo>\n"
            + customerProfileIDTem
            + "</tem:AddUpdateVehicle>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"AddUpdateVehicle")
    }
    
    /**
     This method will create AddUpdateVehicleService request for onlot.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func addUpdateVehicleInOnLotWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        let customerProfileID = naviController?.ticketBO?.customerProfileID
        let customerProfileIDTag = customerProfileID != nil ? ("<par:CustomerProfileID>" + customerProfileID! + "</par:CustomerProfileID>\n") : "<par:CustomerProfileID xsi:nil=\"true\" />\n"
        
        let customerProfileIDTem = customerProfileID != nil ? ("<tem:customerProfileID>" + customerProfileID! + "</tem:customerProfileID>\n") : "<tem:customerProfileID xsi:nil=\"true\" />\n"
        
        var vehicleColor:String?
        /*if naviController?.ticketBO?.color?.characters.count > 0 {
         vehicleColor = naviController?.ticketBO?.color
         }else */if naviController?.ticketBO?.vehicleDetails?.vehicleColor?.characters.count > 0 {
            vehicleColor = naviController?.ticketBO?.vehicleDetails?.vehicleColor
        }
        var vehicleMake: String?
        /*if naviController?.ticketBO?.make?.characters.count > 0 {
         vehicleMake = naviController?.ticketBO?.make
         }else */if naviController?.ticketBO?.vehicleDetails?.vehicleMake?.characters.count > 0 {
            vehicleMake = naviController?.ticketBO?.vehicleDetails?.vehicleMake
        }
        var vehicleModel: String?
        /*if naviController?.ticketBO?.model?.characters.count > 0 {
         vehicleModel = naviController?.ticketBO?.model
         } else */if naviController?.ticketBO?.vehicleDetails?.vehicleModel?.characters.count > 0 {
            vehicleModel = naviController?.ticketBO?.vehicleDetails?.vehicleModel
        }
        var vehicleYear: String?
        /*if naviController?.ticketBO?.year?.characters.count > 0 {
         vehicleYear = naviController?.ticketBO?.year
         }else */if naviController?.ticketBO?.vehicleDetails?.vehicleYear?.characters.count > 0 {
            vehicleYear = naviController?.ticketBO?.vehicleDetails?.vehicleYear
        }
        var vehicleTag : String?
        /*if naviController?.ticketBO?.licenseTag?.characters.count > 0 {
         vehicleTag = naviController?.ticketBO?.licenseTag
         }else */if naviController?.ticketBO?.vehicleDetails?.licenseNumber?.characters.count > 0 {
            vehicleTag = naviController?.ticketBO?.vehicleDetails?.licenseNumber
        }
        
        let color = vehicleColor != nil ? ("<par:Color>" + vehicleColor! + "</par:Color>\n") : "<par:Color xsi:nil=\"true\" />\n"
        
        let licenceNumber = vehicleTag != nil ? ("<par:LicenseNumber>" + vehicleTag! + "</par:LicenseNumber>\n") : "<par:LicenseNumber xsi:nil=\"true\" />\n"
        
        let make = vehicleMake != nil ? ("<par:Make>" + vehicleMake! + "</par:Make>\n") : "<par:Make xsi:nil=\"true\" />\n"
        
        let model = vehicleModel != nil ? ("<par:Model>" + vehicleModel! + "</par:Model>\n") : "<par:Model xsi:nil=\"true\" />\n"
        
        let year = vehicleYear != nil ? ("<par:Year>" + vehicleYear! + "</par:Year>\n") : "<par:Year xsi:nil=\"true\" />\n"
        
        let vehicleID = naviController?.ticketBO?.vehicleID != nil ? ("<par:VehicleID>" + (naviController?.ticketBO?.vehicleID)! + "</par:VehicleID>\n") : "<par:VehicleID>0</par:VehicleID>\n"
        
        let isOversizeVehicle = naviController?.ticketBO?.vehicleDetails?.isOversized == true ? "true" : "false"
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:AddUpdateVehicle>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:vehicleinfo>\n"
            + color
            + customerProfileIDTag
            + "<par:FriendlyName xsi:nil=\"true\" />\n"
            + "<par:GuestCustomerID>0</par:GuestCustomerID>\n"
            + "<par:IsPrimary>false</par:IsPrimary>\n"
            + licenceNumber
            + make
            + "<par:Mileage xsi:nil=\"true\" />\n"
            + model
            + "<par:Oversized>" + isOversizeVehicle + "</par:Oversized>\n"
            + vehicleID
            + year
            + "</tem:vehicleinfo>\n"
            + customerProfileIDTem
            + "</tem:AddUpdateVehicle>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"AddUpdateVehicle")
    }
    
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if dict.getObjectFromDictionary(withKeys: ["AddUpdateVehicleResponse","AddUpdateVehicleResult"]) != nil {
            
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
