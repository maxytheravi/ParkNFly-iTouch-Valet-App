//
//  GenerateTicketForTabletService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 11/23/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
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


class GenerateTicketForTabletService: GenericServiceManager {
    
    let authenticateUser = naviController?.authenticateUser
    let userName = naviController?.userName
    var vehicleID: String?
    
    /**
     This method will create GenerateTicketForTablet API call request.
     
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func generateTicketForTabletService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        self.vehicleID = parameters ["VEHICLEID"] as? String
        if self.vehicleID?.characters.count == 0 && self.vehicleID == "" {
            self.vehicleID = "0"
        }
        let connection = ConnectionManager()
        connection.delegate = self
        let soapMessage = self.createTicketRequestXML()
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"GenerateTicketForTablet")
    }
    
    func createTicketRequestXML() -> String {
        
        let priprintedNumber = naviController?.priprintedNumber
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let updatedFirstName = naviController?.updatedFirstName != nil ? (naviController?.updatedFirstName)! : ""
        let updatedLastName = naviController?.updatedLastName != nil ? (naviController?.updatedLastName)! : ""
        let updatedParkingTypeID = naviController?.updatedParkingTypeID
        let shiftCode = naviController?.shiftCode
        //        let damageMarksArray = naviController?.vehicleDetails?.damageMarksArray
        
        var updatedDateTime = ""//(naviController?.updatedDate)! + "T" + (naviController?.updatedTime)!//"2015-11-30T13:17:23"
        
        if naviController?.updatedDate != nil && naviController?.updatedDate?.characters.count > 0 {
            updatedDateTime = (naviController?.updatedDate)!
        }
        
        if naviController?.updatedTime != nil && naviController?.updatedTime?.characters.count > 0 {
            updatedDateTime += "T" + (naviController?.updatedTime)!
        }
        
        var updatedDateTimeTag = ""
        if updatedDateTime.characters.count > 0 {
            updatedDateTimeTag = "<par:ExitDateTime>" + updatedDateTime + "</par:ExitDateTime>\n"
        } else {
            updatedDateTimeTag = "<par:ExitDateTime xsi:nil=\"true\" />"
        }
        
        let currentDateTime = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())//"2015-11-27T13:19:58"
        
        let vehicleColor: String = naviController?.vehicleDetails?.vehicleColor != nil ? (naviController?.vehicleDetails?.vehicleColor)! : ""
        let vehicleMake: String = naviController?.vehicleDetails?.vehicleMake != nil ? (naviController?.vehicleDetails?.vehicleMake)! : ""
        let vehicleModel: String = naviController?.vehicleDetails?.vehicleModel != nil ? (naviController?.vehicleDetails?.vehicleModel)! : ""
        let vehicleYear: String = naviController?.vehicleDetails?.vehicleYear != nil ? (naviController?.vehicleDetails?.vehicleYear)! : ""
        //        let damageMarkImage: String = naviController?.vehicleDetails?.damageMarkImage != nil ? (naviController?.vehicleDetails?.damageMarkImage)! : ""
        //        let vehicleVIN: String = naviController?.vehicleDetails?.vehicleVIN != nil ? (naviController?.vehicleDetails?.vehicleVIN)! : ""
        let vehicleTag: String = naviController?.vehicleDetails?.licenseNumber != nil ? (naviController?.vehicleDetails?.licenseNumber)! : ""
        
        let vehicleDetailsBO = naviController?.vehicleDetails
        
        let reservationDetails: ReservationAndFPCardDetailsBO? = naviController?.reservationDetails
        
        let isOversizeVehicle = naviController?.isOversizeVehicle == true ? "true" : "false"
        
        var phoneNumber = ""
        if naviController?.phoneNumber != nil && naviController?.phoneNumber?.characters.count > 0 {
            phoneNumber = "\((naviController?.phoneNumber)!)"
        }
        
        var identifierKey: String?
        var customerProfileID: String?
        var contractCardIDTag: String = ""
        if let _ = naviController?.contractCardDetails, let _ = naviController?.contractCardDetails?.contractCardNumbersID, naviController?.contractCardDetails?.contractCardNumbersID?.characters.count > 0
        {
            let contractCardID: String = "\((naviController?.contractCardDetails?.contractCardNumbersID)!)"
            contractCardIDTag = "<par:ContractCardNumbetID>" + "\(contractCardID)" + "</par:ContractCardNumbetID>\n"
        }else
        {
            contractCardIDTag = "<par:ContractCardNumbetID xsi:nil=\"true\" />\n"
        }
        //        if let _ = naviController?.reservationDetails {
        identifierKey = naviController?.reservationDetails?.fpCode
        customerProfileID = naviController?.reservationDetails?.customerProfileID
        //        } else {
        //            identifierKey = naviController?.reservationDetails?.fpCode
        //            customerProfileID = naviController?.reservationDetails?.customerProfileID
        //        }
        
        var creditCardFirstSixLastFourTag = ""
        var creditCardTrackDataTag = ""
        
        if let _ = naviController?.creditCardInfo, let _ = naviController?.creditCardInfo?.cardNumber, naviController?.creditCardInfo?.cardNumber?.characters.count > 0 {
            
            let cardNo: String = "\((naviController?.creditCardInfo!.cardNumber)!)"
            
            let creditCardFirstSixLastFour = String(cardNo.characters.prefix(6)) + String(cardNo.characters.suffix(4))
            creditCardFirstSixLastFourTag = "<par:CreditCardFirstSixLastFour>" + "\(creditCardFirstSixLastFour)" + "</par:CreditCardFirstSixLastFour>\n"
            
            let cardData = "\(cardNo)" + "=" + "\((naviController?.creditCardInfo?.expiryYear)!)" + "\((naviController?.creditCardInfo?.expiryMonth)!)"
            let encryptedCardData = Encryptor.encrypt(cardData)
            creditCardTrackDataTag = "<par:CreditCardTrackData>" + "\(encryptedCardData!)" + "</par:CreditCardTrackData>\n"
        } else {
            creditCardFirstSixLastFourTag = "<par:CreditCardFirstSixLastFour xsi:nil=\"true\" />\n"
            creditCardTrackDataTag = "<par:CreditCardTrackData></par:CreditCardTrackData>\n"
        }
        
        let identifierKeyTag = identifierKey != nil && identifierKey?.characters.count > 0 ? ("<par:IdentifierKey>" + "\(identifierKey!)" + "</par:IdentifierKey>\n") : "<par:IdentifierKey xsi:nil=\"true\" />\n"
        
        let customerProfileIDTag = customerProfileID != nil ? ("<par:CustomerProfileID>" + "\(customerProfileID!)" + "</par:CustomerProfileID>\n") : "<par:CustomerProfileID xsi:nil=\"true\" />\n"
        
        let ticketXML: String =
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
                + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:tem=\"http://tempuri.org/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
                + "<soapenv:Header />\n"
                + "<soapenv:Body>\n"
                + "<tem:GenerateTicketForTablet>\n"
                + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
                + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
                + "<tem:LanguageCode></tem:LanguageCode>\n"
                + "<tem:tabletTicket>\n"
                + "<par:Barcode>" + priprintedNumber! + "</par:Barcode>\n"
                + "<par:CashierUserName>" + authenticateUser! + "\\" + userName! + "</par:CashierUserName>\n"
                + contractCardIDTag
                + ""
//                + "<par:ContractCardNumbetID>" + "\(contractCardID)" + "</par:ContractCardNumbetID>\n"
                + creditCardFirstSixLastFourTag
                + ""
                + creditCardTrackDataTag
                + ""
                + customerProfileIDTag
                + "<par:DeviceCode>" + deviceCode! + "</par:DeviceCode>\n"
                //Discounts
                /*+ "<par:DiscountInfo>\n"
                 + self.createDiscountsRequestXML()
                 + "</par:DiscountInfo>\n"*/
                + "<par:DiscountInfo />\n"
                //
                + updatedDateTimeTag
                + "<par:FacilityCode>" + facilityCode! + "</par:FacilityCode>\n"
                + "<par:GateKey xsi:nil=\"true\" />\n"
                //GuestCustomerInfo
                + "<par:GuestCustomerInfo>\n"
                + "<par:TabletGuestCustomer>\n"
                + "<par:Address xsi:nil=\"true\" />\n"
                + "<par:City xsi:nil=\"true\" />\n"
                + "<par:Color>" + vehicleColor + "</par:Color>\n"
                + "<par:EmailAddress xsi:nil=\"true\" />\n"
                + "<par:FirstName>" + updatedFirstName + "</par:FirstName>\n"
                + "<par:FriendlyName xsi:nil=\"true\" />\n"
                + "<par:GuestCustomerID>0</par:GuestCustomerID>\n"//HardCode
                + "<par:LastName>" + updatedLastName + "</par:LastName>\n"
                + "<par:Make>" + vehicleMake + "</par:Make>\n"
                + "<par:Model>" + vehicleModel + "</par:Model>\n"
                + "<par:Oversized>" + isOversizeVehicle + "</par:Oversized>\n"
                + "<par:PhoneNumber>" + phoneNumber + "</par:PhoneNumber>\n"
                + "<par:StateID xsi:nil=\"true\" />\n"
                + "<par:Tag>" + vehicleTag + "</par:Tag>\n"
                + "<par:Year>" + vehicleYear + "</par:Year>\n"
                + "<par:Zip xsi:nil=\"true\" />\n"
                + "</par:TabletGuestCustomer>\n"
                + "</par:GuestCustomerInfo>\n"
                //
                + identifierKeyTag
                + "<par:ImageStream />\n"//HardCode
                + "<par:LocationID xsi:nil=\"true\" />\n"
                + "<par:ParkingTypeID>" + "\(updatedParkingTypeID!)" + "</par:ParkingTypeID>\n"
                + "<par:PrintDateTime>" + currentDateTime + "</par:PrintDateTime>\n"
                //ReservationInfo
                + self.createReservationRequestXML(reservationDetails)
                + ""
                /*+ "<par:ReservationInfo />\n"*/
                //
                //Services
                + self.createServicesRequestXML()
                /*+ "<par:ServiceInfo />\n"*/
                //
                + "<par:ShiftCode>" + shiftCode! + "</par:ShiftCode>\n"
                + "<par:SpaceDescription></par:SpaceDescription>\n"
                + "<par:TicketStatus>1</par:TicketStatus>\n"//HardCode
                //VehicleDamageInfo
                /*+ "<par:VehicleDamageInfo>\n"
                 + self.createVehicleDamagesRequestXML(ticketBO.vehicleDamages!)
                 + "</par:VehicleDamageInfo>\n"*/
                + "<par:VehicleDamageInfo />\n"
                //
                //VehicleDetails
                //            + "<par:VehicleDetail>\n"
                //            + "<par:Color>" + vehicleColor + "</par:Color>\n"
                //            //DamageDetails
                //            + self.createDamageDetailsRequestXML(damageMarksArray)
                //            //
                //            + "<par:DamageImage>" + damageMarkImage + "</par:DamageImage>\n"
                //            + "<par:Make>" + vehicleMake + "</par:Make>\n"
                //            + "<par:Model>" + vehicleModel + "</par:Model>\n"
                //            + "<par:TicketID>0</par:TicketID>\n"//HardCode
                //            + "<par:VIN>" + vehicleVIN + "</par:VIN>\n"
                //            + "<par:Year>" + vehicleYear + "</par:Year>\n"
                //            + "</par:VehicleDetail>\n"
                + self.createVehicleDetailRequestXML(vehicleDetailsBO)
                //
                + "<par:VehicleID>" + self.vehicleID! + "</par:VehicleID>\n"
                + "<par:VehicleValuableInfo />\n"
                + "</tem:tabletTicket>\n"
                + "</tem:GenerateTicketForTablet>\n"
                + "</soapenv:Body>\n"
                + "</soapenv:Envelope>\n"
        
