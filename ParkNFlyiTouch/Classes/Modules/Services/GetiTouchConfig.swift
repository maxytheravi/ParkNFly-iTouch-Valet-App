//
//  GetAllLocation.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/14/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class GetiTouchConfig: GenericServiceManager {
    
    /**
     This method will create GetiTouchConfig request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    func getGetiTouchConfigService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        let soapMessage = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:GetiTouchConfig>\n"
            + "<tem:FacilityCode></tem:FacilityCode>\n"
            + "<tem:DeviceCode></tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:DeviceAddress>" + "\(Utility.getDeviceIdentifier())" + "</tem:DeviceAddress>\n"
            + "</tem:GetiTouchConfig>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>\n"
        
        connection.callWebService(Utility.getBaseURL(), soapMessage: soapMessage, soapActionName: "GetiTouchConfig")
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dictionary: NSDictionary) {
        
        //        let dictionary: NSDictionary = ObjectiveCCommonMethods.dictionaryParserXML(response) as NSDictionary
        //            GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if let result = dictionary.getObjectFromDictionary(withKeys: ["GetiTouchConfigResponse","GetiTouchConfigResult","a:Result"]) {
            //            let pic = (snapshot.value as? NSDictionary)?["pictureURL"] as? String ?? ""
            //            if let value = result["a:AutoCloseShiftRequired"] {
            if ((result as? NSDictionary)? ["a:AutoCloseShiftRequired"]) != nil {
                //                if let _ = value {
                naviController?.autoCloseShiftRequired = (result as AnyObject).getInnerText(forKey: "a:AutoCloseShiftRequired") == "true"
                //                }
            }
            
            //            if let value = result["a:AutoCloseShiftTimeOutInMinutes"] {
            if ((result as? NSDictionary)? ["a:AutoCloseShiftTimeOutInMinutes"]) != nil {
                //                if let _ = value {
                naviController?.autoCloseShiftTimeOutInMinutes = Int((result as AnyObject).getInnerText(forKey: "a:AutoCloseShiftTimeOutInMinutes"))!
                //                }
            }
            
            //            if let value = result["a:AutoCloseShiftUserName"] {
            if ((result as? NSDictionary)? ["a:AutoCloseShiftUserName"]) != nil {
                //                if let _ = value {
                naviController?.autoCloseShiftUserName = (result as AnyObject).getInnerText(forKey: "a:AutoCloseShiftUserName")
                //                }
            }
            
            //            if let _ = result["a:AutoCloseShiftRequired"] {
            //                naviController?.autoCloseShiftRequired = result.getInnerTextForKey("a:AutoCloseShiftRequired") == "true"
            //            }
            //
            //            if let _ = result["a:AutoCloseShiftTimeOutInMinutes"] {
            //                naviController?.autoCloseShiftTimeOutInMinutes = Int(result.getInnerTextForKey("a:AutoCloseShiftTimeOutInMinutes"))!
            //            }
            //
            //            if let _ = result["a:AutoCloseShiftUserName"] {
            //                naviController?.autoCloseShiftUserName = result.getInnerTextForKey("a:AutoCloseShiftUserName")
            //            }
            
            if let deviceIdByDeviceAddressDict = (result as AnyObject).getObjectFromDictionary(withKeys: ["a:Device"]) {
                
                let deviceIdByDeviceAddress: DeviceIdByDeviceAddressBO = DeviceIdByDeviceAddressBO()
                _ = deviceIdByDeviceAddress.getDeviceIdByDeviceAddressBOFromDictionary(deviceIdByDeviceAddressDict as! NSDictionary)
                
                naviController?.deviceIdByDeviceByDeviceAddress = deviceIdByDeviceAddress
            }
            
            if let facilityConfigDict = (result as AnyObject).getObjectFromDictionary(withKeys: ["a:FacilityConfig"]) {
                
                let facilityConfigBO: FacilityConfigBO = FacilityConfigBO()
                _ = facilityConfigBO.getFacilityConfigBOFromDictionary(facilityConfigDict as! NSDictionary)
                
                naviController?.facilityConfig = facilityConfigBO
            }
            
            if let allLocationArray: NSArray = (result as AnyObject).getObjectFromDictionary(withKeys: ["a:Locations","a:Location"]) as? NSArray {
                
                var allLocationObjectArray:[LocationBO] = []
                
                for (_,value) in allLocationArray.enumerated() {
                    
                    var locationBO = LocationBO()
                    locationBO = locationBO.getLocationBOFromDictionary(value as! NSDictionary)
                    allLocationObjectArray.append(locationBO)
                }
                
                naviController?.allLocationArray = allLocationObjectArray
            }
            
            if let parkingTypeArray: NSArray = (result as AnyObject).getObjectFromDictionary(withKeys: ["a:ParkingTypes","a:ParkingType"]) as? NSArray {
                
                var parkingArray:[ProductSetServiceBO] = []
                
                for (_,value) in parkingTypeArray.enumerated() {
                    
                    var productSetServiceBO = ProductSetServiceBO()
                    productSetServiceBO = productSetServiceBO.getProductSetServiceBOFromDictionary(value as! NSDictionary)
                    parkingArray.append(productSetServiceBO)
                }
                
                naviController?.productArray = parkingArray
            } else if let parkingType = (result as AnyObject).getObjectFromDictionary(withKeys: ["a:ParkingTypes","a:ParkingType"]) {
                
                var parkingArray:[ProductSetServiceBO] = []
                
                var productSetServiceBO = ProductSetServiceBO()
                productSetServiceBO = productSetServiceBO.getProductSetServiceBOFromDictionary(parkingType as! NSDictionary)
                parkingArray.append(productSetServiceBO)
                
                naviController?.productArray = parkingArray
            }
            
            if let getVehicleMakeArray: NSArray = (result as AnyObject).getObjectFromDictionary(withKeys: ["a:VehicleMakes","a:VehicleMake"]) as? NSArray {
                
                var getvehicleArray:[VehicleMakeBO] = []
                
                for (_,value) in getVehicleMakeArray.enumerated() {
                    var vehicleMakeBO = VehicleMakeBO()
                    vehicleMakeBO = vehicleMakeBO.getVehicleMakeBOFromDictionary(value as! NSDictionary)
                    getvehicleArray.append(vehicleMakeBO)
                }
                
                naviController?.vehicleMakeArray = getvehicleArray
            }
            
            if let serviceCategoriesAndServicesArray: NSArray = (result as AnyObject).getObjectFromDictionary(withKeys: ["a:serviceCategoriesAndServices","a:ServiceCategoriesAndServices"]) as? NSArray {
                
                naviController?.serviceDictionary = [String:Array<ServiceBO>]()
                naviController?.categoryArray = [ServiceCategoryBO]()
                
                for serviceCategoriesAndServices in serviceCategoriesAndServicesArray {
                    
                    let serviceCategoriesAndServicesDict: NSDictionary = serviceCategoriesAndServices as! NSDictionary
                    
                    let serviceCategory: NSDictionary = serviceCategoriesAndServicesDict.getObjectFromDictionary(withKeys: ["a:ServiceCategory"]) as! NSDictionary
                    var serviceCategoryBO = ServiceCategoryBO()
                    serviceCategoryBO = serviceCategoryBO.getServiceTypesByFacilityIDFromDictionary(serviceCategory )
                    naviController?.categoryArray?.append(serviceCategoryBO)
                    
                    let services = serviceCategoriesAndServicesDict.getObjectFromDictionary(withKeys: ["a:ServiceList","a:AddService"])
                    
                    if services is NSArray {
                        
                        let servicesList: NSArray = services as! NSArray
                        
                        for service in servicesList {
                            let serviceDict: NSDictionary = service as! NSDictionary
                            
                            var serviceBO:ServiceBO = ServiceBO()
                            serviceBO = serviceBO.getServiceBOFromDictionary(serviceDict)
                            
                            let serviceTypeID = "\(serviceCategory.getIntegerFromDictionary(withKeys: ["a:_ServiceTypeID"]))"
                            
                            var servicesArray = naviController?.serviceDictionary?[serviceTypeID]
                            
                            if servicesArray == nil {
                                servicesArray = [ServiceBO]()
                            }
                            
                            servicesArray?.append(serviceBO)
                            naviController?.serviceDictionary![serviceTypeID] = servicesArray
                        }
                    } else {
                        
                        let serviceDict: NSDictionary = services as! NSDictionary
                        
                        var serviceBO:ServiceBO = ServiceBO()
                        serviceBO = serviceBO.getServiceBOFromDictionary(serviceDict)
                        
                        let serviceTypeID = "\(serviceCategory.getIntegerFromDictionary(withKeys: ["a:_ServiceTypeID"]))"
                        
                        var servicesArray = naviController?.serviceDictionary?[serviceTypeID]
                        
                        if servicesArray == nil {
                            servicesArray = [ServiceBO]()
                        }
                        
                        servicesArray?.append(serviceBO)
                        naviController?.serviceDictionary![serviceTypeID] = servicesArray
                    }
                }
            } else if let serviceCategoriesAndServices = (result as AnyObject).getObjectFromDictionary(withKeys: ["a:serviceCategoriesAndServices","a:ServiceCategoriesAndServices"]) {
                
                naviController?.serviceDictionary = [String:Array<ServiceBO>]()
                naviController?.categoryArray = [ServiceCategoryBO]()
                
                let serviceCategoriesAndServicesDict: NSDictionary = serviceCategoriesAndServices as! NSDictionary
                
                let serviceCategory: NSDictionary = serviceCategoriesAndServicesDict.getObjectFromDictionary(withKeys: ["a:ServiceCategory"]) as! NSDictionary
                var serviceCategoryBO = ServiceCategoryBO()
                serviceCategoryBO = serviceCategoryBO.getServiceTypesByFacilityIDFromDictionary(serviceCategory)
                naviController?.categoryArray?.append(serviceCategoryBO)
                
                let services = serviceCategoriesAndServicesDict.getObjectFromDictionary(withKeys: ["a:ServiceList","a:AddService"])
                
                if services is NSArray {
                    
                    let servicesList: NSArray = services as! NSArray
                    
                    for service in servicesList {
                        let serviceDict: NSDictionary = service as! NSDictionary
                        
                        var serviceBO:ServiceBO = ServiceBO()
                        serviceBO = serviceBO.getServiceBOFromDictionary(serviceDict)
                        
                        let serviceTypeID = "\(serviceCategory.getIntegerFromDictionary(withKeys: ["a:_ServiceTypeID"]))"
                        
                        var servicesArray = naviController?.serviceDictionary?[serviceTypeID]
                        
                        if servicesArray == nil {
                            servicesArray = [ServiceBO]()
                        }
                        
                        servicesArray?.append(serviceBO)
                        naviController?.serviceDictionary![serviceTypeID] = servicesArray
                    }
                } else {
                    
                    let serviceDict: NSDictionary = services as! NSDictionary
                    
                    var serviceBO:ServiceBO = ServiceBO()
                    serviceBO = serviceBO.getServiceBOFromDictionary(serviceDict)
                    
                    let serviceTypeID = "\(serviceCategory.getIntegerFromDictionary(withKeys: ["a:_ServiceTypeID"]))"
                    
                    var servicesArray = naviController?.serviceDictionary?[serviceTypeID]
                    
                    if servicesArray == nil {
                        servicesArray = [ServiceBO]()
                    }
                    
                    servicesArray?.append(serviceBO)
                    naviController?.serviceDictionary![serviceTypeID] = servicesArray
                }
            }
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate?.connectionDidFinishLoading!(self.identifier, response: "" as AnyObject)
            }
            
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate?.didFailedWithError!(self.identifier, errorMessage: "No records")
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate?.didFailedWithError!(self.identifier, errorMessage: "")
        }
    }
}
