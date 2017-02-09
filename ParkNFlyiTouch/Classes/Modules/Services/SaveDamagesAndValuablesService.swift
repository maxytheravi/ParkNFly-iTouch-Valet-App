//
//  SaveDamagesAndValuablesService.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 09/12/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class SaveDamagesAndValuablesService: GenericServiceManager {
    
    func saveDamagesAndValuablesService(_ identifier: String, parameters: NSDictionary) {
        
        let vehicleDamagesArray = parameters["VehicleDamagesArray"]
        
        self.identifier = identifier
        let connection: ConnectionManager = ConnectionManager()
        connection.delegate = self
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:tem=\"http://tempuri.org/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
            + "<soapenv:Header />\n"
            + "<soapenv:Body>\n"
            + "<tem:SaveDamagesAndValuables>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:tabletDamagesAndValuables>\n"
            + self.createVehicleDamagesRequestXML(vehicleDamagesArray as! NSMutableArray)
            + "</tem:tabletDamagesAndValuables>\n"
            + "</tem:SaveDamagesAndValuables>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>\n"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"SaveDamagesAndValuables")
    }
    
    func createVehicleDamagesRequestXML(_ vehicleDamagesArray: NSMutableArray) -> String {
        
        var vehicleDamagesXML: String = ""
        
        if vehicleDamagesArray.count > 0 {
            //if ((vehicleDamageObj.location == "Damage") || (vehicleDamageObj.location == "Valuable")) {
            for vehicleDamageObj in vehicleDamagesArray {
                if (((vehicleDamageObj as! VehicleDamageBO).location == "Damage") || ((vehicleDamageObj as! VehicleDamageBO).location == "Valuable")) {
                    vehicleDamagesXML += self.createVehicleDamageRequestXML(vehicleDamageObj as! VehicleDamageBO)
                }
            }
            //            vehicleDamagesArray.enumerateObjectsUsingBlock({ vehicleDamageObj, index, stop in
            //                vehicleDamagesXML += self.createVehicleDamageRequestXML(vehicleDamageObj as! VehicleDamageBO)
            //            })
        } else {
            vehicleDamagesXML = "<par:TabletDamagesAndValuables />\n"
        }
        
        return vehicleDamagesXML
    }
    
    func createVehicleDamageRequestXML(_ vehicleDamageBO: VehicleDamageBO) -> String {
        
        let vehicleDamageXML: String = "<par:TabletDamagesAndValuables>\n"
            + "<par:DamageDesc>" + vehicleDamageBO.damageDesc! + "</par:DamageDesc>\n"
            + "<par:ImageStream>" + vehicleDamageBO.imageStream! + "</par:ImageStream>\n"
            + "<par:Location>" + vehicleDamageBO.location! + "</par:Location>\n"
            + "<par:ReportDateTime>" + vehicleDamageBO.reportDateTime! + "</par:ReportDateTime>\n"
            + "<par:TicketID>" + "\(vehicleDamageBO.ticketId!)" + "</par:TicketID>\n"
            //+ "<par:VehicleDamageID>" + "\(vehicleDamageBO.vehicleDamageId!)" + "</par:VehicleDamageID>\n"
            + self.getVehicleDamageIdTag(vehicleDamageBO.vehicleDamageId)
            + "</par:TabletDamagesAndValuables>\n"
        
        return vehicleDamageXML
    }
    
    func getVehicleDamageIdTag(_ vehicleDamageId:Int?) -> String {
        if let _ = vehicleDamageId {
            return "<par:VehicleDamageID>" + "\(vehicleDamageId!)" + "</par:VehicleDamageID>\n"
        } else {
            return "<par:VehicleDamageID>0</par:VehicleDamageID>\n"
        }
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if (dict.getObjectFromDictionary(withKeys: ["SaveDamagesAndValuablesResponse","SaveDamagesAndValuablesResult","a:TabletDamagesAndValuables"]) != nil) {
            
            let tableObject = dict.getObjectFromDictionary(withKeys: ["SaveDamagesAndValuablesResponse","SaveDamagesAndValuablesResult","a:TabletDamagesAndValuables"])
            
            var damagesAndValuablesArray:[VehicleDamageBO] = []
            
            if tableObject is NSArray {
                
                let damagesAndValuablesDictArray: NSArray = tableObject as! NSArray
                
                for (_,value) in damagesAndValuablesDictArray.enumerated() {
                    
                    var vehicleDamageBO = VehicleDamageBO()
                    vehicleDamageBO = vehicleDamageBO.getVehicleDamageBOFromDictionary(value as! NSDictionary)
                    if vehicleDamageBO.location == "Damage" || vehicleDamageBO.location == "Valuable" {
                        damagesAndValuablesArray.append(vehicleDamageBO)
                    }
                }
                
            } else {
                
                let damagesAndValuablesDict: NSDictionary = tableObject as! NSDictionary
                
                var vehicleDamageBO = VehicleDamageBO()
                vehicleDamageBO = vehicleDamageBO.getVehicleDamageBOFromDictionary(damagesAndValuablesDict)
                if vehicleDamageBO.location == "Damage" || vehicleDamageBO.location == "Valuable" {
                    damagesAndValuablesArray.append(vehicleDamageBO)
                }
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: damagesAndValuablesArray as AnyObject)
            }
        }
        else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate?.didFailedWithError!(self.identifier, errorMessage: "")
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
