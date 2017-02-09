//
//  GetDiscountsFromClubCodeService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/31/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetDiscountsFromClubCodeService: GenericServiceManager {
    
    /**
     This method will create GetDiscountsFromClubCode request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getDiscountsFromClubCodeWebservice(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        let discountNumber:String = parameters["DiscountCode"] as! String
        let clubcode = discountNumber.substring(with: Range<String.Index>(discountNumber.characters.index(discountNumber.startIndex, offsetBy: 3) ..< discountNumber.characters.index(discountNumber.endIndex, offsetBy: -10)))
        
        let parkingType: String = parameters["PARKINGTYPE"] as! String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetDiscountsFromClubCode>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:clubCode>" + clubcode + "</tem:clubCode>\n"
            + "<tem:parkingType>" + parkingType + "</tem:parkingType>\n"
            + "</tem:GetDiscountsFromClubCode>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "GetDiscountsFromClubCode")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        var discountsArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsFromClubCodeResponse","GetDiscountsFromClubCodeResult","a:DiscountInfo"]) != nil {
            
            let allDiscountsArray = dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsFromClubCodeResponse","GetDiscountsFromClubCodeResult","a:DiscountInfo"])
            
            if allDiscountsArray is NSArray {
                discountsArray = allDiscountsArray as! NSArray
            }else {
                let  discount = dictionary.getObjectFromDictionary(withKeys: ["GetDiscountsFromClubCodeResponse","GetDiscountsFromClubCodeResult","a:DiscountInfo"])
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
