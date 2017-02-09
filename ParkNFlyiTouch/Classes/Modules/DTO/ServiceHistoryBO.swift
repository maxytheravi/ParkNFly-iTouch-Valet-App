//
//  ServiceHistoryBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 2/4/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ServiceHistoryBO: NSObject {
    
    var category: String? = nil
    var dateOfService: String? = nil
    var serviceName: String? = nil
    
    func getServiceHistoryBOFromDictionary(_ attributeDict: NSDictionary) -> ServiceHistoryBO {
        
        self.category = attributeDict.getInnerText(forKey: "a:Category")
        self.dateOfService = attributeDict.getInnerText(forKey: "a:DateOfService")
        self.serviceName = attributeDict.getInnerText(forKey: "a:ServiceName")
        
        return self
    }
}
