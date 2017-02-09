//
//  UpdateVehicleInfoService.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Ka on 12/28/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class UpdateVehicleInfoService: GenericServiceManager {
    
    /**
     This method will create GetVehicleInfoByVIN request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func updateVehicleInfoService(_ identifier: String, parameters: NSDictionary) {
        
        let vehicleDetailsBO = parameters["VehicleDetailsBO"] as! VehicleDetailsBO
        let color = vehicleDetailsBO.vehicleColor! as String
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        let ticketID:String? = parameters["TicketID"] as? String
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\">"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:UpdateVehicleInfo>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:vehicleDetail>\n"
            + "<par:Color>" + color + "</par:Color>\n"
            //DamageDetails
            + self.createDamageDetailsRequestXML(vehicleDetailsBO.damageMarksArray)
            //
            + "<par:DamageImage>" + "\(vehicleDetailsBO.damageMarkImage!)" + "</par:DamageImage>\n"
            + "<par:Make>" + "\(vehicleDetailsBO.vehicleMake!)" + "</par:Make>\n"
            + "<par:Model>" + "\(vehicleDetailsBO.vehicleModel!)" + "</par:Model>\n"
            + "<par:TicketID>" + ticketID! + "</par:TicketID>\n"
            + "<par:VIN>" + "\(vehicleDetailsBO.vehicleVIN!)" + "</par:VIN>\n"
            + "<par:Year>" + "\(vehicleDetailsBO.vehicleYear!)" + "</par:Year>\n"
            + "</tem:vehicleDetail>\n"
            + "</tem:UpdateVehicleInfo>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>\n"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"UpdateVehicleInfo")
    }
    
    func createDamageDetailsRequestXML(_ damageMarksArray: [DamageMarkBO]?) -> String {
        
        var damageMarksXML: String = ""
        
        if damageMarksArray!.count > 0 {
            damageMarksXML += "<par:DamageDetails>\n"
            for damageMarkBO in damageMarksArray! {
                damageMarksXML += self.createDamageDetailRequestXML(damageMarkBO)
            }
            damageMarksXML += "</par:DamageDetails>\n"
        }else {
            damageMarksXML = "<par:DamageDetails/>\n"
        }
        
        return damageMarksXML
    }
    
    func createDamageDetailRequestXML(_ damageMarkBO: DamageMarkBO) -> String {
        
        let damageId = (damageMarkBO.damageID != nil) ? damageMarkBO.damageID : "0"
        
        let damageMarkXML: String = "<par:DamageDetail>\n"
            + "<par:DamageLocation>" + "\(damageMarkBO.locationX!)" + "," + "\(damageMarkBO.locationY!)" + "</par:DamageLocation>\n"
            + "<par:DamageLogDate>" + "\(damageMarkBO.logDate!)" + "</par:DamageLogDate>\n"
            + "<par:DamageMarkedBy>" + "\(damageMarkBO.markedBy!)" + "</par:DamageMarkedBy>\n"
            + "<par:DamageNote>" + "\(damageMarkBO.note!)" + "</par:DamageNote>\n"
            + "<par:DamageStatus>" + "\(damageMarkBO.status!)" + "</par:DamageStatus>\n"
            + "<par:VehicleDamageID>" + "\(damageId!)" + "</par:VehicleDamageID>\n"
            + "</par:DamageDetail>\n"
        
        return damageMarkXML
    }
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if dict.getObjectFromDictionary(withKeys: ["UpdateVehicleInfoResponse","UpdateVehicleInfoResult"]) != nil {
            
            let vehicleDetailsDict: NSDictionary = dict.getObjectFromDictionary(withKeys: ["UpdateVehicleInfoResponse","UpdateVehicleInfoResult"]) as! NSDictionary
            
            if vehicleDetailsDict.getInnerText(forKey: "a:Result") == "true" {
                
                if self.delegate?.connectionDidFinishLoading != nil {
                    self.delegate!.connectionDidFinishLoading!(self.identifier, response: vehicleDetailsDict.getInnerText(forKey: "a:Result") as AnyObject)
                }
            } else {
                if self.delegate?.didFailedWithError != nil {
                    self.delegate!.didFailedWithError!(self.identifier, errorMessage: "Unable to update vehicle info")
                }
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
