//
//  GetVehicleMake.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/14/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetVehicleMakeService: GenericServiceManager {
    /**
     This method will create GetVehicleMake request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getVehicleMakeWebservice(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:getVehicleMake>\n"
            + "<tem:FacilityCode></tem:FacilityCode>\n"
            + "<tem:DeviceCode></tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "</tem:getVehicleMake>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "getVehicleMake")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if ((dictionary.getObjectFromDictionary(withKeys: ["getVehicleMakeResponse","getVehicleMakeResult","a:VehicleMake"]) as AnyObject).count > 0) {
            
            let getVehicleMakeArray = dictionary.getObjectFromDictionary(withKeys: ["getVehicleMakeResponse", "getVehicleMakeResult", "a:VehicleMake"]) as! NSArray
            
            var getvehicleArray:[VehicleMakeBO] = []
            
            for (_,value) in getVehicleMakeArray.enumerated() {
                var vehicleMakeBO = VehicleMakeBO()
                vehicleMakeBO = vehicleMakeBO.getVehicleMakeBOFromDictionary(value as! NSDictionary)
                getvehicleArray.append(vehicleMakeBO)
            }
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: getvehicleArray as AnyObject)
            }
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

