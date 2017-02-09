//
//  ServiceBO.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/20/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ServiceBO: NSObject {
    
    var allowMultiple:Bool?
    var allowOverSize:Bool?
    var appliedDate:String?
    var cashierUserName: String?
    var discountedServiceCharge:Double?
    var facilityID:Int?
    var finalServiceDiscount:Double?
    var isEnabled:Bool?
    var isOverSizeChargeApplicable:Bool?
    var isSelected:Bool?
    var isTaxable:Bool?
    var isVariablePrice:Bool?
    var oversizeCharge:Double?
    var quantifiable:Bool?
    var quantity:Int?
    var serviceCharge:Double?
    var serviceCode:String?
    var serviceCompleted:String?
    var serviceDate:String?
    var serviceDesc:String?
    var serviceID:Int?
    var serviceName:String?
    var serviceNotes:String?
    var serviceTechnician: String?
    var serviceTypeID:Int?
    var taxes:Double?
    var totalServiceCharge:Double?
    var totalServiceDiscount:Double?
    var variableServiceCharge:Double?
    
    var isServiceSelected:Bool = false//to keep track of selected service
    var isSwitchOn:Bool = true//to keep track of switch states
    
    override init(){
        
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        
        if let _ = allowMultiple {
            aCoder.encode(allowMultiple!, forKey: "allowMultiple")
        }
        
        if let _ = allowOverSize {
            aCoder.encode(allowOverSize!, forKey: "allowOverSize")
        }
        
        aCoder.encode(appliedDate!, forKey: "appliedDate")
        aCoder.encode(cashierUserName, forKey: "a:CashierUserName")
        aCoder.encode(discountedServiceCharge!, forKey: "discountedServiceCharge")
        aCoder.encode(facilityID!, forKey: "facilityID")
        aCoder.encode(finalServiceDiscount!, forKey: "finalServiceDiscount")
        
        if let _ = isEnabled {
            aCoder.encode(isEnabled!, forKey: "isEnabled")
        }
        if let _ = isOverSizeChargeApplicable {
            aCoder.encode(isOverSizeChargeApplicable!, forKey: "isOverSizeChargeApplicable")
        }
        if let _ = isSelected {
            aCoder.encode(isSelected!, forKey: "isSelected")
        }
        if let _ = isTaxable {
            aCoder.encode(isTaxable!, forKey: "isTaxable")
        }
        if let _ = isVariablePrice {
            aCoder.encode(isVariablePrice!, forKey: "isVariablePrice")
        }
        
        aCoder.encode(oversizeCharge!, forKey: "oversizeCharge")
        
        if let _ = quantifiable {
            aCoder.encode(quantifiable!, forKey: "quantifiable")
        }
        
        aCoder.encode(quantity!, forKey: "quantity")
        aCoder.encode(serviceCharge!, forKey: "serviceCharge")
        aCoder.encode(serviceCode, forKey: "serviceCode")
        
        if let _ = serviceCompleted {
            aCoder.encode(serviceCompleted!, forKey: "serviceCompleted")
        }
        aCoder.encode(serviceDate, forKey: "serviceDate")
        aCoder.encode(serviceDesc, forKey: "serviceDesc")
        aCoder.encode(serviceID!, forKey: "serviceID")
        aCoder.encode(serviceName,forKey: "serviceName")
        aCoder.encode(serviceNotes,forKey: "serviceNotes")
        aCoder.encode(serviceTechnician, forKey: "serviceTechnician")
        aCoder.encode(serviceTypeID!, forKey: "serviceTypeID")
        
        aCoder.encode(taxes!, forKey: "taxes")
        aCoder.encode(totalServiceCharge!, forKey: "totalServiceCharge")
        aCoder.encode(totalServiceDiscount!, forKey: "totalServiceDiscount")
        aCoder.encode(variableServiceCharge!, forKey: "variableServiceCharge")
        
        aCoder.encode(isServiceSelected, forKey: "isServiceSelected")
        aCoder.encode(isSwitchOn, forKey: "isSwitchOn")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.allowMultiple = aDecoder.decodeBool(forKey: "allowMultiple")
        self.allowOverSize = aDecoder.decodeBool(forKey: "allowOverSize")
        self.appliedDate = aDecoder.decodeObject(forKey: "appliedDate") as? String
        self.cashierUserName = aDecoder.decodeObject(forKey: "cashierUserName") as? String
        self.discountedServiceCharge = aDecoder.decodeDouble(forKey: "discountedServiceCharge")
        self.facilityID = aDecoder.decodeInteger(forKey: "facilityID")
        self.finalServiceDiscount = aDecoder.decodeDouble(forKey: "finalServiceDiscount")
        self.isEnabled = aDecoder.decodeBool(forKey: "isEnabled")
        self.isOverSizeChargeApplicable = aDecoder.decodeBool(forKey: "isOverSizeChargeApplicable")
        self.isSelected = aDecoder.decodeBool(forKey: "isSelected")
        self.isTaxable = aDecoder.decodeBool(forKey: "isTaxable")
        self.isVariablePrice = aDecoder.decodeBool(forKey: "isVariablePrice")
        self.oversizeCharge = aDecoder.decodeDouble(forKey: "oversizeCharge")
        self.quantifiable = aDecoder.decodeBool(forKey: "quantifiable")
        self.quantity = aDecoder.decodeInteger(forKey: "quantity")
        self.serviceCharge = aDecoder.decodeDouble(forKey: "serviceCharge")
        self.serviceCode = aDecoder.decodeObject(forKey: "serviceCode") as? String
        self.serviceDesc = aDecoder.decodeObject(forKey: "serviceDesc") as? String
        self.serviceCompleted = aDecoder.decodeObject(forKey: "serviceCompleted") as? String
        self.serviceDate = aDecoder.decodeObject(forKey: "serviceDate") as? String
        self.serviceID = aDecoder.decodeInteger(forKey: "serviceID")
        self.serviceName = aDecoder.decodeObject(forKey: "serviceName") as? String
        self.serviceNotes = aDecoder.decodeObject(forKey: "serviceNotes") as? String
        self.serviceTechnician = aDecoder.decodeObject(forKey: "serviceTechnician") as? String
        self.serviceTypeID = aDecoder.decodeInteger(forKey: "serviceTypeID")
        self.taxes = aDecoder.decodeDouble(forKey: "taxes")
        self.totalServiceCharge = aDecoder.decodeDouble(forKey: "totalServiceCharge")
        self.totalServiceDiscount = aDecoder.decodeDouble(forKey: "totalServiceDiscount")
        self.variableServiceCharge = aDecoder.decodeDouble(forKey: "variableServiceCharge")
        
        self.isServiceSelected = aDecoder.decodeBool(forKey: "isServiceSelected")
        self.isSwitchOn = aDecoder.decodeBool(forKey: "isSwitchOn")
    }
    
    func deepCopyOfServiceBO() -> ServiceBO {
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        let serviceBO: ServiceBO = (NSKeyedUnarchiver.unarchiveObject(with: data) as! ServiceBO)
        
        return serviceBO
    }
    
    func getServiceBOFromDictionary(_ attributeDict: NSDictionary) -> ServiceBO {
        
        self.allowMultiple = attributeDict.getBoolFromDictionary(withKeys: ["a:AllowMultiple"])
        self.allowOverSize = attributeDict.getBoolFromDictionary(withKeys: ["a:AllowOverSize"])
        self.appliedDate = attributeDict.getInnerText(forKey: "a:AppliedDate")
        self.cashierUserName = attributeDict.getInnerText(forKey: "a:CashierUserName")
        self.discountedServiceCharge = attributeDict.getDoubleFromDictionary(withKeys: ["a:DiscountedServiceCharge"])
        self.facilityID = attributeDict.getIntegerFromDictionary(withKeys: ["a:FacilityID"])
        self.finalServiceDiscount = attributeDict.getDoubleFromDictionary(withKeys: ["a:FinalServiceDiscount"])
        self.isEnabled = attributeDict.getBoolFromDictionary(withKeys: ["a:IsEnabled"])
        self.isOverSizeChargeApplicable = attributeDict.getBoolFromDictionary(withKeys: ["a:IsOverSizeChargeApplicable"])
        self.isSelected = attributeDict.getBoolFromDictionary(withKeys: ["a:IsSelected"])
        self.isTaxable = attributeDict.getBoolFromDictionary(withKeys: ["a:IsTaxable"])
        self.isVariablePrice = attributeDict.getBoolFromDictionary(withKeys: ["a:IsVariablePrice"])
        self.oversizeCharge = attributeDict.getDoubleFromDictionary(withKeys: ["a:OversizeCharge"])
        self.quantifiable = attributeDict.getBoolFromDictionary(withKeys: ["a:Quantifiable"])
        self.quantity = attributeDict.getIntegerFromDictionary(withKeys: ["a:Quantity"])
        self.serviceCharge = attributeDict.getDoubleFromDictionary(withKeys: ["a:ServiceCharge"])
        self.serviceCode = attributeDict.getInnerText(forKey: "a:ServiceCode")
        self.serviceDesc = attributeDict.getInnerText(forKey: "a:ServiceDesc")
        self.serviceCompleted = attributeDict.getInnerText(forKey: "a:ServiceCompleted")
        self.serviceDate = attributeDict.getInnerText(forKey: "a:ServiceDate")
        self.serviceID = attributeDict.getIntegerFromDictionary(withKeys: ["a:ServiceID"])
        self.serviceName = attributeDict.getInnerText(forKey: "a:ServiceName")
        self.serviceNotes = attributeDict.getInnerText(forKey: "a:ServiceNotes")
        self.serviceTechnician = attributeDict.getInnerText(forKey: "a:ServiceTechnician")
        self.serviceTypeID = attributeDict.getIntegerFromDictionary(withKeys: ["a:ServiceTypeID"])
        self.taxes = attributeDict.getDoubleFromDictionary(withKeys: ["a:Taxes"])
        self.totalServiceCharge = attributeDict.getDoubleFromDictionary(withKeys: ["a:TotalServiceCharge"])
        self.totalServiceDiscount = attributeDict.getDoubleFromDictionary(withKeys: ["a:TotalServiceDiscount"])
        self.variableServiceCharge = attributeDict.getDoubleFromDictionary(withKeys: ["a:VariableServiceCharge"])
        
        return self
    }
}
