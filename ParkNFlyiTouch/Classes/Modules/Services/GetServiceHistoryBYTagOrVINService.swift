//
//  GetServiceHistoryBYTagOrVINService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/4/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetServiceHistoryBYTagOrVINService: GenericServiceManager {
    
    /**
     This method will create GetServiceHistoryBYTagOrVIN request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func getServiceHistoryBYTagOrVINWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        let licenceTagOrVINNumber = parameters["VIN/Tag"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetServiceHistoryBYTagOrVIN>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:tagOrVIN>" + licenceTagOrVINNumber + "</tem:tagOrVIN>\n"
            + "</tem:GetServiceHistoryBYTagOrVIN>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetServiceHistoryBYTagOrVIN")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        var serviceHistoryArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["GetServiceHistoryBYTagOrVINResponse","GetServiceHistoryBYTagOrVINResult","a:ServiceHistoryBYTagOrVIN"]) != nil {
            
            let allServiceHistoryArray = dictionary.getObjectFromDictionary(withKeys: ["GetServiceHistoryBYTagOrVINResponse","GetServiceHistoryBYTagOrVINResult","a:ServiceHistoryBYTagOrVIN"])
            
            if allServiceHistoryArray is NSArray {
                serviceHistoryArray = allServiceHistoryArray as! NSArray
            }else {
                let  serviceHistory = dictionary.getObjectFromDictionary(withKeys: ["GetServiceHistoryBYTagOrVINResponse","GetServiceHistoryBYTagOrVINResult","a:ServiceHistoryBYTagOrVIN"])
                serviceHistoryArray = [serviceHistory]
            }
            
            var allServiceHistoryObjectArray:[ServiceHistoryBO] = []
            
            for (_,value) in serviceHistoryArray.enumerated() {
                
                var serviceHistoryBO = ServiceHistoryBO()
                serviceHistoryBO = serviceHistoryBO.getServiceHistoryBOFromDictionary(value as! NSDictionary)
                allServiceHistoryObjectArray.append(serviceHistoryBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allServiceHistoryObjectArray as AnyObject)
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
