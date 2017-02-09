//
//  ServiceCategoryBO.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/30/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ServiceCategoryBO: NSObject {
    
    var allowOverSize:Bool?
    var houseAccountServices:String?
    var isActive:Bool?
    var isTaxable:Bool?
    var isVariablePrice:Bool?
    var oversizeCharge:Bool?
    var quantifiable:Bool?
    var saleServiceDiscounts:String?
    var saleServiceTaxes:String?
    var saleServices:String?
    var serviceCharge:Int?
    var serviceCode:Bool?
    var serviceDesc:Bool?
    var serviceID:Int?
    var serviceName:Bool?
    var serviceTypeID:Int?
    var serviceTypeName:String?
    var ticketServices:String?

    var isOn:Bool?
    
    func getServiceTypesByFacilityIDFromDictionary(_ attributeDict: NSDictionary) -> ServiceCategoryBO {
        
        self.allowOverSize = attributeDict.getBoolFromDictionary(withKeys: ["a:_AllowOverSize"])
        self.houseAccountServices = attributeDict.getInnerText(forKey: "a:_HouseAccountServices")
        self.isActive = attributeDict.getBoolFromDictionary(withKeys: ["a:_IsActive"])
        self.isTaxable = attributeDict.getBoolFromDictionary(withKeys: ["a:_IsTaxable"])
        self.isVariablePrice = attributeDict.getBoolFromDictionary(withKeys: ["a:_IsVariablePrice"])
        self.oversizeCharge = attributeDict.getBoolFromDictionary(withKeys: ["a:_OversizeCharge"])
        self.quantifiable = attributeDict.getBoolFromDictionary(withKeys: ["a:_Quantifiable"])
        self.saleServiceDiscounts = attributeDict.getInnerText(forKey: "a:_SaleServiceDiscounts")
        self.saleServiceTaxes = attributeDict.getInnerText(forKey: "a:_SaleServiceTaxes")
        self.saleServices = attributeDict.getInnerText(forKey: "a:_SaleServices")
        self.serviceCharge = attributeDict.getIntegerFromDictionary(withKeys: ["a:_ServiceCharge"])
        self.serviceCode = attributeDict.getBoolFromDictionary(withKeys: ["a:_ServiceCode"])
        self.serviceDesc = attributeDict.getBoolFromDictionary(withKeys: ["a:_ServiceDesc"])
        self.serviceID = attributeDict.getIntegerFromDictionary(withKeys: ["a:_ServiceID"])
        self.serviceName = attributeDict.getBoolFromDictionary(withKeys: ["a:_ServiceName"])
        self.serviceTypeID = attributeDict.getIntegerFromDictionary(withKeys: ["a:_ServiceTypeID"])
        self.serviceTypeName = attributeDict.getInnerText(forKey: "a:_ServiceTypeName")
        self.ticketServices = attributeDict.getInnerText(forKey: "a:_TicketServices")
        
        return self
    }

}
