//
//  GetVehicleInfomationService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 3/17/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetVehicleInfomationService: GenericServiceManager {
    
    /**
     This method will create GetVehicleInfomation request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getVehicleInfomationWebservice(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        let customerProfileID = (naviController?.reservationDetails?.customerProfileID)! as String
        let fpCardNo = (naviController?.reservationDetails?.fpCardNo)! as String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetVehicleInfomation>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:PersonID>" + customerProfileID + "</tem:PersonID>\n"
            + "<tem:reservationCode></tem:reservationCode>\n"
            + "<tem:fpCode>" + fpCardNo + "</tem:fpCode>\n"
            + "</tem:GetVehicleInfomation>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "GetVehicleInfomation")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        var vehicleArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["GetVehicleInfomationResponse","GetVehicleInfomationResult","a:PersonVehicleInfo"]) != nil {
            
            let allvehicleArray = dictionary.getObjectFromDictionary(withKeys: ["GetVehicleInfomationResponse","GetVehicleInfomationResult","a:PersonVehicleInfo"])
            
            if allvehicleArray is NSArray {
                vehicleArray = allvehicleArray as! NSArray
            }else {
                let vehilce = dictionary.getObjectFromDictionary(withKeys: ["GetVehicleInfomationResponse","GetVehicleInfomationResult","a:PersonVehicleInfo"])
                vehicleArray = [vehilce]
            }
            
            var allVehicleObjectArray:[VehicleDetailsBO] = []
            
            for (_,value) in vehicleArray.enumerated() {
                
                var vehicleDetailsBO = VehicleDetailsBO()
                vehicleDetailsBO = vehicleDetailsBO.getVehicleDeailsFromFP(value as! NSDictionary)
                allVehicleObjectArray.append(vehicleDetailsBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allVehicleObjectArray as AnyObject)
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