        return ticketXML
    }
    
    func createVehicleDetailRequestXML(_ vehicleDetailsBO: VehicleDetailsBO?) -> String {
        
        var vehicleDetailXML: String = ""
        
        if vehicleDetailsBO != nil/* && vehicleDetailsBO?.vehicleMake != nil && vehicleDetailsBO?.vehicleMake != ""*/ {
            
            let vehicleColor: String = vehicleDetailsBO?.vehicleColor != nil ? (vehicleDetailsBO?.vehicleColor)! : ""
            let damageMarkImage: String = naviController?.vehicleDetails?.damageMarkImage != nil ? (naviController?.vehicleDetails?.damageMarkImage)! : ""
            let vehicleMake: String = vehicleDetailsBO?.vehicleMake != nil ? (vehicleDetailsBO?.vehicleMake)! : ""
            let vehicleModel: String = vehicleDetailsBO?.vehicleModel != nil ? (vehicleDetailsBO?.vehicleModel)! : ""
            let vehicleYear: String = vehicleDetailsBO?.vehicleYear != nil ? (vehicleDetailsBO?.vehicleYear)! : ""
            let vehicleVIN: String = vehicleDetailsBO?.vehicleVIN != nil ? (vehicleDetailsBO?.vehicleVIN)! : ""
            
            vehicleDetailXML = "<par:VehicleDetail>\n"
                + "<par:Color>" + vehicleColor + "</par:Color>\n"
                //DamageDetails
                + self.createDamageDetailsRequestXML(vehicleDetailsBO?.damageMarksArray)
                //
                + "<par:DamageImage>" + damageMarkImage + "</par:DamageImage>\n"
                + "<par:Make>" + vehicleMake + "</par:Make>\n"
                + "<par:Model>" + vehicleModel + "</par:Model>\n"
                + "<par:TicketID>0</par:TicketID>\n"//HardCode
                + "<par:VIN>" + vehicleVIN + "</par:VIN>\n"
                + "<par:Year>" + vehicleYear + "</par:Year>\n"
                + "</par:VehicleDetail>\n"
            
        } else {
            vehicleDetailXML = "<par:VehicleDetail />\n"
        }
        
        return vehicleDetailXML
    }
    
    //    func reservationRequestXML() -> String {
    //
    //        var reservationXML: String = ""
    //        let reservationArray = NSMutableArray()
    //
    //        if reservationArray.count > 0 {
    //            reservationXML += "<par:ReservationInfo>\n"
    //            reservationArray.enumerateObjectsUsingBlock({ reservationObj, index, stop in
    //                reservationXML += self.createReservationRequestXML(reservationObj as! DiscountInfoBO)
    //            })
    //            reservationXML += "</par:ReservationInfo>\n"
    //        }else {
    //            reservationXML = "<tem:ReservationInfo />\n"
    //        }
    //
    //        return reservationXML
    //    }
    
    func createReservationRequestXML(_ reservationDetails: ReservationAndFPCardDetailsBO?) -> String {
        
        var reservationXML: String = ""
        
        if reservationDetails != nil && reservationDetails!.reservationCode != nil && reservationDetails!.reservationCode != "" {
            
            reservationXML = "<par:ReservationInfo>\n"
                + "<par:PrepaidReservations>\n"
                + "<par:ParkingType>" + "\((reservationDetails?.parkingType)!)" + "</par:ParkingType>\n"
                + "<par:RedeemVoucherNumber></par:RedeemVoucherNumber>\n"
                + "<par:ResEndDate>" + "\((reservationDetails?.toDate)!)" + "</par:ResEndDate>\n"
                + "<par:ResStartDate>" + "\((reservationDetails?.fromDate)!)" + "</par:ResStartDate>\n"
                + "<par:ReservationCode>" + "\((reservationDetails?.reservationCode)!)" + "</par:ReservationCode>\n"
                + "<par:ReservationPhone>" + "\((reservationDetails?.phoneNumber)!)" + "</par:ReservationPhone>\n"
                + "</par:PrepaidReservations>\n"
                + "</par:ReservationInfo>\n"
            
        } else {
            reservationXML = "<par:ReservationInfo />\n"
        }
        
        return reservationXML
    }
    
    func createDamageDetailsRequestXML(_ damageMarksArray: [DamageMarkBO]?) -> String {
        
        var damageMarksXML: String = ""
        
        if damageMarksArray != nil && damageMarksArray!.count > 0 {
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
    
    func createDiscountsRequestXML() -> String {
        
        var discountsXML: String = ""
        let discountsArray = NSMutableArray()
        
        if discountsArray.count > 0 {
            discountsXML += "<par:DiscountInfo>\n"
            discountsArray.enumerateObjects({ discountObj, index, stop in
                discountsXML += self.createDiscountRequestXML(discountObj as! DiscountInfoBO)
            })
            discountsXML += "</par:DiscountInfo>\n"
        }else {
            discountsXML = "<par:DiscountInfo />\n"
        }
        return discountsXML
    }
    
    func createDiscountRequestXML(_ discountInfoBO: DiscountInfoBO) -> String {
        
        let discountXML: String = "<par:DiscountInfo>\n"
            + "<par:ActualDays>" + discountInfoBO.actualDays! + "</par:ActualDays>\n"
            + "<par:ActualHours>" + discountInfoBO.actualHours! + "</par:ActualHours>\n"
            + "<par:AllDiscountParkingValue>" + discountInfoBO.allDiscountParkingValue! + "</par:AllDiscountParkingValue>\n"
            + "<par:AllDiscountServicesValue>" + discountInfoBO.allDiscountServicesValue! + "</par:AllDiscountServicesValue>\n"
            + "<par:AllowMultiple>" + "\(discountInfoBO.allowMultiple!)" + "</par:AllowMultiple>\n"
            + "<par:AppliedDate></par:AppliedDate>\n"
            + "<par:ArrivalDay>" + /*discountInfoBO.arrivalDay!*/ "0" + "</par:ArrivalDay>\n" //arrival day should be int type ex. 0
            + "<par:CanCombine>" + discountInfoBO.canCombine! + "</par:CanCombine>\n"
            + "<par:ChannelID>" + discountInfoBO.channelID! + "</par:ChannelID>\n"
            + "<par:ChannelName />\n"
            + "<par:CouponApply>" + discountInfoBO.couponApply! + "</par:CouponApply>\n"
            + "<par:CouponCode />\n"
            + "<par:CouponExpirationDate xsi:nil=\"true\" />\n"
            + "<par:DailyCharge>" + discountInfoBO.dailyCharge! + "</par:DailyCharge>\n"
            + "<par:DailyRate>" + discountInfoBO.dailyRate! + "</par:DailyRate>\n"
            + "<par:DiscountApplyTo>" + discountInfoBO.discountApplyTo! + "</par:DiscountApplyTo>\n"
            + "<par:DiscountCode />\n"
            + "<par:DiscountDesc />\n"
            + "<par:DiscountID>" + discountInfoBO.discountID! + "</par:DiscountID>\n"
            + "<par:DiscountName />\n"
            + "<par:DiscountOrder></par:DiscountOrder>\n"
            + "<par:DiscountTypeID>" + discountInfoBO.discountTypeID! + "</par:DiscountTypeID>\n"
            + "<par:DiscountUnitID>" + discountInfoBO.discountUnitID! + "</par:DiscountUnitID>\n"
            + "<par:DiscountValue>" + discountInfoBO.discountValue! + "</par:DiscountValue>\n"
            + "<par:EndDate xsi:nil=\"true\" />\n"
            + "<par:FreeDuration></par:FreeDuration>\n"
            + "<par:HourlyCharge>" + discountInfoBO.hourlyCharge! + "</par:HourlyCharge>\n"
            + "<par:HourlyRate>" + discountInfoBO.hourlyRate! + "</par:HourlyRate>\n"
            + "<par:IsActive>" + "\(discountInfoBO.isActive!)" + "</par:IsActive>\n"
            + "<par:IsCap>" + "\(discountInfoBO.isCap!)" + "</par:IsCap>\n"
            + "<par:IsCouponAlreadyUsed>" + "\(discountInfoBO.isCouponAlreadyUsed!)" + "</par:IsCouponAlreadyUsed>\n"
            + "<par:IsDiscountOnOverstay></par:IsDiscountOnOverstay>\n"
            + "<par:IsRequiredStayAll>" + "\(discountInfoBO.isRequiredStayAll!)" + "</par:IsRequiredStayAll>\n"
            + "<par:IsSelected>" + "\(discountInfoBO.isSelected!)" + "</par:IsSelected>\n"
            + "<par:IsValid>" + "\(discountInfoBO.isValid!)" + "</par:IsValid>\n"
            + "<par:MaxDuration xsi:nil=\"true\" />\n"
            + "<par:MaxDurationUnitID xsi:nil=\"true\" />\n"
            + "<par:MinDuration xsi:nil=\"true\" />\n"
            + "<par:MinDurationUnitID xsi:nil=\"true\" />\n"
            + "<par:MonthlyCharge>" + discountInfoBO.monthlyCharge! + "</par:MonthlyCharge>\n"
            + "<par:MonthlyRate>" + discountInfoBO.monthlyRate! + "</par:MonthlyRate>\n"
            + "<par:Occurance></par:Occurance>\n"
            + "<par:ParkingTypeID>" + discountInfoBO.parkingTypeID! + "</par:ParkingTypeID>\n"
            + "<par:Quantity>" + discountInfoBO.quantity! + "</par:Quantity>\n"
            + "<par:RequiredStay>" + discountInfoBO.requiredStay! + "</par:RequiredStay>\n"
            + "<par:ShowUpFront>" + discountInfoBO.showUpFront! + "</par:ShowUpFront>\n"
            + "<par:StartDate>" + discountInfoBO.startDate! + "</par:StartDate>\n"
            + "<par:TaxesExempted />\n"
            + "<par:TotalCharge>" + discountInfoBO.totalCharge! + "</par:TotalCharge>\n"
            + "<par:TotalDiscount>" + discountInfoBO.totalDiscount! + "</par:TotalDiscount>\n"
            + "<par:UniqID>" + discountInfoBO.uniqID! + "</par:UniqID>\n"
            + "<par:ValidationID>" + discountInfoBO.validationID! + "</par:ValidationID>\n"
            + "<par:ValidationMessage />\n"
            + "<par:WeeklyCharge>" + discountInfoBO.weeklyCharge! + "</par:WeeklyCharge>\n"
            + "<par:WeeklyRate>" + discountInfoBO.weeklyRate! + "</par:WeeklyRate>\n"
            + "</par:DiscountInfo>\n"
        
        return discountXML
    }
    
    func createServicesRequestXML() -> String {
        
        var servicesXML: String = ""
        
        if naviController?.servicesArray?.count > 0 {
            
            let filteredServicesArray = naviController?.servicesArray!.filter( { (serviceBO: ServiceBO) -> Bool in
                return serviceBO.isSwitchOn == true
            })
            
            if filteredServicesArray!.count > 0 {
                servicesXML += "<par:ServiceInfo>\n"
                for serviceBO in filteredServicesArray! {
                    servicesXML += self.createServiceRequestXML(serviceBO)
                }
                servicesXML += "</par:ServiceInfo>\n"
            } else {
                servicesXML = "<par:ServiceInfo />\n"
            }
        } else {
            servicesXML = "<par:ServiceInfo />\n"
        }
        
        return servicesXML
    }
    
    func createServiceRequestXML(_ serviceBO: ServiceBO) -> String {
        
        /*let serviceXML: String = "<par:AddService>\n"
         + "<par:AllowMultiple></par:AllowMultiple>\n"
         + "<par:AllowOverSize xsi:nil=\"true\" />\n"
         + "<par:DiscountedServiceCharge>" + "\(serviceBO.discountedServiceCharge!)" + "</par:DiscountedServiceCharge>\n"
         + "<par:FacilityID>" + "\(serviceBO.facilityID!)" + "</par:FacilityID>\n"
         + "<par:FinalServiceDiscount></par:FinalServiceDiscount>\n"
         + "<par:IsEnabled>" + "\(serviceBO.isEnabled!)" + "</par:IsEnabled>\n"
         + "<par:IsOverSizeChargeApplicable>" + "\(serviceBO.isOverSizeChargeApplicable!)" + "</par:IsOverSizeChargeApplicable>\n"
         + "<par:IsSelected>" + "\(serviceBO.isSelected!)" + "</par:IsSelected>\n"
         + " <par:IsTaxable></par:IsTaxable>\n"
         + "<par:IsVariablePrice></par:IsVariablePrice>\n"
         + "<par:OversizeCharge xsi:nil=\"true\" />\n"
         + "<par:Quantifiable xsi:nil=\"true\" />\n"
         + "<par:Quantity>" + "\(serviceBO.quantity!)" + "</par:Quantity>\n"
         + "<par:ServiceCharge>" + "\(serviceBO.serviceCharge!)" + "</par:ServiceCharge>\n"
         + "<par:ServiceCode />\n"
         + "<par:ServiceDesc />\n"
         + "<par:ServiceID>" + "\(serviceBO.serviceID!)" + "</par:ServiceID>\n"
         + "<par:ServiceName />\n"
         + "<par:ServiceNotes>" + serviceBO.serviceNotes! + "</par:ServiceNotes>\n"
         + "<par:ServiceTypeID>" + "\(serviceBO.serviceTypeID!)" + "</par:ServiceTypeID>\n"
         + "<par:Taxes xsi:nil=\"true\" />\n"
         + "<par:TotalServiceCharge>" + "\(serviceBO.totalServiceCharge!)" + "</par:TotalServiceCharge>\n"
         + "<par:TotalServiceDiscount>" + "\(serviceBO.totalServiceDiscount!)" + "</par:TotalServiceDiscount>\n"
         + "<par:VariableServiceCharge>" + "\(serviceBO.variableServiceCharge!)" + "</par:VariableServiceCharge>\n"
         + "</par:AddService>\n"*/
        
        var serviceNotes = ""
        if serviceBO.serviceNotes != nil && serviceBO.serviceNotes?.characters.count > 0 {
            serviceNotes = (serviceBO.serviceNotes)!
        }
        
        var serviceCompletedTag = ""
        if serviceBO.serviceCompleted != nil && serviceBO.serviceCompleted?.characters.count > 0 {
            serviceCompletedTag = "<par:ServiceCompleted>" + (serviceBO.serviceCompleted)! + "</par:ServiceCompleted>\n"
        } else {
            serviceCompletedTag = "<par:ServiceCompleted xsi:nil=\"true\"></par:ServiceCompleted>\n"
        }
        
        var appliedDateTag = ""
        if serviceBO.appliedDate != nil && serviceBO.appliedDate?.characters.count > 0 {
            appliedDateTag = "<par:AppliedDate>" + (serviceBO.appliedDate)! + "</par:AppliedDate>\n"
        } else {
            appliedDateTag = "<par:AppliedDate xsi:nil=\"true\"></par:AppliedDate>\n"
        }
        
        //        let serviceNotes = (serviceBO.serviceNotes != nil) ? (serviceBO.serviceNotes)! : ""
        
        /*let serviceXML: String = "<par:AddService>"
         + "<par:AllowOverSize xsi:nil=\"true\" />\n"
         + "<par:DiscountedServiceCharge>0</par:DiscountedServiceCharge>\n"//HardCode
         + "<par:FacilityID>" + "\(serviceBO.facilityID!)" + "</par:FacilityID>\n"
         + "<par:IsEnabled>" + "\(serviceBO.isEnabled!)" + "</par:IsEnabled>\n"
         + "<par:IsOverSizeChargeApplicable>" + "\(serviceBO.isOverSizeChargeApplicable!)" + "</par:IsOverSizeChargeApplicable>\n"
         + "<par:IsSelected>" + "\(serviceBO.isSelected!)" + "</par:IsSelected>\n"
         + "<par:OversizeCharge xsi:nil=\"true\" />\n"
         + "<par:Quantifiable xsi:nil=\"true\" />\n"
         + "<par:Quantity>" + "\(serviceBO.quantity!)" + "</par:Quantity>\n"
         + "<par:ServiceCharge>0</par:ServiceCharge>\n"//HardCode
         + "<par:ServiceCode />\n"
         + "<par:ServiceDesc />\n"
         + "<par:ServiceID>" + "\(serviceBO.serviceID!)" + "</par:ServiceID>\n"
         + "<par:ServiceName />\n"
         + "<par:ServiceNotes>" + serviceNotes + "</par:ServiceNotes>\n"
         + "<par:ServiceTypeID>0</par:ServiceTypeID>\n"//HardCode
         + "<par:Taxes xsi:nil=\"true\" />\n"
         + "<par:TotalServiceCharge>0</par:TotalServiceCharge>\n"//HardCode
         + "<par:TotalServiceDiscount>0</par:TotalServiceDiscount>\n"//HardCode
         + "<par:VariableServiceCharge>" + "\(serviceBO.variableServiceCharge!)" + "</par:VariableServiceCharge>\n"
         + "</par:AddService>"*/
        
        //" + (serviceBO.)! + "
        //" + "\((serviceBO.)!)" + "
        
        let serviceXML: String = "<par:AddService>\n"
            + "<par:AllowMultiple>" + "\((serviceBO.allowMultiple)!)" + "</par:AllowMultiple>\n"
            + "<par:AllowOverSize xsi:nil=\"true\"></par:AllowOverSize>\n"
            + appliedDateTag
            + "<par:CashierUserName>" + authenticateUser! + "\\" + userName! + "</par:CashierUserName>\n"
            + "<par:DiscountedServiceCharge>" + "\((serviceBO.discountedServiceCharge)!)" + "</par:DiscountedServiceCharge>\n"
            + "<par:FacilityID>" + "\((serviceBO.facilityID)!)" + "</par:FacilityID>\n"
            + "<par:FinalServiceDiscount>" + "\((serviceBO.finalServiceDiscount)!)" + "</par:FinalServiceDiscount>\n"
            + "<par:IsEnabled>" + "\((serviceBO.isEnabled)!)" + "</par:IsEnabled>\n"
            + "<par:IsOverSizeChargeApplicable>" + "\((serviceBO.isOverSizeChargeApplicable)!)" + "</par:IsOverSizeChargeApplicable>\n"
            + "<par:IsSelected>" + "\((serviceBO.isSelected)!)" + "</par:IsSelected>\n"
            + "<par:IsTaxable>" + "\((serviceBO.isTaxable)!)" + "</par:IsTaxable>\n"
            + "<par:IsVariablePrice>" + "\((serviceBO.isVariablePrice)!)" + "</par:IsVariablePrice>\n"
            + "<par:OversizeCharge xsi:nil=\"true\"></par:OversizeCharge>\n"
            + "<par:Quantifiable>" + "\((serviceBO.quantifiable)!)" + "</par:Quantifiable>\n"
            + "<par:Quantity>" + "\((serviceBO.quantity)!)" + "</par:Quantity>\n"
            + "<par:ServiceCharge>" + "\((serviceBO.serviceCharge)!)" + "</par:ServiceCharge>\n"
            + "<par:ServiceCode>" + (serviceBO.serviceCode)! + "</par:ServiceCode>\n"
            + serviceCompletedTag
            + "<par:ServiceDate xsi:nil=\"true\"></par:ServiceDate>\n"
            + "<par:ServiceDesc>" + (serviceBO.serviceDesc)! + "</par:ServiceDesc>\n"
            + "<par:ServiceID>" + "\((serviceBO.serviceID)!)" + "</par:ServiceID>\n"
            + "<par:ServiceName>" + (serviceBO.serviceName)! + "</par:ServiceName>\n"
            + "<par:ServiceNotes>" + serviceNotes + "</par:ServiceNotes>\n"
            + "<par:ServiceTechnician>" + (serviceBO.serviceTechnician)! + "</par:ServiceTechnician>\n"
            + "<par:ServiceTypeID>" + "\((serviceBO.serviceTypeID)!)" + "</par:ServiceTypeID>\n"
            + "<par:Taxes xsi:nil=\"true\"></par:Taxes>\n"
            + "<par:TotalServiceCharge>" + "\((serviceBO.totalServiceCharge)!)" + "</par:TotalServiceCharge>\n"
            + "<par:TotalServiceDiscount>" + "\((serviceBO.totalServiceDiscount)!)" + "</par:TotalServiceDiscount>\n"
            + "<par:VariableServiceCharge>" + "\((serviceBO.variableServiceCharge)!)" + "</par:VariableServiceCharge>\n"
            + "</par:AddService>\n"
        
        return serviceXML
    }
    
    func createVehicleDamagesRequestXML() -> String {
        
        var vehicleDamagesXML: String = ""
        let vehicleDamagesArray = NSMutableArray()
        
        if vehicleDamagesArray.count > 0 {
            vehicleDamagesArray.enumerateObjects({ vehicleDamageObj, index, stop in
                vehicleDamagesXML += self.createVehicleDamageRequestXML(vehicleDamageObj as! VehicleDamageBO)
            })
        } else {
            vehicleDamagesXML = "<par:VehicleDamageInfo/>\n"
        }
        
        return vehicleDamagesXML
    }
    
    func createVehicleDamageRequestXML(_ vehicleDamageBO: VehicleDamageBO) -> String {
        
        let vehicleDamageXML: String = "<par:TabletVehicleDamages>\n"
            + "<par:DamageDesc>" + vehicleDamageBO.damageDesc! + "</par:DamageDesc>\n"
            + "<par:ImageName></par:ImageName>\n"
            + "<par:ImageStream>" + vehicleDamageBO.imageStream! + "</par:ImageStream>\n"
            + "<par:Location>" + vehicleDamageBO.location! + "</par:Location>\n"
            + "<par:ReportDateTime>" + vehicleDamageBO.reportDateTime! + "</par:ReportDateTime>\n"
            + "<par:TicketID>" + "\(vehicleDamageBO.ticketId!)" + "</par:TicketID>\n"
            + "<par:VehicleDamageID>" + "\(vehicleDamageBO.vehicleDamageId!)" + "</par:VehicleDamageID>\n"
            + "</par:TabletVehicleDamages>\n"
        
        return vehicleDamageXML
    }
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        
        if dict.getObjectFromDictionary(withKeys: ["GenerateTicketForTabletResponse","GenerateTicketForTabletResult"]) != nil {
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: dict)
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
