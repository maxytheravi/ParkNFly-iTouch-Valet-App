//
//  FacilityConfigBO.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 14/10/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class FacilityConfigBO: NSObject {
    
    var additionalNotes: String?
    var airportCode: String?
    var entryMinutesFree: String?
    var exitMinutesFree: String?
    var facilityCode: String?
    var facilityId: String?
    var facilityName: String?
    var messageNumber: String?
    var parkEyeIP: String?
    var phone: String?
    var receiptFooter: String?
    var sixCardsCCPassword: String?
    var sixCardsCCUserName: String?
    var spaces: String?
    var startSequence: String?
    var ticketDeleteDays: String?
    var ticketFooter: String?
    var webAddress: String?
    
    func getFacilityConfigBOFromDictionary(_ attributeDict: NSDictionary) -> FacilityConfigBO {
        
        self.additionalNotes = attributeDict.getInnerText(forKey: "a:_AdditionalNotes")
        self.airportCode = attributeDict.getInnerText(forKey: "a:_AirportCode")
        self.entryMinutesFree = attributeDict.getInnerText(forKey: "a:_EntryMinutesFree")
        self.exitMinutesFree = attributeDict.getInnerText(forKey: "a:_ExitMinutesFree")
        self.facilityCode = attributeDict.getInnerText(forKey: "a:_FacilityCode")
        self.facilityId = attributeDict.getInnerText(forKey: "a:_FacilityId")
        self.facilityName = attributeDict.getInnerText(forKey: "a:_FacilityName")
        self.messageNumber = attributeDict.getInnerText(forKey: "a:_MessageNumber")
        self.parkEyeIP = attributeDict.getAttributedData(forKey: "a:_ParkEyeIP")
        self.phone = attributeDict.getInnerText(forKey: "a:_Phone")
        self.receiptFooter = attributeDict.getInnerText(forKey: "a:_ReceiptFooter")
        self.sixCardsCCPassword = attributeDict.getAttributedData(forKey: "a:_SixCardsCCPassword")
        self.sixCardsCCUserName = attributeDict.getAttributedData(forKey: "a:_SixCardsCCUserName")
        self.spaces = attributeDict.getInnerText(forKey: "a:_Spaces")
        self.startSequence = attributeDict.getAttributedData(forKey: "a:_StartSequence")
        self.ticketDeleteDays = attributeDict.getInnerText(forKey: "a:_TicketDeleteDays")
        self.ticketFooter = attributeDict.getInnerText(forKey: "a:_TicketFooter")
        self.webAddress = attributeDict.getInnerText(forKey: "a:_WebAddress")
        
        return self
    }
}
