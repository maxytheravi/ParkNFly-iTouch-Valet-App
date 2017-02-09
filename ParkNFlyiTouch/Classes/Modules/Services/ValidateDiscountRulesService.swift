//
//  ValidateDiscountRules.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 1/6/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ValidateDiscountRulesService: GenericServiceManager {
    
    /**
     This method will create ValidateDiscountRules request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func validateDiscountRulesWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        let selectedDiscountArray = parameters["SelectedDiscountArray"]
        
        let soapMessage = self.validateDiscountRulesRequestXML(selectedDiscountArray as! NSArray)
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"ValidateDiscountRules")
    }
    
    func validateDiscountRulesRequestXML(_ selectedDiscountArray: NSArray) -> String {
        
        let updatedDateTime = (naviController?.updatedDate)! + "T" + (naviController?.updatedTime)!//"2015-11-30T13:17:23"
        let currentDateTime = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())//"2015-11-27T13:19:58"
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let validateDiscountXML: String = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:ValidateDiscountRules>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            //Discounts
            + self.createDiscountsRequestXML(selectedDiscountArray)
            + "<tem:fromDate>" + currentDateTime + "</tem:fromDate>\n"
            + "<tem:toDate>" + updatedDateTime + "</tem:toDate>\n"
            + "</tem:ValidateDiscountRules>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        return validateDiscountXML
        
    }
    func createDiscountsRequestXML(_ selectedDiscountArray: NSArray) -> String {
        
        var discountsXML: String = ""
        let discountsArray = selectedDiscountArray
        
        if discountsArray.count > 0 {
            discountsXML += "<tem:discounts>\n"
            discountsArray.enumerateObjects({ discountObj, index, stop in
                discountsXML += self.createDiscountRequestXML(discountObj as! DiscountInfoBO)
            })
            discountsXML += "</tem:discounts>\n"
        }else {
            discountsXML = "<tem:discounts />\n"
        }
        return discountsXML
    }
    func createDiscountRequestXML(_ discountInfoBO: DiscountInfoBO) -> String {
        
        let discountXML: String = "<par:DiscountInfo>\n"
            + "<par:ActualDays>" + discountInfoBO.actualDays! + "</par:ActualDays>\n"
            + "<par:ActualHours>" + discountInfoBO.actualHours! + "</par:ActualHours>\n"
            + "<par:AllDiscountParkingValue>" + discountInfoBO.allDiscountParkingValue! + "</par:AllDiscountParkingValue>\n"
            + "<par:AllDiscountServicesValue>" + discountInfoBO.allDiscountServicesValue! + "</par:AllDiscountServicesValue>\n"
            + "<par:AllowMultiple>" + "\(discountInfoBO.allowMultiple!)" + "</par:AllowMultiple>\n"
            + "<par:AppliedDate i:nil=\"true\">" + discountInfoBO.appliedDate! + "</par:AppliedDate>\n"
            + "<par:ArrivalDay i:nil=\"true\">" + /*discountInfoBO.arrivalDay!*/ "0" + "</par:ArrivalDay>\n" //arrival day should be int type ex. 0
            + "<par:CanCombine>" + discountInfoBO.canCombine! + "</par:CanCombine>\n"
            + "<par:ChannelID>" + discountInfoBO.channelID! + "</par:ChannelID>\n"
            + "<par:ChannelName>" + discountInfoBO.channelName! + "</par:ChannelName>\n"
            + "<par:CouponApply>" + discountInfoBO.couponApply! + "</par:CouponApply>\n"
            + "<par:CouponCode i:nil=\"true\">" + discountInfoBO.couponCode! + "</par:CouponCode>\n"
            + "<par:CouponExpirationDate i:nil=\"true\">" + discountInfoBO.couponExpirationDate! + "</par:CouponExpirationDate>\n"
            + "<par:DailyCharge>" + discountInfoBO.dailyCharge! + "</par:DailyCharge>\n"
            + "<par:DailyRate>" + discountInfoBO.dailyRate! + "</par:DailyRate>\n"
            + "<par:DiscountApplyTo>" + discountInfoBO.discountApplyTo! + "</par:DiscountApplyTo>\n"
            + "<par:DiscountCode>" + discountInfoBO.discountCode! + "</par:DiscountCode>\n"
            + "<par:DiscountDesc>" + discountInfoBO.discountDesc! + "</par:DiscountDesc>\n"
            + "<par:DiscountID>" + discountInfoBO.discountID! + "</par:DiscountID>\n"
            + "<par:DiscountName>" + discountInfoBO.discountName! + "</par:DiscountName>\n"
            + "<par:DiscountOrder i:nil=\"true\">" + discountInfoBO.discountOrder! + "</par:DiscountOrder>\n"
            + "<par:DiscountTypeID>" + discountInfoBO.discountTypeID! + "</par:DiscountTypeID>\n"
            + "<par:DiscountUnitID>" + discountInfoBO.discountUnitID! + "</par:DiscountUnitID>\n"
            + "<par:DiscountValue>" + discountInfoBO.discountValue! + "</par:DiscountValue>\n"
            + "<par:EndDate i:nil=\"true\">" + discountInfoBO.endDate! + "</par:EndDate>\n"
            + "<par:FreeDuration i:nil=\"true\">" + discountInfoBO.freeDuration! + "</par:FreeDuration>\n"
            + "<par:HourlyCharge>" + discountInfoBO.hourlyCharge! + "</par:HourlyCharge>\n"
            + "<par:HourlyRate>" + discountInfoBO.hourlyRate! + "</par:HourlyRate>\n"
            + "<par:IsActive>" + "\(discountInfoBO.isActive!)" + "</par:IsActive>\n"
            + "<par:IsCap>" + "\(discountInfoBO.isCap!)" + "</par:IsCap>\n"
            + "<par:IsCouponAlreadyUsed>" + "\(discountInfoBO.isCouponAlreadyUsed!)" + "</par:IsCouponAlreadyUsed>\n"
            + "<par:IsDiscountOnOverstay>" + "\(discountInfoBO.isDiscountOnOverstay!)" + "</par:IsDiscountOnOverstay>\n"
            + "<par:IsRequiredStayAll>" + "\(discountInfoBO.isRequiredStayAll!)" + "</par:IsRequiredStayAll>\n"
            + "<par:IsSelected>" + "\(discountInfoBO.isSelected!)" + "</par:IsSelected>\n"
            + "<par:IsValid>" + "\(discountInfoBO.isValid!)" + "</par:IsValid>\n"
            + "<par:MaxDuration i:nil=\"true\">" + "\(discountInfoBO.maxDuration!)" + "</par:MaxDuration>\n"
            + "<par:MaxDurationUnitID i:nil=\"true\">" + "\(discountInfoBO.maxDurationUnitID!)" + "</par:MaxDurationUnitID>\n"
            + "<par:MinDuration i:nil=\"true\">" + "\(discountInfoBO.minDuration!)" + "</par:MinDuration>\n"
            + "<par:MinDurationUnitID i:nil=\"true\">" + "\(discountInfoBO.minDurationUnitID!)" + "</par:MinDurationUnitID>\n"
            + "<par:MonthlyCharge>" + discountInfoBO.monthlyCharge! + "</par:MonthlyCharge>\n"
            + "<par:MonthlyRate>" + discountInfoBO.monthlyRate! + "</par:MonthlyRate>\n"
            + "<par:Occurance>" + discountInfoBO.occurance! + "</par:Occurance>\n"
            + "<par:ParkingTypeID>" + discountInfoBO.parkingTypeID! + "</par:ParkingTypeID>\n"
            + "<par:Quantity>" + discountInfoBO.quantity! + "</par:Quantity>\n"
            + "<par:RequiredStay i:nil=\"true\">" + discountInfoBO.requiredStay! + "</par:RequiredStay>\n"
            + "<par:ShowUpFront>" + discountInfoBO.showUpFront! + "</par:ShowUpFront>\n"
            + "<par:StartDate>" + discountInfoBO.startDate! + "</par:StartDate>\n"
            + "<par:TaxesExempted i:nil=\"true\">" + discountInfoBO.taxesExempted! + "</par:TaxesExempted>\n"
            + "<par:TotalCharge>" + discountInfoBO.totalCharge! + "</par:TotalCharge>\n"
            + "<par:TotalDiscount>" + discountInfoBO.totalDiscount! + "</par:TotalDiscount>\n"
            + "<par:UniqID>" + discountInfoBO.uniqID! + "</par:UniqID>\n"
            + "<par:ValidationID>" + discountInfoBO.validationID! + "</par:ValidationID>\n"
            + "<par:ValidationMessage i:nil=\"true\">" + discountInfoBO.validationMessage! + "</par:ValidationMessage>\n"
            + "<par:WeeklyCharge>" + discountInfoBO.weeklyCharge! + "</par:WeeklyCharge>\n"
            + "<par:WeeklyRate>" + discountInfoBO.weeklyRate! + "</par:WeeklyRate>\n"
            + "</par:DiscountInfo>\n"
        
        return discountXML
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        var discountsArray = NSArray()
        if dictionary.getObjectFromDictionary(withKeys: ["ValidateDiscountRulesResponse","ValidateDiscountRulesResult","a:Result","a:DiscountInfo"]) != nil {
            
            let allDiscountsArray = dictionary.getObjectFromDictionary(withKeys: ["ValidateDiscountRulesResponse","ValidateDiscountRulesResult","a:Result","a:DiscountInfo"])
            
            if allDiscountsArray is NSArray {
                discountsArray = allDiscountsArray as! NSArray
            }else {
                let  discount = dictionary.getObjectFromDictionary(withKeys: ["ValidateDiscountRulesResponse","ValidateDiscountRulesResult","a:Result","a:DiscountInfo"])
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
