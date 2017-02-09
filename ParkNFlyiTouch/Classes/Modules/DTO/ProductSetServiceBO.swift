//
//  ProductSetServiceBO.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/15/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ProductSetServiceBO: NSObject {

    var chauntryCode:String?
    var contractCardParkingTypes:String?
    var devices:String?
    var discountValues:String?
    var isActive:Bool?
    var parkingCode:String?
    var parkingRates:Double?
    var parkingTypeID:Int?
    var parkingTypeName:String?
    var sales:String?
    var ticketHistories:String?
    var tickets:String?
    var webCode:String?
    
    func getProductSetServiceBOFromDictionary(_ attributeDict: NSDictionary) -> ProductSetServiceBO {
        
        self.chauntryCode = attributeDict.getAttributedData(forKey: "a:_ChauntryCode")
        self.contractCardParkingTypes  = attributeDict.getInnerText(forKey: "a:_ContractCardParkingTypes")
        self.devices = attributeDict.getInnerText(forKey: "a:_Devices")
        self.discountValues = attributeDict.getInnerText(forKey: "a:_DiscountValues")
        self.isActive = attributeDict.getBoolFromDictionary(withKeys: ["a:_IsActive"])
        self.parkingCode = attributeDict.getInnerText(forKey: "a:_ParkingCode")
        self.parkingRates = attributeDict.getDoubleFromDictionary(withKeys: ["a:_ParkingRates"])
        self.parkingTypeID = attributeDict.getIntegerFromDictionary(withKeys: ["a:_ParkingTypeID"])
        self.parkingTypeName = attributeDict.getInnerText(forKey: "a:_ParkingTypeName")
        self.sales = attributeDict.getInnerText(forKey: "a:_Sales")
        self.ticketHistories = attributeDict.getInnerText(forKey: "a:_TicketHistories")
        self.tickets = attributeDict.getInnerText(forKey: "a:_Tickets")
        self.webCode = attributeDict.getInnerText(forKey: "a:_WebCode")
        
        return self
    }
}
