//
//  GetVehicleInfoByVIN.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/23/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetVehicleInfoByVINService: GenericServiceManager {
    
    /**
     This method will create GetVehicleInfoByVIN request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func getVehicleInfoByVINService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        let ticketID = "0"
        let vin = parameters["VIN"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetVehicleInfoByVIN>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:VIN>" + vin + "</tem:VIN>"
            + "<tem:ticketID>" + ticketID + "</tem:ticketID>"
            + "</tem:GetVehicleInfoByVIN>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetVehicleInfoByVIN")
    }
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if dict.getStringFromDictionary(withKeys: ["GetVehicleInfoByVINResponse","GetVehicleInfoByVINResult","a:Status","a:ErrCode"]) == "0" {
            
            let vehicleDetailsDict: NSDictionary = dict.getObjectFromDictionary(withKeys: ["GetVehicleInfoByVINResponse","GetVehicleInfoByVINResult","a:Result"]) as! NSDictionary
            let vehicleDetailsBO: VehicleDetailsBO = VehicleDetailsBO()
            _ = vehicleDetailsBO.getVehicleDeails(vehicleDetailsDict)
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: vehicleDetailsBO)
            }
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate!.didFailedWithError!(self.identifier, errorMessage: dict.getStringFromDictionary(withKeys: ["GetVehicleInfoByVINResponse","GetVehicleInfoByVINResult","a:Status","a:Message"]))
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
