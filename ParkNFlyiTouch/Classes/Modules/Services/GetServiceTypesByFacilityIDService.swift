//
//  GetServiceTypesByFacilityIDService.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 12/2/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetServiceTypesByFacilityIDService: GenericServiceManager {
    /**
     This method will load all service category.
     
     :param: identifier NSString
     :param: parameters NSString
     :returns: Void returns nothing
     */
    func getServiceTypesByFacilityIDServiceWebservice(_ identifier: String) {
        self.identifier = identifier
        
        let connection = ConnectionManager()
        connection.delegate = self
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetServiceTypesByFacilityID/>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetServiceTypesByFacilityID")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if let allLocationArray: NSArray = dictionary.getObjectFromDictionary(withKeys: ["GetServiceTypesByFacilityIDResponse","GetServiceTypesByFacilityIDResult","a:Service"]) as? NSArray {
            
            var allServiceCategoryObjectArray:[ServiceCategoryBO] = []
            
            for (_,value) in allLocationArray.enumerated() {
                
                var getAllServiceBO = ServiceCategoryBO()
                getAllServiceBO = getAllServiceBO.getServiceTypesByFacilityIDFromDictionary(value as! NSDictionary)
                
                allServiceCategoryObjectArray.append(getAllServiceBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allServiceCategoryObjectArray as AnyObject)
            }
            
        } else if let allLocation = dictionary.getObjectFromDictionary(withKeys: ["GetServiceTypesByFacilityIDResponse","GetServiceTypesByFacilityIDResult","a:Service"]) {
            
            var allServiceCategoryObjectArray:[ServiceCategoryBO] = []
            
            var getAllServiceBO = ServiceCategoryBO()
            getAllServiceBO = getAllServiceBO.getServiceTypesByFacilityIDFromDictionary(allLocation as! NSDictionary)
            
            allServiceCategoryObjectArray.append(getAllServiceBO)
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allServiceCategoryObjectArray as AnyObject)
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
