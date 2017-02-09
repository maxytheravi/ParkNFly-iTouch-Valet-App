//
//  GetDiscountsAssociatedWithLoyaltyService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 1/8/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetDiscountsAssociatedWithLoyaltyService: GenericServiceManager {
    
    /**
     This method will create GetDiscountsAssociatedWithLoyalty request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getDiscountsAssociatedWithLoyaltyWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        let parkingType: String = parameters["PARKINGTYPE"] as! String
        let discountNumber:String = parameters["DiscountCode"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetDiscountsAssociatedWithLoyalty>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:loyaltyNumber>" + discountNumber + "</tem:loyaltyNumber>\n"
            + "<tem:parkingType>" + parkingType + "</tem:parkingType>\n"
            + "<tem:fromDate i:nil=\"true\" />\n"
            + "<tem:toDate i:nil=\"true\" />\n"
            + "<tem:discounts />\n"
            + "</tem:GetDiscountsAssociatedWithLoyalty>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "GetDiscountsAssociatedWithLoyalty")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        var discountsArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsAssociatedWithLoyaltyResponse","GetDiscountsAssociatedWithLoyaltyResult","a:Result","a:DiscountInfo"]) != nil {
            
            let allDiscountsArray = dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsAssociatedWithLoyaltyResponse","GetDiscountsAssociatedWithLoyaltyResult","a:Result","a:DiscountInfo"])
            
            if allDiscountsArray is NSArray {
                discountsArray = allDiscountsArray as! NSArray
            }else {
                let  discount = dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsAssociatedWithLoyaltyResponse","GetDiscountsAssociatedWithLoyaltyResult","a:Result","a:DiscountInfo"])
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
