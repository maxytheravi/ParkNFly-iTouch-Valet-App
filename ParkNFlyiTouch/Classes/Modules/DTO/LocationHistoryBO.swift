//
//  LocationHistoryBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/16/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class LocationHistoryBO: NSObject {

    var cashierUserName: String? = nil
    var locationLogDate: String? = nil
    var locationName: String? = nil
    
    func getLocationHistoryBOFromDictionary(_ attributeDict: NSDictionary) -> LocationHistoryBO {
        
        self.cashierUserName = attributeDict.getInnerText(forKey: "a:CashierUserName")
        self.locationLogDate = attributeDict.getInnerText(forKey: "a:LogDate")
        self.locationName = attributeDict.getInnerText(forKey: "a:SpaceDescription")
        
        return self
    }

}
