//
//  GetTicketByBarcodeService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/19/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetTicketByBarcodeService: GenericServiceManager {
    
    /**
     This method will create GetTicketByBarcode request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getTicketByBarcodeWebService(_ identifier: String ,parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        var ticketNumber = ""
        if let aTicketNumber = parameters["TicketNumber"] {
            ticketNumber = aTicketNumber as! String
        }
        
        var VIN = ""
        if let aVIN = parameters["VIN"] {
            VIN = aVIN as! String
        }
        
        var tag = ""
        if let aTag = parameters["Tag"] {
            tag = aTag as! String
        }
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let soapMessage = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tem=\"http://tempuri.org/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetTicketByBarcode>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:barcode>" + ticketNumber + "</tem:barcode>"
            + "<tem:ticketSpace></tem:ticketSpace>\n"
            + "<tem:VIN>" + VIN + "</tem:VIN>\n"
            + "<tem:Tag>" + tag + "</tem:Tag>\n"
            + "<tem:isTicketProcessed>false</tem:isTicketProcessed>"
            + "</tem:GetTicketByBarcode>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GetTicketByBarcode")
        
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if dictionary.getObjectFromDictionary(withKeys: ["GetTicketByBarcodeResponse", "GetTicketByBarcodeResult", "a:Barcode"]) != nil {
            
            let ticketDict: NSDictionary = dictionary.getObjectFromDictionary(withKeys: ["GetTicketByBarcodeResponse","GetTicketByBarcodeResult"]) as! NSDictionary
            
            let ticketBO:TicketBO = TicketBO()
            _ = ticketBO.getTicketBOFromDictionary(ticketDict)
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: ticketBO)
            }
        }else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate?.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}

