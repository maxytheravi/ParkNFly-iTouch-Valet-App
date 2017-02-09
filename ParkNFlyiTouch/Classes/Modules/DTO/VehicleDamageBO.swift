//
//  VehicleDamageBO.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 11/23/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class VehicleDamageBO: NSObject {

    var damageDesc:String?
    var imageName:String?
    var imageStream:String?
    var location:String?
    var reportDateTime:String?
    var ticketId:Int?
    var vehicleDamageId:Int?
    var vehicleDamageImage:UIImage?
    
    override init(){
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(damageDesc,forKey: "damageDesc")
        aCoder.encode(imageName,forKey: "imageName")
        aCoder.encode(imageStream,forKey: "imageStream")
        aCoder.encode(location,forKey: "location")
        aCoder.encode(reportDateTime,forKey: "reportDateTime")
        aCoder.encode(ticketId!, forKey: "ticketId")
        aCoder.encode(vehicleDamageId!, forKey: "vehicleDamageId")
//        aCoder.encodeObject(vehicleDamageImage,forKey: "vehicleDamageImage")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.damageDesc = aDecoder.decodeObject(forKey: "damageDesc") as? String
        self.imageName = aDecoder.decodeObject(forKey: "imageName") as? String
        self.imageStream = aDecoder.decodeObject(forKey: "imageStream") as? String
        self.location = aDecoder.decodeObject(forKey: "location") as? String
        self.reportDateTime = aDecoder.decodeObject(forKey: "reportDateTime") as? String
        self.ticketId = aDecoder.decodeInteger(forKey: "ticketId")
        self.vehicleDamageId = aDecoder.decodeInteger(forKey: "vehicleDamageId")
//        self.vehicleDamageImage = aDecoder.decodeObjectForKey("vehicleDamageImage") as? UIImage
    }
    
    func deepCopyOfVehicleDamageBO() -> VehicleDamageBO {
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: self)
        let vehicleDamageBO: VehicleDamageBO = (NSKeyedUnarchiver.unarchiveObject(with: data) as! VehicleDamageBO)
        
        return vehicleDamageBO
    }
    
    func getVehicleDamageBOFromDictionary(_ attributeDict: NSDictionary) -> VehicleDamageBO {
    
        self.damageDesc = attributeDict.getInnerText(forKey: "a:DamageDesc")
        self.imageName = attributeDict.getAttributedData(forKey: "a:ImageName")
        self.imageStream = attributeDict.getInnerText(forKey: "a:ImageStream")
        self.location = attributeDict.getInnerText(forKey: "a:Location")
        self.reportDateTime = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:ReportDateTime"))
        self.ticketId = attributeDict.getIntegerFromDictionary(withKeys: ["a:TicketID"])
        self.vehicleDamageId = attributeDict.getIntegerFromDictionary(withKeys: ["a:VehicleDamageID"])
        
        return self
    }
}
