//
//  DiscountInfoBO.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/29/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class DiscountInfoBO: NSObject {
    
    var actualDays:String?
    var actualHours:String?
    var allDiscountParkingValue:String?
    var allDiscountServicesValue:String?
    var allowMultiple:Bool?
    var appliedDate:String?
    var arrivalDay:String?
    var canCombine:String?
    var channelID:String?
    var channelName:String?
    var couponApply:String?
    var couponCode:String?
    var couponExpirationDate:String?
    var dailyCharge:String?
    var dailyRate:String?
    var discountApplyTo:String?
    var discountCode:String?
    var discountDesc:String?
    var discountID:String?
    var discountName:String?
    var discountOrder:String?
    var discountTypeID:String?
    var discountUnitID:String?
    var discountValue:String?
    var endDate:String?
    var freeDuration:String?
    var hourlyCharge:String?
    var hourlyRate:String?
    var isActive:Bool?
    var isCap:Bool?
    var isCouponAlreadyUsed:Bool?
    var isDiscountOnOverstay:Bool?
    var isRequiredStayAll:Bool?
    var isSelected:Bool?
    var isValid:Bool?
    var maxDuration:Bool?
    var maxDurationUnitID:Bool?
    var minDuration:Bool?
    var minDurationUnitID:Bool?
    var monthlyCharge:String?
    var monthlyRate:String?
    var occurance:String?
    var parkingTypeID:String?
    var quantity:String?
    var requiredStay:String?
    var showUpFront:String?
    var startDate:String?
    var taxesExempted:String?
    var totalCharge:String?
    var totalDiscount:String?
    var uniqID:String?
    var validationID:String?
    var validationMessage:String?
    var weeklyCharge:String?
    var weeklyRate:String?
    
    var isDiscountSelected:Bool = false//to keep track of selected discount
    var isSwitchOn:Bool = true//to keep track of switch states
    
    override init(){
        
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(actualDays, forKey: "actualDays")
        aCoder.encode(actualHours, forKey: "actualHours")
        aCoder.encode(allDiscountParkingValue, forKey: "allDiscountParkingValue")
        aCoder.encode(allDiscountServicesValue, forKey: "allDiscountServicesValue")
        if let _ = allowMultiple {
            aCoder.encode(allowMultiple!, forKey: "allowMultiple")
        }
        aCoder.encode(appliedDate,forKey: "appliedDate")
        aCoder.encode(arrivalDay,forKey: "arrivalDay")
        aCoder.encode(canCombine,forKey: "canCombine")
        aCoder.encode(channelID,forKey: "channelID")
        aCoder.encode(channelName,forKey: "channelName")
        aCoder.encode(couponApply,forKey: "couponApply")
        aCoder.encode(couponCode,forKey: "couponCode")
        aCoder.encode(couponExpirationDate,forKey: "couponExpirationDate")
        aCoder.encode(dailyCharge,forKey: "dailyCharge")
        aCoder.encode(dailyRate,forKey: "dailyRate")
        aCoder.encode(discountApplyTo,forKey: "discountApplyTo")
        aCoder.encode(discountCode,forKey: "discountCode")
        aCoder.encode(discountDesc,forKey: "discountDesc")
        aCoder.encode(discountID,forKey: "discountID")
        aCoder.encode(discountName,forKey: "discountName")
        aCoder.encode(discountOrder,forKey: "discountOrder")
        aCoder.encode(discountTypeID,forKey: "discountTypeID")
        aCoder.encode(discountUnitID,forKey: "discountUnitID")
        aCoder.encode(discountValue,forKey: "discountValue")
        aCoder.encode(endDate,forKey: "endDate")
        aCoder.encode(freeDuration,forKey: "freeDuration")
        aCoder.encode(hourlyCharge,forKey: "hourlyCharge")
        aCoder.encode(hourlyRate,forKey: "hourlyRate")
        if let _ = isActive {
            aCoder.encode(isActive!, forKey: "isActive")
        }
        if let _ = isCap {
            aCoder.encode(isCap!, forKey: "isCap")
        }
        if let _ = isCouponAlreadyUsed {
            aCoder.encode(isCouponAlreadyUsed!, forKey: "isCouponAlreadyUsed")
        }
        if let _ = isDiscountOnOverstay {
            aCoder.encode(isDiscountOnOverstay!, forKey: "isDiscountOnOverstay")
        }
        if let _ = isRequiredStayAll {
            aCoder.encode(isRequiredStayAll!, forKey: "isRequiredStayAll")
        }
        if let _ = isSelected {
            aCoder.encode(isSelected!, forKey: "isSelected")
        }
        if let _ = isValid {
            aCoder.encode(isValid!, forKey: "isValid")
        }
        if let _ = maxDuration {
            aCoder.encode(maxDuration!, forKey: "maxDuration")
        }
        if let _ = maxDurationUnitID {
            aCoder.encode(maxDurationUnitID!, forKey: "maxDurationUnitID")
        }
        if let _ = minDuration {
            aCoder.encode(minDuration!, forKey: "minDuration")
        }
        if let _ = minDurationUnitID {
            aCoder.encode(minDurationUnitID!, forKey: "minDurationUnitID")
        }
        aCoder.encode(monthlyCharge,forKey: "monthlyCharge")
        aCoder.encode(monthlyRate,forKey: "monthlyRate")
        aCoder.encode(occurance,forKey: "occurance")
        aCoder.encode(parkingTypeID,forKey: "parkingTypeID")
        aCoder.encode(quantity,forKey: "quantity")
        aCoder.encode(requiredStay,forKey: "requiredStay")
        aCoder.encode(showUpFront,forKey: "showUpFront")
        aCoder.encode(startDate,forKey: "startDate")
        aCoder.encode(taxesExempted,forKey: "taxesExempted")
        aCoder.encode(totalCharge,forKey: "totalCharge")
        aCoder.encode(totalDiscount,forKey: "totalDiscount")
        aCoder.encode(uniqID,forKey: "uniqID")
        aCoder.encode(validationID,forKey: "validationID")
        aCoder.encode(validationMessage,forKey: "validationMessage")
        aCoder.encode(weeklyCharge,forKey: "weeklyCharge")
        aCoder.encode(weeklyRate,forKey: "weeklyRate")
        
        aCoder.encode(isDiscountSelected, forKey: "isDiscountSelected")
        aCoder.encode(isSwitchOn, forKey: "isSwitchOn")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.actualDays = aDecoder.decodeObject(forKey: "actualDays") as? String
        self.actualHours = aDecoder.decodeObject(forKey: "actualHours") as? String
        self.allDiscountParkingValue = aDecoder.decodeObject(forKey: "allDiscountParkingValue") as? String
        self.allDiscountServicesValue = aDecoder.decodeObject(forKey: "allDiscountServicesValue") as? String
        self.allowMultiple = aDecoder.decodeBool(forKey: "allowMultiple")
        self.appliedDate = aDecoder.decodeObject(forKey: "appliedDate") as? String
        self.arrivalDay = aDecoder.decodeObject(forKey: "arrivalDay") as? String
        self.canCombine = aDecoder.decodeObject(forKey: "canCombine") as? String
        self.channelID = aDecoder.decodeObject(forKey: "channelID") as? String
        self.channelName = aDecoder.decodeObject(forKey: "channelName") as? String
        self.couponApply = aDecoder.decodeObject(forKey: "couponApply") as? String
        self.couponCode = aDecoder.decodeObject(forKey: "couponCode") as? String
        self.couponExpirationDate = aDecoder.decodeObject(forKey: "couponExpirationDate") as? String
        self.dailyCharge = aDecoder.decodeObject(forKey: "dailyCharge") as? String
        self.dailyRate = aDecoder.decodeObject(forKey: "dailyRate") as? String
        self.discountApplyTo = aDecoder.decodeObject(forKey: "discountApplyTo") as? String
        self.discountCode = aDecoder.decodeObject(forKey: "discountCode") as? String
        self.discountDesc = aDecoder.decodeObject(forKey: "discountDesc") as? String
        self.discountID = aDecoder.decodeObject(forKey: "discountID") as? String
        self.discountName = aDecoder.decodeObject(forKey: "discountName") as? String
        self.discountOrder = aDecoder.decodeObject(forKey: "discountOrder") as? String
        self.discountTypeID = aDecoder.decodeObject(forKey: "discountTypeID") as? String
        self.discountUnitID = aDecoder.decodeObject(forKey: "discountUnitID") as? String
        self.discountValue = aDecoder.decodeObject(forKey: "discountValue") as? String
        self.endDate = aDecoder.decodeObject(forKey: "endDate") as? String
        self.freeDuration = aDecoder.decodeObject(forKey: "freeDuration") as? String
        self.hourlyCharge = aDecoder.decodeObject(forKey: "hourlyCharge") as? String
        self.hourlyRate = aDecoder.decodeObject(forKey: "hourlyRate") as? String
        
        self.isActive = aDecoder.decodeBool(forKey: "isActive")
        self.isCap = aDecoder.decodeBool(forKey: "isCap")
        self.isCouponAlreadyUsed = aDecoder.decodeBool(forKey: "isCouponAlreadyUsed")
        self.isDiscountOnOverstay = aDecoder.decodeBool(forKey: "isDiscountOnOverstay")
        self.isRequiredStayAll = aDecoder.decodeBool(forKey: "isRequiredStayAll")
        self.isSelected = aDecoder.decodeBool(forKey: "isSelected")
        self.isValid = aDecoder.decodeBool(forKey: "isValid")
        self.maxDuration = aDecoder.decodeBool(forKey: "maxDuration")
        self.maxDurationUnitID = aDecoder.decodeBool(forKey: "maxDurationUnitID")
        self.minDuration = aDecoder.decodeBool(forKey: "minDuration")
        self.minDurationUnitID = aDecoder.decodeBool(forKey: "minDurationUnitID")
        
        self.monthlyCharge = aDecoder.decodeObject(forKey: "monthlyCharge") as? String
        self.monthlyRate = aDecoder.decodeObject(forKey: "monthlyRate") as? String
        self.occurance = aDecoder.decodeObject(forKey: "occurance") as? String
        self.parkingTypeID = aDecoder.decodeObject(forKey: "parkingTypeID") as? String
        self.quantity = aDecoder.decodeObject(forKey: "quantity") as? String
        self.requiredStay = aDecoder.decodeObject(forKey: "requiredStay") as? String
        self.showUpFront = aDecoder.decodeObject(forKey: "showUpFront") as? String
        self.startDate = aDecoder.decodeObject(forKey: "startDate") as? String
        self.taxesExempted = aDecoder.decodeObject(forKey: "taxesExempted") as? String
        self.totalCharge = aDecoder.decodeObject(forKey: "totalCharge") as? String
        self.totalDiscount = aDecoder.decodeObject(forKey: "totalDiscount") as? String
        self.uniqID = aDecoder.decodeObject(forKey: "uniqID") as? String
        self.validationID = aDecoder.decodeObject(forKey: "validationID") as? String
        self.validationMessage = aDecoder.decodeObject(forKey: "validationMessage") as? String
        self.weeklyCharge = aDecoder.decodeObject(forKey: "weeklyCharge") as? String
        self.weeklyRate = aDecoder.decodeObject(forKey: "weeklyRate") as? String
        
        self.isDiscountSelected = aDecoder.decodeBool(forKey: "isDiscountSelected")
        self.isSwitchOn = aDecoder.decodeBool(forKey: "isSwitchOn")
    }
    
    func deepCopyOfDiscountInfoBO() -> DiscountInfoBO {
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        let discountInfoBO: DiscountInfoBO = (NSKeyedUnarchiver.unarchiveObject(with: data) as! DiscountInfoBO)
        
        return discountInfoBO
    }
    
    func getDiscountBOFromDictionary(_ attributeDict: NSDictionary) -> DiscountInfoBO {
        
        self.actualDays = attributeDict.getInnerText(forKey: "a:ActualDays")
        self.actualHours = attributeDict.getInnerText(forKey: "a:ActualHours")
        self.allDiscountParkingValue = attributeDict.getInnerText(forKey: "a:AllDiscountParkingValue")
        self.allDiscountServicesValue = attributeDict.getInnerText(forKey: "a:AllDiscountServicesValue")
        self.allowMultiple = attributeDict.getBoolFromDictionary(withKeys: ["a:AllowMultiple"])
        self.appliedDate = Utility.getFormatedDateTimeWithT(attributeDict.getAttributedData(forKey: "a:AppliedDate"))
        self.arrivalDay = attributeDict.getAttributedData(forKey: "a:ArrivalDay")
        self.canCombine = attributeDict.getInnerText(forKey: "a:CanCombine")
        self.channelID = attributeDict.getInnerText(forKey: "a:ChannelID")
        self.channelName = attributeDict.getInnerText(forKey: "a:ChannelName")
        self.couponApply = attributeDict.getInnerText(forKey: "a:CouponApply")
        self.couponCode = attributeDict.getAttributedData(forKey: "a:CouponCode")
        self.couponExpirationDate = Utility.getFormatedDateTimeWithT(attributeDict.getAttributedData(forKey: "a:CouponExpirationDate"))
        self.dailyCharge = attributeDict.getInnerText(forKey: "a:DailyCharge")
        self.dailyRate = attributeDict.getInnerText(forKey: "a:DailyRate")
        self.discountApplyTo = attributeDict.getInnerText(forKey: "a:DiscountApplyTo")
        self.discountCode = attributeDict.getInnerText(forKey: "a:DiscountCode")
        self.discountDesc = attributeDict.getInnerText(forKey: "a:DiscountDesc")
        self.discountID = attributeDict.getInnerText(forKey: "a:DiscountID")
        self.discountName = attributeDict.getInnerText(forKey: "a:DiscountName")
        self.discountOrder = attributeDict.getAttributedData(forKey: "a:DiscountOrder")
        self.discountTypeID = attributeDict.getInnerText(forKey: "a:DiscountTypeID")
        self.discountUnitID = attributeDict.getInnerText(forKey: "a:DiscountUnitID")
        self.discountValue = attributeDict.getInnerText(forKey: "a:DiscountValue")
        self.endDate = Utility.getFormatedDateTimeWithT(attributeDict.getAttributedData(forKey: "a:EndDate"))
        self.freeDuration = attributeDict.getInnerText(forKey: "a:FreeDuration")
        self.hourlyCharge = attributeDict.getInnerText(forKey: "a:HourlyCharge")
        self.hourlyRate = attributeDict.getInnerText(forKey: "a:HourlyRate")
        self.isActive = attributeDict.getBoolFromDictionary(withKeys: ["a:IsActive"])
        self.isCap = attributeDict.getBoolFromDictionary(withKeys: ["a:IsCap"])
        self.isCouponAlreadyUsed = attributeDict.getBoolFromDictionary(withKeys: ["a:IsCouponAlreadyUsed"])
        self.isDiscountOnOverstay = attributeDict.getBoolFromDictionary(withKeys: ["a:IsDiscountOnOverstay"])
        self.isRequiredStayAll = attributeDict.getBoolFromDictionary(withKeys: ["a:IsRequiredStayAll"])
        self.isSelected = attributeDict.getBoolFromDictionary(withKeys: ["a:IsSelected"])
        self.isValid = attributeDict.getBoolFromDictionary(withKeys: ["a:IsValid"])
        self.maxDuration = attributeDict.getBoolFromDictionary(withKeys: ["a:MaxDuration"])
        self.maxDurationUnitID = attributeDict.getBoolFromDictionary(withKeys: ["a:MaxDurationUnitID"])
        self.minDuration = attributeDict.getBoolFromDictionary(withKeys: ["a:MinDuration"])
        self.minDurationUnitID = attributeDict.getBoolFromDictionary(withKeys: ["a:MinDurationUnitID"])
        self.monthlyCharge = attributeDict.getInnerText(forKey: "a:MonthlyCharge")
        self.monthlyRate = attributeDict.getInnerText(forKey: "a:MonthlyRate")
        self.occurance = attributeDict.getInnerText(forKey: "a:Occurance")
        self.parkingTypeID = attributeDict.getInnerText(forKey: "a:ParkingTypeID")
        self.quantity = attributeDict.getInnerText(forKey: "a:Quantity")
        self.requiredStay = attributeDict.getAttributedData(forKey: "a:RequiredStay")
        self.showUpFront = attributeDict.getInnerText(forKey: "a:ShowUpFront")
        self.startDate = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:StartDate"))
        self.taxesExempted = attributeDict.getAttributedData(forKey: "a:TaxesExempted")
        self.totalCharge = attributeDict.getInnerText(forKey: "a:TotalCharge")
        self.totalDiscount = attributeDict.getInnerText(forKey: "a:TotalDiscount")
        self.uniqID = attributeDict.getInnerText(forKey: "a:UniqID")
        self.validationID = attributeDict.getInnerText(forKey: "a:ValidationID")
        self.validationMessage = attributeDict.getInnerText(forKey: "a:ValidationMessage")
        self.weeklyCharge = attributeDict.getInnerText(forKey: "a:WeeklyCharge")
        self.weeklyRate = attributeDict.getInnerText(forKey: "a:WeeklyRate")
        
        return self
    }
}
