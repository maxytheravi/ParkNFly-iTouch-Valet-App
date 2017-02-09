//
//  DamageMarkBO.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 24/12/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class DamageMarkBO: NSObject {
    
    var locationX: CGFloat?
    var locationY: CGFloat?
    var logDate: String?
    var markedBy: String?
    var note: String?
    var status: Bool?
    var damageID: String?
    var ticketBarcode: String?
    
    func getDamageMarkBO(_ attributeDict: NSDictionary) -> DamageMarkBO {
        
        let token = (attributeDict.getInnerText(forKey: "a:DamageLocation")).components(separatedBy: ",")
        
        if let n = NumberFormatter().number(from: token[0] ) {
            self.locationX = CGFloat(n)
        }
        
        if let n = NumberFormatter().number(from: token[1] ) {
            self.locationY = CGFloat(n)
        }
        
        self.logDate = attributeDict.getInnerText(forKey: "a:DamageLogDate")
        self.markedBy = attributeDict.getInnerText(forKey: "a:DamageMarkedBy")
        self.note = attributeDict.getInnerText(forKey: "a:DamageNote")
        self.status = attributeDict.getBoolFromDictionary(withKeys: ["a:DamageStatus"])
        self.damageID = attributeDict.getInnerText(forKey: "a:VehicleDamageID")
        self.ticketBarcode = attributeDict.getInnerText(forKey: "a:TicketBarcode")
        
        return self
    }
}
