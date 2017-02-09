//
//  InsertCustomLogFromClientService.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 18/03/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class InsertCustomLogFromClientService: GenericServiceManager {
    
    /**
     This method will create InsertCustomLogFromClient request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    var logData: [String:String] = [String:String]()
    
    func insertCustomLogFromClientService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        var facilityCode = ""
        if  (naviController?.facilityConfig?.facilityCode) != nil && naviController?.facilityConfig?.facilityCode?.characters.count > 0 {
            facilityCode = (naviController?.facilityConfig?.facilityCode)!
        }
        
        var deviceCode = ""
        if naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode != nil && naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode?.characters.count > 0 {
            deviceCode = (naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode)!
        }
        
        var shiftCode = ""
        if naviController?.shiftCode != nil && naviController?.shiftCode?.characters.count > 0 {
            shiftCode = (naviController?.shiftCode)!
        }
        
        var cashierUserName = ""
        if naviController?.authenticateUser != nil && naviController?.userName != nil && naviController?.authenticateUser?.characters.count > 0 && naviController?.userName?.characters.count > 0 {
            cashierUserName = (naviController?.authenticateUser)! + "\\" + (naviController?.userName)!
        }
        
        let message = parameters["message"] as! String
        let logType = parameters["logType"] as! String
        var barcodeTag = ""
        if let _ = parameters["barcode"] {
            let barcode = parameters["barcode"] as! String
            barcodeTag = "<tem:barcode>" + barcode + "</tem:barcode>\n"
        } else {
            barcodeTag = "<tem:barcode xsi:nil=\"true\"></tem:barcode>\n"
        }
        
        var flow = ""
        if (naviController?.currentFlowStatus == FlowStatus.kCheckInFlow){
            flow = "Checkin"
        } else if (naviController?.currentFlowStatus == FlowStatus.kCheckOutFlow){
            flow = "Checkout"
        } else if (naviController?.currentFlowStatus == FlowStatus.kOnLotFlow){
            flow = "Onlot"
        }
        
        self.logData["message"] = message
        self.logData["logType"] = logType
        
        let soapMessage = "<soapenv:Envelope  xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:InsertCustomLogFromClient>\n"
            + "<tem:DeviceCode></tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:facilityCode>" + facilityCode + "</tem:facilityCode>\n"
            + "<tem:deviceID>" + "\(deviceCode)" + "</tem:deviceID>\n"
            + "<tem:message>" + message + "</tem:message>\n"
            + "<tem:logType>" + logType + "</tem:logType>\n"
            + "<tem:cashierUserName>" + cashierUserName + "</tem:cashierUserName>\n"
            + "<tem:name>" + flow + "</tem:name>\n"
            + barcodeTag
            + "<tem:shiftCode>" + shiftCode + "</tem:shiftCode>\n"
            + "</tem:InsertCustomLogFromClient>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>\n"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"InsertCustomLogFromClient")
    }
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
//        let dict: NSDictionary? = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary?
        
        if dict.allKeys.count > 0 {
            
            self.logData["Result"] = "\(true)"
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: self.logData as AnyObject)
            }
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate!.didFailedWithError!(self.identifier, errorMessage: klServerDownMsg)
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
