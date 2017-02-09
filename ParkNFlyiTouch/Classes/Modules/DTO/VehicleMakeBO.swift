//
//  VehicleMakeBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/15/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class VehicleMakeBO: NSObject {
    
    var vehicleMakeName: NSString? = nil
    var vehicleModels: NSString? = nil
    var isActive: Bool? = nil
    var vehicleMaleID: NSInteger? = nil
    
    func getVehicleMakeBOFromDictionary(_ attributeDict: NSDictionary) -> VehicleMakeBO {
        
        self.vehicleMakeName = attributeDict.getInnerText(forKey: "a:_VehicleMakeName") as NSString?
        self.vehicleModels = attributeDict.getInnerText(forKey: "a:_VehicleModels") as NSString?
        self.isActive = attributeDict.getBoolFromDictionary(withKeys: ["a:_IsActive"])
        self.vehicleMaleID = attributeDict.getIntegerFromDictionary(withKeys: ["a:_VehicleMakeID"])
        
        return self
    }
}
