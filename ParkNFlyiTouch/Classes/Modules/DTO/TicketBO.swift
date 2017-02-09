//
//  TicketBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/19/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class TicketBO: NSObject {
    
    var adhocDiscountPC:String?
    var barcodeNumberString:String? = nil
    var prePrintedTicketNumber:String? = nil
    var ccAssociatedWithFP:String?
    var contCardEffectiveDate:String?
    var contCardExpiryDate:String?
    var contractCardList:String?
    var contractCardNumber:String?
    var creditCardFirstSixLastFour:String?
    var creditCardTrackData:String?
    var customerProfileID:String?
    var damageDesc:String?
    var deviceAddress:String?
    var deviceCode:String?
    var deviceName:String?
    var dirty:String?
    var emailId:String?
    var fpCardNumber:String?
    var fpPoints:String?
    var firstName:String? = nil
    var friendlyName:String?
    var fromDate:String?
    var gateKey:String?
    var guestCustomerID:String?
    var identifierKey:String?
    var imageStream:String?
    var inspection:String?
    var isPrimary:Bool?
    var isRedeemPointAvailable:Bool?
    var isTicketFoundThroughVarSearParam:Bool?
    var lastName:String? = nil
    var licenseState:String?
    var location:String?
    var locationBottom:String?
    var locationFront:String?
    var locationID:String?
    var locationLeft:String?
    var locationRight:String?
    var locationTop:String?
    var mileage:String?
    var notes:String?
    var parkingType:String?
    var parkingTypeName:String? = nil
    var phoneNo:String?
    var redeemPoints:String?
    var reportDateTime:String?
    var reservations:String?
    var rewardDays:String?
    var selectedRedeemReservationInTicket:String?
    var selectedReservationInTicket:String?
    var services:NSMutableArray?
    var spaceDescription:String?
    var ticketDetailID:String?
    var ticketID:String?
    var ticketStatus:String?
    var tier:String?
    var toDate:String? = nil
    var toDateValetScan:String?
    var valuables:String?
    var vehicleDamageID:String?
    var vehicleID:String?
    var vehicleDamages:NSMutableArray?
    var discounts:NSMutableArray?
    var rsId:String?
    
    var creditCardInfo: CreditCardInfoBO?
    
//    var make:String?
//    var model:String?
//    var color:String?
//    var licenseTag:String?
//    
//    var year:String?
//    var oversized:Bool?
    
    var vehicleDetails: VehicleDetailsBO?
