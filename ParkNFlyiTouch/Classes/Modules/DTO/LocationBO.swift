//
//  LocationBO.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/15/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class LocationBO: NSObject {

    var locationID:String?
    var locationName:String?
    
    func getLocationBOFromDictionary(_ attributeDict: NSDictionary) -> LocationBO {
        
        self.locationID = attributeDict.getInnerText(forKey: "a:_LocationID")
        self.locationName = attributeDict.getInnerText(forKey: "a:_LocationName")
        
        return self
    }
}
