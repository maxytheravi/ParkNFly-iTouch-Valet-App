//
//  VehicleDetailsBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/23/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class VehicleDetailsBO: NSObject {
    
    var vehicleColor: String? = nil
    var vehicleDamageDetails: String? = nil
    var damageMarkImage: String? = nil
    var vehicleMake: String? = nil
    var vehicleModel: String? = nil
    var vehicleVIN: String? = nil
    var tikcetID: String? = nil
    var vehicleYear: String? = nil
//    var vehicleTag: String? = nil
    var isOversized = false
    var damageMarksArray: [DamageMarkBO]?
    
    var customerProfileID: String? = nil
    var identifierKey: String? = nil
    var vehicleID: String? = nil
    var tier: String? = nil
    var profileIdentifierID: String? = nil
    var licenseNumber: String? = nil
    
    func getVehicleDeails(_ attributeDict: NSDictionary) -> VehicleDetailsBO {
        
        self.vehicleColor = attributeDict.getInnerText(forKey: "a:Color")
        self.vehicleDamageDetails = attributeDict.getInnerText(forKey: "a:DamageDetails")
        self.damageMarkImage = attributeDict.getInnerText(forKey: "a:DamageImage")
        self.vehicleMake = attributeDict.getInnerText(forKey: "a:Make")
        self.vehicleModel = attributeDict.getInnerText(forKey: "a:Model")
        self.tikcetID = attributeDict.getInnerText(forKey: "a:TicketID")
        self.vehicleVIN = attributeDict.getInnerText(forKey: "a:VIN")
        self.licenseNumber = attributeDict.getInnerText(forKey: "a:Tag")
        self.vehicleYear = attributeDict.getInnerText(forKey: "a:Year")
        self.isOversized = (attributeDict.getInnerText(forKey: "a:IsOversized") as NSString).boolValue
        
        if let damageMarksAttributeArray = attributeDict.getObjectFromDictionary(withKeys: ["a:DamageDetails","a:DamageDetail"]) {
            self.damageMarksArray = [DamageMarkBO]()
            if (damageMarksAttributeArray as AnyObject) is NSArray {
                for damageMark in (damageMarksAttributeArray as! NSArray) {
                    let damageMarkBO = DamageMarkBO()
                    self.damageMarksArray?.append(damageMarkBO.getDamageMarkBO(damageMark as! NSDictionary))
                }
            } else {
                let damageMarkBO = DamageMarkBO()
                self.damageMarksArray?.append(damageMarkBO.getDamageMarkBO(damageMarksAttributeArray as! NSDictionary))
            }
        } else if let damageMarksAttributeArray = attributeDict.getObjectFromDictionary(withKeys: ["a:DamageDetails"]) {
//            if (damageMarksAttributeArray as AnyObject).isKind(of: NSArray()) {
            if (damageMarksAttributeArray as AnyObject) is NSArray {

                self.damageMarksArray = [DamageMarkBO]()
                for damageMark in (damageMarksAttributeArray as! NSArray) {
                    let damageMarkBO = DamageMarkBO()
                    self.damageMarksArray?.append(damageMarkBO.getDamageMarkBO(damageMark as! NSDictionary))
                }
            }
        }
        
        return self
    }
    
    func getVehicleDeailsFromFP(_ attributeDict: NSDictionary) -> VehicleDetailsBO {
        
        self.vehicleColor = attributeDict.getInnerText(forKey: "a:Color")
        self.vehicleMake = attributeDict.getInnerText(forKey: "a:Make")
        self.vehicleModel = attributeDict.getInnerText(forKey: "a:Model")
        self.vehicleYear = attributeDict.getInnerText(forKey: "a:Year")
        self.isOversized = (attributeDict.getInnerText(forKey: "a:Oversized") as NSString).boolValue
        self.customerProfileID = attributeDict.getInnerText(forKey: "a:CustomerProfileID")
        self.identifierKey = attributeDict.getInnerText(forKey: "a:IdentifierKey")
        self.licenseNumber = attributeDict.getInnerText(forKey: "a:LicenseNumber")
        self.profileIdentifierID = attributeDict.getInnerText(forKey: "a:ProfileIdentifierID")
        self.tier = attributeDict.getInnerText(forKey: "a:Tier")
        self.vehicleID = attributeDict.getInnerText(forKey: "a:VehicleID")
        return self
    }
}