//    var reservationBO:ReservationAndFPCardDetailsBO?
    var reservationsArray:[ReservationAndFPCardDetailsBO]?
    
    //MARK: - actual copying happens
    /*override init() {
        super.init()
    }
    
    init(adhocDiscountPC:String?, barcodeNumberString:String?, ccAssociatedWithFP:String?, color:String?, contCardEffectiveDate:String?, contCardExpiryDate:String?, contractCardList:String?, contractCardNumber:String?, creditCardFirstSixLastFour:String?, creditCardTrackData:String?, customerProfileID:String?, damageDesc:String?, deviceAddress:String?, deviceCode:String?, deviceName:String?, dirty:String?, emailId:String?, fpCardNumber:String?, fpPoints:String?, firstName:String?, friendlyName:String?, fromDate:String?, gateKey:String?, guestCustomerID:String?, identifierKey:String?, imageStream:String?, inspection:String?, isPrimary:Bool?, isRedeemPointAvailable:Bool?, isTicketFoundThroughVarSearParam:Bool?, lastName:String?, licenseState:String?, licenseTag:String?, location:String?, locationBottom:String?, locationFront:String?, locationID:String?, locationLeft:String?, locationRight:String?, locationTop:String?, make:String?, mileage:String?, model:String?, notes:String?, oversized:Bool?, parkingType:String?, parkingTypeName:String?, phoneNo:String?, redeemPoints:String?, reportDateTime:String?, reservations:String?, rewardDays:String?, selectedRedeemReservationInTicket:String?, selectedReservationInTicket:String?, services:NSMutableArray?, spaceDescription:String?, ticketDetailID:String?, ticketID:String?, ticketStatus:String?, tier:String?, toDate:String?, toDateValetScan:String?, valuables:String?, vehicleDamageID:String?, vehicleID:String?, year:String?, vehicleDamages:NSMutableArray?, discounts:NSMutableArray?, rsId:String?, vehicleDetails:VehicleDetailsBO?, reservationBO:ReservationAndFPCardDetailsBO?) {
        
        self.adhocDiscountPC = adhocDiscountPC
        self.barcodeNumberString = barcodeNumberString
        self.ccAssociatedWithFP = ccAssociatedWithFP
        self.color = color
        self.contCardEffectiveDate = contCardEffectiveDate
        self.contCardExpiryDate = contCardExpiryDate
        self.contractCardList = contractCardList
        self.contractCardNumber = contractCardNumber
        self.creditCardFirstSixLastFour = creditCardFirstSixLastFour
        self.creditCardTrackData = creditCardTrackData
        self.customerProfileID = customerProfileID
        self.damageDesc = damageDesc
        self.deviceAddress = deviceAddress
        self.deviceCode = deviceCode
        self.deviceName = deviceName
        self.dirty = dirty
        self.emailId = emailId
        self.fpCardNumber = fpCardNumber
        self.fpPoints = fpPoints
        self.firstName = firstName
        self.friendlyName = friendlyName
        self.fromDate = fromDate
        self.gateKey = gateKey
        self.guestCustomerID = guestCustomerID
        self.identifierKey = identifierKey
        self.imageStream = imageStream
        self.inspection = inspection
        self.isPrimary = isPrimary
        self.isRedeemPointAvailable = isRedeemPointAvailable
        self.isTicketFoundThroughVarSearParam = isTicketFoundThroughVarSearParam
        self.lastName = lastName
        self.licenseState = licenseState
        self.licenseTag = licenseTag
        self.location = location
        self.locationBottom = locationBottom
        self.locationFront = locationFront
        self.locationID = locationID
        self.locationLeft = locationLeft
        self.locationRight = locationRight
        self.locationTop = locationTop
        self.make = make
        self.mileage = mileage
        self.model = model
        self.notes = notes
        self.oversized = oversized
        self.parkingType = parkingType
        self.parkingTypeName = parkingTypeName
        self.phoneNo = phoneNo
        self.redeemPoints = redeemPoints
        self.reportDateTime = reportDateTime
        self.reservations = reservations
        self.rewardDays = rewardDays
        self.selectedRedeemReservationInTicket = selectedRedeemReservationInTicket
        self.selectedReservationInTicket = selectedReservationInTicket
        
        let tempServiceArray: NSMutableArray? = NSMutableArray()
        if let _ = services {
            services!.enumerateObjectsUsingBlock({ serviceObj, index, stop in
                tempServiceArray!.addObject((serviceObj as! ServiceBO).deepCopyOfServiceBO())
            })
        }
        self.services = tempServiceArray
        self.spaceDescription = spaceDescription
        self.ticketDetailID = ticketDetailID
        self.ticketID = ticketID
        self.ticketStatus = ticketStatus
        self.tier = tier
        self.toDate = toDate
        self.toDateValetScan = toDateValetScan
        self.valuables = valuables
        self.vehicleDamageID = vehicleDamageID
        self.vehicleID = vehicleID
        self.year = year
        
        let tempDicountsArray: NSMutableArray? = NSMutableArray()
        if let _ = discounts {
            discounts!.enumerateObjectsUsingBlock({ discountObj, index, stop in
                tempDicountsArray!.addObject((discountObj as! DiscountInfoBO).deepCopyOfDiscountInfoBO())
            })
        }
        self.discounts = tempDicountsArray
        self.rsId = rsId
        
        let tempVehicleDamagesArray: NSMutableArray? = NSMutableArray()
        if let _ = vehicleDamages {
            vehicleDamages!.enumerateObjectsUsingBlock({ vehicleDamageObj, index, stop in
                tempVehicleDamagesArray!.addObject((vehicleDamageObj as! VehicleDamageBO).deepCopyOfVehicleDamageBO())
            })
        }
        self.vehicleDamages = tempVehicleDamagesArray
        
        self.vehicleDetails = vehicleDetails?.copy() as? VehicleDetailsBO
        self.reservationBO = reservationBO?.copy() as? ReservationAndFPCardDetailsBO
    }
    
    func deepCopyOfTicketBO() -> TicketBO {
        
        let ticketBO = TicketBO(
            
            adhocDiscountPC: adhocDiscountPC,
            barcodeNumberString: barcodeNumberString,
            ccAssociatedWithFP: ccAssociatedWithFP,
            color: color,
            contCardEffectiveDate: contCardEffectiveDate,
            contCardExpiryDate: contCardExpiryDate,
            contractCardList: contractCardList,
            contractCardNumber: contractCardNumber,
            creditCardFirstSixLastFour: creditCardFirstSixLastFour,
            creditCardTrackData: creditCardTrackData,
            customerProfileID: customerProfileID,
            damageDesc: damageDesc,
            deviceAddress: deviceAddress,
            deviceCode: deviceCode,
            deviceName: deviceName,
            dirty: dirty,
            emailId: emailId,
            fpCardNumber: fpCardNumber,
            fpPoints: fpPoints,
            firstName: firstName,
            friendlyName: friendlyName,
            fromDate: fromDate,
            gateKey: gateKey,
            guestCustomerID: guestCustomerID,
            identifierKey: identifierKey,
            imageStream: imageStream,
            inspection: inspection,
            isPrimary: isPrimary,
            isRedeemPointAvailable: isRedeemPointAvailable,
            isTicketFoundThroughVarSearParam: isTicketFoundThroughVarSearParam,
            lastName: lastName,
            licenseState: licenseState,
            licenseTag: licenseTag,
            location: location,
            locationBottom: locationBottom,
            locationFront: locationFront,
            locationID: locationID,
            locationLeft: locationLeft,
            locationRight: locationRight,
            locationTop: locationTop,
            make: make,
            mileage: mileage,
            model: model,
            notes: notes,
            oversized: oversized,
            parkingType: parkingType,
            parkingTypeName: parkingTypeName,
            phoneNo: phoneNo,
            redeemPoints: redeemPoints,
            reportDateTime: reportDateTime,
            reservations: reservations,
            rewardDays: rewardDays,
            selectedRedeemReservationInTicket: selectedRedeemReservationInTicket,
            selectedReservationInTicket: selectedReservationInTicket,
            services: services,
            spaceDescription: spaceDescription,
            ticketDetailID: ticketDetailID,
            ticketID: ticketID,
            ticketStatus: ticketStatus,
            tier: tier,
            toDate: toDate,
            toDateValetScan: toDateValetScan,
            valuables: valuables,
            vehicleDamageID: vehicleDamageID,
            vehicleID: vehicleID,
            year: year,
            vehicleDamages: vehicleDamages,
            discounts: discounts,
            rsId: rsId,
            vehicleDetails: vehicleDetails,
            reservationBO: reservationBO
        )
        
        return ticketBO
    }*/
    
    func getTicketBOFromDictionary(_ attributeDict: NSDictionary) -> TicketBO {
        
        self.adhocDiscountPC = attributeDict.getInnerText(forKey: "a:AdhocDiscountPC")
        self.barcodeNumberString = attributeDict.getInnerText(forKey: "a:Barcode")
        self.prePrintedTicketNumber = attributeDict.getInnerText(forKey: "a:prePrintedTicketNumber")
        self.ccAssociatedWithFP = attributeDict.getAttributedData(forKey: "a:CCAssociatedWithFP")
        self.contCardEffectiveDate = attributeDict.getAttributedData(forKey: "a:ContCardEffectiveDate")
        self.contCardExpiryDate = attributeDict.getAttributedData(forKey: "a:ContCardExpiryDate")
        self.contractCardList = attributeDict.getInnerText(forKey: "a:ContractCardList")
        self.contractCardNumber = attributeDict.getInnerText(forKey: "a:ContractCardNumber")
        self.creditCardFirstSixLastFour = attributeDict.getAttributedData(forKey: "a:CreditCardFirstSixLastFour")
        self.creditCardTrackData = attributeDict.getAttributedData(forKey: "a:CreditCardTrackData")
        self.customerProfileID = attributeDict.getInnerText(forKey: "a:CustomerProfileID")
        self.damageDesc = attributeDict.getAttributedData(forKey: "a:DamageDesc")
        self.deviceAddress = attributeDict.getAttributedData(forKey: "a:DeviceAddress")
        self.deviceCode = attributeDict.getAttributedData(forKey: "a:DeviceCode")
        self.deviceName = attributeDict.getAttributedData(forKey: "a:DeviceName")
        self.dirty = attributeDict.getAttributedData(forKey: "a:Dirty")
        
        if let discountsDict = attributeDict.getObjectFromDictionary(withKeys: ["a:Discounts","a:DiscountInfo"]) {
            
            self.discounts = NSMutableArray()
            
            if (discountsDict as AnyObject) is NSArray {
                (discountsDict as AnyObject).enumerateObjects({ object, index, stop in
                    let discountInfo = DiscountInfoBO()
                    self.discounts?.add(discountInfo.getDiscountBOFromDictionary(object as! NSDictionary))
                })
            } else {
                let discountInfo = DiscountInfoBO()
                self.discounts?.add(discountInfo.getDiscountBOFromDictionary(discountsDict as! NSDictionary))
            }
        }
        
        self.emailId = attributeDict.getInnerText(forKey: "a:EmailId")
        
        if ((attributeDict["a:FPCardNumber"]) != nil){
            self.fpCardNumber = attributeDict.getInnerText(forKey: "a:FPCardNumber")
        } else if((attributeDict["a:Code"]) != nil) {
            self.fpCardNumber = attributeDict.getInnerText(forKey: "a:Code")
        }
        self.fpPoints = attributeDict.getInnerText(forKey: "a:FPPoints")
        self.firstName = attributeDict.getInnerText(forKey: "a:FirstName")
        self.friendlyName = attributeDict.getInnerText(forKey: "a:FriendlyName")
        
        if ((attributeDict["a:FromDate"]) != nil) {
          self.fromDate = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:FromDate"))
        } else if ((attributeDict["a:From"]) != nil) {
            self.fromDate = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:From"))
        } else if ((attributeDict["a:PrintDateTime"]) != nil){
            self.fromDate = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:PrintDateTime"))
        }
        
        self.gateKey = attributeDict.getInnerText(forKey: "a:GateKey")
        self.guestCustomerID = attributeDict.getAttributedData(forKey: "a:GuestCustomerID")
        self.identifierKey = attributeDict.getInnerText(forKey: "a:IdentifierKey")
        self.imageStream = attributeDict.getAttributedData(forKey: "a:ImageStream")
        self.inspection = attributeDict.getAttributedData(forKey: "a:Inspection")
        self.isPrimary = attributeDict.getBoolFromDictionary(withKeys: ["a:IsPrimary"])
        self.isRedeemPointAvailable = attributeDict.getBoolFromDictionary(withKeys: ["a:IsRedeemPointAvailable"])
        self.isTicketFoundThroughVarSearParam = attributeDict.getBoolFromDictionary(withKeys: ["a:IsTicketFoundThroughVarSearParam"])
        self.lastName = attributeDict.getInnerText(forKey: "a:LastName")
        self.licenseState = attributeDict.getAttributedData(forKey: "a:LicenseState")
        self.location = attributeDict.getAttributedData(forKey: "a:Location")
        self.locationBottom = attributeDict.getAttributedData(forKey: "a:LocationBottom")
        self.locationFront = attributeDict.getAttributedData(forKey: "a:LocationFront")
        self.locationID = String(attributeDict.getIntegerFromDictionary(withKeys: ["a:LocationID"]))
        self.locationLeft = attributeDict.getAttributedData(forKey: "a:LocationLeft")
        self.locationRight = attributeDict.getAttributedData(forKey: "a:LocationRight")
        self.locationTop = attributeDict.getAttributedData(forKey: "a:LocationTop")
        self.mileage = attributeDict.getAttributedData(forKey: "a:Mileage")
        self.notes = attributeDict.getAttributedData(forKey: "a:Notes")
        self.parkingType = attributeDict.getInnerText(forKey: "a:ParkingType")
        self.parkingTypeName = attributeDict.getInnerText(forKey: "a:ParkingTypeName")
        self.rsId = attributeDict.getInnerText(forKey: "a:rsId")
        
        if ((attributeDict["a:PhoneNo"]) != nil) {
            self.phoneNo = attributeDict.getInnerText(forKey: "a:PhoneNo")
        } else if ((attributeDict["a:PhoneNumber"]) != nil) {
            self.phoneNo = attributeDict.getInnerText(forKey: "a:PhoneNumber")
        }
        self.redeemPoints = attributeDict.getInnerText(forKey: "a:RedeemPoints")
        self.reportDateTime = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:ReportDateTime"))
        
        if ((attributeDict["a:Reservations"]) != nil){
           self.reservations = attributeDict.getInnerText(forKey: "a:Reservations")
        } else if ((attributeDict["a:ReservationCode"]) != nil){
            self.reservations = attributeDict.getInnerText(forKey: "a:ReservationCode")
        }
        
//        if let reservationDict = attributeDict.getObjectFromDictionaryWithKeys(["a:Reservations","a:PrepaidReservations"]) {
//            self.reservationBO = ReservationAndFPCardDetailsBO()
//            self.reservationBO = self.reservationBO?.getReservationAndFPCardDetailsBOFromTicketDetails(reservationDict as! NSDictionary)
//        }
        
        if let reservationsArray = attributeDict.getObjectFromDictionary(withKeys: ["a:Reservations","a:PrepaidReservations"]) {
            self.reservationsArray = [ReservationAndFPCardDetailsBO]()
            if (reservationsArray as AnyObject) is NSArray {
                (reservationsArray as AnyObject).enumerateObjects({object, index, stop in
                    let reservationBO = ReservationAndFPCardDetailsBO()
//                    self.services!.addObject(reservationBO.getReservationAndFPCardDetailsBOFromTicketDetails(object as! NSDictionary))
                    self.reservationsArray?.append(reservationBO.getReservationAndFPCardDetailsBOFromTicketDetails(object as! NSDictionary))
                })
            } else {
                let reservationBO = ReservationAndFPCardDetailsBO()
                self.reservationsArray?.append(reservationBO.getReservationAndFPCardDetailsBOFromTicketDetails(reservationsArray as! NSDictionary))
            }
        }
        
        self.rewardDays = attributeDict.getInnerText(forKey: "a:RewardDays")
        self.selectedRedeemReservationInTicket = attributeDict.getInnerText(forKey: "a:SelectedRedeemReservationInTicket")
        self.selectedReservationInTicket = attributeDict.getInnerText(forKey: "a:SelectedReservationInTicket")
        
        if let serviceArray = attributeDict.getObjectFromDictionary(withKeys: ["a:Services","a:AddService"]) {
            self.services = NSMutableArray()
            if (serviceArray as AnyObject) is NSArray {
                (serviceArray as AnyObject).enumerateObjects({object, index, stop in
                    let serviceBO = ServiceBO()
                    self.services!.add(serviceBO.getServiceBOFromDictionary(object as! NSDictionary))
                })
            } else {
                let serviceBO = ServiceBO()
                self.services!.add(serviceBO.getServiceBOFromDictionary(serviceArray as! NSDictionary))
            }
        }
        
        self.spaceDescription = attributeDict.getInnerText(forKey: "a:SpaceDescription")
        self.ticketDetailID = attributeDict.getInnerText(forKey: "a:TicketDetailID")
        self.ticketID = attributeDict.getInnerText(forKey: "a:TicketID")
        self.ticketStatus = attributeDict.getInnerText(forKey: "a:TicketStatus")
        self.tier = attributeDict.getInnerText(forKey: "a:Tier")
        
        if ((attributeDict["a:ToDate"]) != nil){
            self.toDate = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:ToDate"))
        } else if ((attributeDict["a:To"]) != nil){
            self.toDate = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:To"))
        }
        
        self.toDateValetScan = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:ToDateValetScan"))//2016-07-26T06:30:00
        self.valuables = attributeDict.getAttributedData(forKey: "a:Valuables")
        self.vehicleDamageID = String(attributeDict.getInnerText(forKey: "a:VehicleDamageID"))
        self.vehicleID = attributeDict.getInnerText(forKey: "a:VehicleID")
        
//        self.make = attributeDict.getInnerTextForKey("a:Make")
//        self.model = attributeDict.getInnerTextForKey("a:Model")
//        self.color = attributeDict.getInnerTextForKey("a:Color")
//        self.licenseTag = attributeDict.getInnerTextForKey("a:LicenseTag")
//        
//        self.year = attributeDict.getInnerTextForKey("a:Year")
//        self.oversized = attributeDict.getBoolFromDictionaryWithKeys(["a:Oversized"])
        
        self.vehicleDetails = VehicleDetailsBO()
        
        if let vehicleDetailsDict = attributeDict.getObjectFromDictionary(withKeys: ["a:VehicleDetails"]) {
            _ = self.vehicleDetails?.getVehicleDeails(vehicleDetailsDict as! NSDictionary)
        }
        
//        if self.vehicleDetails?.vehicleMake == nil || self.vehicleDetails?.vehicleMake?.characters.count == 0 {
//            self.vehicleDetails?.vehicleMake = self.make
//        }
//        
//        if self.vehicleDetails?.vehicleModel == nil || self.vehicleDetails?.vehicleModel?.characters.count == 0 {
//            self.vehicleDetails?.vehicleModel = self.model
//        }
//        
//        if self.vehicleDetails?.vehicleColor == nil || self.vehicleDetails?.vehicleColor?.characters.count == 0 {
//            self.vehicleDetails?.vehicleColor = self.color
//        }
//        
//        if self.vehicleDetails?.licenseNumber == nil || self.vehicleDetails?.licenseNumber?.characters.count == 0 {
//            self.vehicleDetails?.licenseNumber = self.licenseTag
//        }
//        
//        if self.vehicleDetails?.vehicleYear == nil || self.vehicleDetails?.vehicleYear?.characters.count == 0 {
//            self.vehicleDetails?.vehicleYear = self.year
//        }
//        
//        self.vehicleDetails?.isOversized = self.oversized!
        
        if let vehicleDamageArray = attributeDict.getObjectFromDictionary(withKeys: ["a:ticketVehicleDamage","a:TabletVehicleDamages"]) {
            
            self.vehicleDamages = NSMutableArray()
//            if ((vehicleDamageArray as AnyObject).isKind(of: NSArray()))
                if vehicleDamageArray is NSArray
            {
                (vehicleDamageArray as AnyObject).enumerateObjects({object, index, stop in
                    
                    let vehicleDamage = VehicleDamageBO()
                    
                    if (object as! NSDictionary).getInnerText(forKey: "a:Location") == "Damage" || (object as! NSDictionary).getInnerText(forKey: "a:Location") == "Valuable" {
                        
                        if let _ = UIImage(data: ObjectiveCCommonMethods.base64Data(from: (object as! NSDictionary).getInnerText(forKey: "a:ImageStream"))){
                            self.vehicleDamages!.add(vehicleDamage.getVehicleDamageBOFromDictionary(object as! NSDictionary))
                        }
                        
                    } else if (object as! NSDictionary).getInnerText(forKey: "a:Location") == "Skeleton" {
                        
                        self.vehicleDetails!.damageMarkImage = (object as! NSDictionary).getInnerText(forKey: "a:ImageStream")
                    }
                })
            } else {
                if (vehicleDamageArray as! NSDictionary).getInnerText(forKey: "a:Location") == "Damage" || (vehicleDamageArray as! NSDictionary).getInnerText(forKey: "a:Location") == "Valuable" {
                    let vehicleDamage = VehicleDamageBO()
                    self.vehicleDamages!.add(vehicleDamage.getVehicleDamageBOFromDictionary(vehicleDamageArray as! NSDictionary))
                } else if (vehicleDamageArray as! NSDictionary).getInnerText(forKey: "a:Location") == "Skeleton" {
                    
                    self.vehicleDetails!.damageMarkImage = (vehicleDamageArray as! NSDictionary).getInnerText(forKey: "a:ImageStream")
                }
            }
        }
        
        if let _ = attributeDict.getInnerText(forKey: "a:CreditCardTrackData"), attributeDict.getInnerText(forKey: "a:CreditCardTrackData").characters.count > 5 {
            self.creditCardInfo = CreditCardInfoBO()
            _ = self.creditCardInfo?.getCreditCardInfoBOFromTrackData(attributeDict.getInnerText(forKey: "a:CreditCardTrackData"))
        }
        
        return self
    }
}
