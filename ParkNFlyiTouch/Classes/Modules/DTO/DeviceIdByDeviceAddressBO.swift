//
//  DeviceIdByDeviceAddressBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/15/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class DeviceIdByDeviceAddressBO: NSObject {
    
    var deviceAddress: String? = nil
    var allowedTiers: String? = nil
    var deviceCode: String? = nil
    var deviceCommands: String? = nil
    var deviceCommands1: String? = nil
    var deviceId: String? = nil
    var deviceName: String? = nil
    var deviceStatus: String? = nil
    var deviceTypeId: NSInteger? = nil
    var isActive: Bool? = nil
    var KioskIdForCashierDevice: String? = nil
    var laneDirection: String? = nil
    var locationID: String? = nil
    var parkingType: String? = nil
    var parkingTypeId: String? = nil
    var shifts: String? = nil
    var statusUpdateDate: String? = nil
    var terminalId: NSInteger? = nil
    
    func getDeviceIdByDeviceAddressBOFromDictionary(_ attributeDict: NSDictionary) -> DeviceIdByDeviceAddressBO {
        
        self.deviceAddress = attributeDict.getInnerText(forKey: "a:_DeviceAddress")
        self.allowedTiers = attributeDict.getAttributedData(forKey: "a:_AllowedTiers")
        self.deviceCode = attributeDict.getInnerText(forKey: "a:_DeviceCode")
        self.deviceCommands = attributeDict.getInnerText(forKey: "a:_DeviceCommands")
        self.deviceCommands1 = attributeDict.getInnerText(forKey: "a:_DeviceCommands1")
        self.deviceId = attributeDict.getInnerText(forKey: "a:_DeviceID")
        self.deviceName = attributeDict.getInnerText(forKey: "a:_DeviceName")
        self.deviceStatus = attributeDict.getInnerText(forKey: "a:_DeviceStatus")
        self.deviceTypeId = attributeDict.getIntegerFromDictionary(withKeys: ["a:_DeviceTypeID"])
        self.isActive = attributeDict.getBoolFromDictionary(withKeys: ["a:_IsActive"])
        self.KioskIdForCashierDevice = attributeDict.getAttributedData(forKey: "a:_KioskIdForCashierDevice")
        self.laneDirection = attributeDict.getAttributedData(forKey: "a:_LaneDirection")
        self.locationID = attributeDict.getAttributedData(forKey: "a:_LocationID")
        self.parkingType = attributeDict.getAttributedData(forKey: "a:_ParkingType")
        self.parkingTypeId = attributeDict.getAttributedData(forKey: "a:_ParkingTypeID")
        self.shifts = attributeDict.getAttributedData(forKey: "a:_Shifts")
        self.statusUpdateDate = Utility.getFormatedDateTimeWithT(attributeDict.getAttributedData(forKey: "a:_StatusUpdateDate"))
        self.terminalId = attributeDict.getIntegerFromDictionary(withKeys: ["a:_TerminalId"])
        
        return self
    }
}
