//
//  GetDiscountsByBarcodeOrNameService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/31/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetDiscountsByBarcodeOrNameService: GenericServiceManager {
    
    /**
     This method will create GetDiscountsByBarcodeOrName request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getDiscountsByBarcodeOrNameWebservice(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        let discountNumber:String = parameters["DiscountCode"] as! String
        let parkingType: String = parameters["PARKINGTYPE"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetDiscountsByBarcodeOrName>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:searchValue>" + discountNumber + "</tem:searchValue>\n"
            + "<tem:parkingType>" + parkingType + "</tem:parkingType>\n"
            + "</tem:GetDiscountsByBarcodeOrName>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "GetDiscountsByBarcodeOrName")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        var discountsArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsByBarcodeOrNameResponse","GetDiscountsByBarcodeOrNameResult","a:DiscountInfo"]) != nil {
            
            let allDiscountsArray = dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsByBarcodeOrNameResponse","GetDiscountsByBarcodeOrNameResult","a:DiscountInfo"])
            
            if allDiscountsArray is NSArray {
                discountsArray = allDiscountsArray as! NSArray
            }else {
                let  discount = dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsByBarcodeOrNameResponse","GetDiscountsByBarcodeOrNameResult","a:DiscountInfo"])
                discountsArray = [discount]
            }
            
            var allDiscountsObjectArray:[DiscountInfoBO] = []
            
            for (_,value) in discountsArray.enumerated() {
                
                var discountsBO = DiscountInfoBO()
                discountsBO = discountsBO.getDiscountBOFromDictionary(value as! NSDictionary)
                allDiscountsObjectArray.append(discountsBO)
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: allDiscountsObjectArray as AnyObject)
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
