//
//  GetProductSetAddonTypeService.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 12/2/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetProductSetAddonTypeService: GenericServiceManager {
    
    func getProductSetAddonTypeWebService(_ identifier: String, parameters: NSDictionary) {
        self.identifier = identifier
        
        let connection = ConnectionManager()
        connection.delegate = self
        
        let serviceTypeID = parameters["ServiceTypeID"]! as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetProductSetAddonType>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:servicetypeid>" + serviceTypeID + "</tem:servicetypeid>"
            + "</tem:GetProductSetAddonType>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetProductSetAddonType")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        var allServiceCategoryObjectArray:[ServiceBO] = []
        
        if (dictionary.getObjectFromDictionary(withKeys: ["GetProductSetAddonTypeResponse","GetProductSetAddonTypeResult","a:AddService"]) as AnyObject) is NSArray {
            
            //dictionary of array
            let allServiceForSelectedCategory = dictionary.getObjectFromDictionary(withKeys: ["GetProductSetAddonTypeResponse","GetProductSetAddonTypeResult","a:AddService"]) as! NSArray
            
            for (_,value) in allServiceForSelectedCategory.enumerated() {
                
                var serviceBO = ServiceBO()
                serviceBO = serviceBO.getServiceBOFromDictionary(value as! NSDictionary)
                
                allServiceCategoryObjectArray.append(serviceBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allServiceCategoryObjectArray as AnyObject)
            }
            
        }else if (dictionary.getObjectFromDictionary(withKeys: ["GetProductSetAddonTypeResponse","GetProductSetAddonTypeResult","a:AddService"]) as AnyObject) is NSDictionary {
            //single dictionary
            
            let serviceForSelectedCategory: NSDictionary = dictionary.getObjectFromDictionary(withKeys: ["GetProductSetAddonTypeResponse","GetProductSetAddonTypeResult","a:AddService"]) as! NSDictionary
            
            var serviceBO:ServiceBO = ServiceBO()
            serviceBO = serviceBO.getServiceBOFromDictionary(serviceForSelectedCategory)
            
            allServiceCategoryObjectArray.append(serviceBO)
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: allServiceCategoryObjectArray as AnyObject)
            }
        }else {
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
