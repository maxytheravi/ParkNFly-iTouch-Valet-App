//
//  UpdateValetInfoForTabletService.swift
//  ParkNFlyiTouch
//
//  Created by Smita Tamboli on 10/27/15.
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


class UpdateValetInfoForTabletService: GenericServiceManager {
    
    let authenticateUser = naviController?.authenticateUser
    let userName = naviController?.userName
    
    func updateValetInfoForTabletWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        
        let soapMessage = self.createTicketRequestXML(parameters["Ticket"] as! TicketBO)
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"UpdateValetInfoForTablet")
    }
    
    func createTicketRequestXML(_ ticketBO: TicketBO) -> String {
        
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
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
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let updatedParkingTypeID = naviController?.updatedParkingTypeID
        let shiftCode = naviController?.shiftCode
        
        var vehicleColor = ""
        if ticketBO.vehicleDetails?.vehicleColor != nil && ticketBO.vehicleDetails?.vehicleColor?.characters.count > 0 {
            vehicleColor = (ticketBO.vehicleDetails?.vehicleColor)!
        }
        var damageMarkImage = ""
        if ticketBO.vehicleDetails?.damageMarkImage?.characters.count > 0 {
            damageMarkImage = (ticketBO.vehicleDetails?.damageMarkImage)!
        }
        var vehicleMake = ""
        if ticketBO.vehicleDetails?.vehicleMake?.characters.count > 0 {
            vehicleMake = (ticketBO.vehicleDetails?.vehicleMake)!
        }
        var vehicleModel = ""
        if ticketBO.vehicleDetails?.vehicleModel?.characters.count > 0 {
            vehicleModel = (ticketBO.vehicleDetails?.vehicleModel)!
        }
        var vehicleVIN = ""
        if ticketBO.vehicleDetails?.vehicleVIN?.characters.count > 0 {
            vehicleVIN = (ticketBO.vehicleDetails?.vehicleVIN)!
        }
        var vehicleYear = ""
        if ticketBO.vehicleDetails?.vehicleYear?.characters.count > 0 {
            vehicleYear = (ticketBO.vehicleDetails?.vehicleYear)!
        }
        var isOversized = false
        if let oversizeVehicleFlag = ticketBO.vehicleDetails?.isOversized {
            isOversized = oversizeVehicleFlag
        }
        
        let vehicleTag = ticketBO.vehicleDetails?.licenseNumber
        let damageMarksArray = ticketBO.vehicleDetails?.damageMarksArray
        
        let customerProfileID = ticketBO.customerProfileID
        let customerProfileTag = customerProfileID != nil && customerProfileID?.characters.count > 0 ? ("<par:CustomerProfileID>" + customerProfileID! + "</par:CustomerProfileID>\n") : "<par:CustomerProfileID xsi:nil=\"true\" />\n"
        
        var creditCardFirstSixLastFourTag = ""
        var creditCardTrackDataTag = ""
        
        var prePrintedTicketNumber = ""
        if let _ = naviController?.priprintedNumber, naviController?.priprintedNumber?.characters.count > 0 {
            prePrintedTicketNumber = "\((naviController?.priprintedNumber)!)"
        }
        
        if let _ = naviController?.creditCardInfo, let _ = naviController?.creditCardInfo?.cardNumber, naviController?.creditCardInfo?.cardNumber?.characters.count > 0 {
            
            let cardNo: String = "\((naviController?.creditCardInfo!.cardNumber)!)"
            
            let creditCardFirstSixLastFour = String(cardNo.characters.prefix(6)) + String(cardNo.characters.suffix(4))
            creditCardFirstSixLastFourTag = "<par:CreditCardFirstSixLastFour>" + "\(creditCardFirstSixLastFour)" + "</par:CreditCardFirstSixLastFour>\n"
            
            let cardData = "\(cardNo)" + "=" + "\((naviController?.creditCardInfo?.expiryYear)!)" + "\((naviController?.creditCardInfo?.expiryMonth)!)"
            let encryptedCardData = Encryptor.encrypt(cardData)
            creditCardTrackDataTag = "<par:CreditCardTrackData>" + "\(encryptedCardData!)" + "</par:CreditCardTrackData>\n"
        } else {
            creditCardFirstSixLastFourTag = "<par:CreditCardFirstSixLastFour xsi:nil=\"true\" />\n"
            creditCardTrackDataTag = "<par:CreditCardTrackData xsi:nil=\"true\" />\n"
        }
        
        let ticketXML: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:tem=\"http://tempuri.org/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:UpdateValetInfoForTablet>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:tabletTicket>\n"
            + "<par:Barcode>" + ticketBO.barcodeNumberString! + "</par:Barcode>\n"
            + "<par:CashierUserName>" + authenticateUser! + "\\" + userName! + "</par:CashierUserName>\n"
            + "<par:ContractCardNumbetID xsi:nil=\"true\" />\n"
            + creditCardFirstSixLastFourTag
            + ""
            + creditCardTrackDataTag
            + ""
            + customerProfileTag
            + "<par:DeviceCode>" + deviceCode! + "</par:DeviceCode>\n"
            //Discounts
            //            + "<par:DiscountInfo>\n"
            + self.createDiscountsRequestXML(ticketBO.discounts)
            //            + "</par:DiscountInfo>\n"
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
            + "<par:FirstName>" + ticketBO.firstName! + "</par:FirstName>\n"
            + "<par:FriendlyName xsi:nil=\"true\" />\n"
            + "<par:GuestCustomerID>0</par:GuestCustomerID>\n"//HardCode
            + "<par:LastName>" + ticketBO.lastName! + "</par:LastName>\n"
            + "<par:Make>" + vehicleMake + "</par:Make>\n"
            + "<par:Model>" + vehicleModel + "</par:Model>\n"
            + "<par:Oversized>" + "\(isOversized)" + "</par:Oversized>\n"
            + "<par:PhoneNumber>" + ticketBO.phoneNo! + "</par:PhoneNumber>\n"
            + "<par:StateID xsi:nil=\"true\" />\n"
            + "<par:Tag>" + vehicleTag! + "</par:Tag>\n"
            + "<par:Year>" + vehicleYear + "</par:Year>\n"
            + "<par:Zip xsi:nil=\"true\" />\n"
            + "</par:TabletGuestCustomer>\n"
            + "</par:GuestCustomerInfo>\n"
            //
            + "<par:IdentifierKey>" + ticketBO.identifierKey! + "</par:IdentifierKey>\n"
            + "<par:ImageStream xsi:nil=\"true\" />\n"
            + "<par:LocationID>" + ticketBO.locationID! + "</par:LocationID>\n"
            + "<par:ParkingTypeID>" + "\(updatedParkingTypeID!)" + "</par:ParkingTypeID>\n"
            + "<par:PrePrintedTicketNumber>" + prePrintedTicketNumber + "</par:PrePrintedTicketNumber>\n"
            + "<par:PrintDateTime>" + ticketBO.fromDate! + "</par:PrintDateTime>\n"
            //Reservation Object
            //            + "<par:ReservationInfo>\n"
            + self.reservationRequestXML(ticketBO.reservationsArray)
            + ""
            //            + "</par:ReservationInfo>\n"
            //            + "<par:ReservationInfo />"
            /* + "<par:ReservationInfo>\n"
             + "<par:PrepaidReservations>\n"
             + "<par:ParkingType></par:ParkingType>\n"
             + "<par:RedeemVoucherNumber></par:RedeemVoucherNumber>\n"
             + "<par:ResEndDate></par:ResEndDate>\n"
             + "<par:ResStartDate></par:ResStartDate>\n"
             + "<par:ReservationCode></par:ReservationCode>\n"
             + "<par:ReservationPhone></par:ReservationPhone>\n"
             + "</par:PrepaidReservations>\n"
             + "</par:ReservationInfo>\n"*/
            //
            //Services
            //            + "<par:ServiceInfo>\n"
            + self.createServicesRequestXML(ticketBO.services)
            //            + "</par:ServiceInfo>\n"
            //
            + "<par:ShiftCode>" + shiftCode! + "</par:ShiftCode>\n"
            + "<par:SpaceDescription>" + ticketBO.spaceDescription! + "</par:SpaceDescription>\n"
            + "<par:TicketID>" + ticketBO.ticketID! + "</par:TicketID>\n"
            + "<par:TicketNumber>" + ticketBO.barcodeNumberString! + "</par:TicketNumber>\n"
            + "<par:TicketStatus>" + /*ticketBO.ticketStatus!*/ "1" + "</par:TicketStatus>\n"//HardCode
            //VehicleDamageInfo
            //            + "<par:VehicleDamageInfo>\n"
            + self.createVehicleDamagesRequestXML(ticketBO.vehicleDamages)
            //            + "</par:VehicleDamageInfo>\n"
            //
            //VehicleDetails
            + "<par:VehicleDetail>\n"
            + "<par:Color>" + vehicleColor + "</par:Color>\n"
            //DamageDetails
            + self.createDamageDetailsRequestXML(damageMarksArray)
            //
            + "<par:DamageImage>" + damageMarkImage + "</par:DamageImage>\n"
            + "<par:Make>" + vehicleMake + "</par:Make>\n"
            + "<par:Model>" + vehicleModel + "</par:Model>\n"
            + "<par:TicketID>0</par:TicketID>\n"//HardCode
            + "<par:VIN>" + vehicleVIN + "</par:VIN>\n"
            + "<par:Year>" + vehicleYear + "</par:Year>\n"
            + "</par:VehicleDetail>\n"
            //
            /* + "<par:VehicleValuableInfo>\n"
             + "<par:TabletVehicleValuables>\n"
             + "<par:Details></par:Details>\n"
             + "<par:Location></par:Location>\n"
             + "<par:ValuablesTypeID></par:ValuablesTypeID>\n"
             + "<par:VehicleValuableID></par:VehicleValuableID>\n"
             + "</par:TabletVehicleValuables>\n"
             + "</par:VehicleValuableInfo>\n"*/
            //
            + "<par:VehicleID>" + ticketBO.vehicleID! + "</par:VehicleID>\n"
            //Vehicle Valuables
            + "<par:VehicleValuableInfo />"
            + "</tem:tabletTicket>\n"
            + "</tem:UpdateValetInfoForTablet>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
        //        //" + "\()" + "
        //        let ticketXML1: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        //            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:tem=\"http://tempuri.org/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
        //            + "<soapenv:Header/>\n"
        //            + "<soapenv:Body>\n"
        //            + "<tem:UpdateValetInfoForTablet>\n"
        //            + "<tem:tabletTicket>\n"
        //            + "<par:Barcode>" + ticketBO.barcodeNumberString! + "</par:Barcode>\n"
        //            + "<par:CashierUserName>" + (naviController?.authenticateUser)! + "\\" + (naviController?.userName)! + "</par:CashierUserName>\n"
        //            + "<par:ContractCardNumbetID xsi:nil=\"true\" />\n"
        //            + "<par:CreditCardFirstSixLastFour xsi:nil=\"true\" />\n"
        //            + "<par:CreditCardTrackData xsi:nil=\"true\" />\n"
        //            + "<par:CustomerProfileID>" + ticketBO.customerProfileID! + "</par:CustomerProfileID>\n"
        //            + "<par:DeviceCode>" + (naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode)! + "</par:DeviceCode>\n"
        //            //Discounts
        //            + "<par:DiscountInfo>\n"
        //            + self.createDiscountsRequestXML(ticketBO.discounts!)
        //            + "</par:DiscountInfo>\n"
        //            //
        //            + "<par:ExitDateTime>" + updatedDateTime + "</par:ExitDateTime>\n"
        //            + "<par:FacilityCode>" + (naviController?.facilityConfig?.facilityCode)! + "</par:FacilityCode>\n"
        //            + "<par:GateKey>" + ticketBO.gateKey! + "</par:GateKey>\n"
        //            //Guest Object
        //            /* + "<par:GuestCustomerInfo>\n"
        //            + "<par:TabletGuestCustomer>\n"
        //            + "<par:Address></par:Address>\n"
        //            + "<par:City></par:City>\n"
        //            + "<par:Color></par:Color>\n"
        //            + "<par:EmailAddress></par:EmailAddress>\n"
        //            + "<par:FirstName></par:FirstName>\n"
        //            + "<par:FriendlyName></par:FriendlyName>\n"
        //            + "<par:GuestCustomerID></par:GuestCustomerID>\n"
        //            + "<par:LastName></par:LastName>\n"
        //            + "<par:Make></par:Make>\n"
        //            + "<par:Model></par:Model>\n"
        //            + "<par:Oversized></par:Oversized>\n"
        //            + "<par:PhoneNumber></par:PhoneNumber>\n"
        //            + "<par:StateID></par:StateID>\n"
        //            + "<par:Tag></par:Tag>\n"
        //            + "<par:Year></par:Year>\n"
        //            + "<par:Zip></par:Zip>\n"
        //            + "</par:TabletGuestCustomer>\n"
        //            + "</par:GuestCustomerInfo>\n" */
        //            //
        //            + "<par:IdentifierKey>" + ticketBO.identifierKey! + "</par:IdentifierKey>\n"
        //            + "<par:ImageStream xsi:nil=\"true\" />\n"
        //            + "<par:LocationID>" + ticketBO.locationID! + "</par:LocationID>\n"
        //            + "<par:ParkingTypeID>" + (naviController?.updatedParkingTypeID)! + "</par:ParkingTypeID>\n"
        //            + "<par:PrintDateTime>" + Utility.getFormatedDateTimeFromServerWithT(ticketBO.fromDate!) + "</par:PrintDateTime>\n"
        //            //Reservation Object
        //            + "<par:ReservationInfo />"
        //            /* + "<par:ReservationInfo>\n"
        //            + "<par:PrepaidReservations>\n"
        //            + "<par:ParkingType></par:ParkingType>\n"
        //            + "<par:RedeemVoucherNumber></par:RedeemVoucherNumber>\n"
        //            + "<par:ResEndDate></par:ResEndDate>\n"
        //            + "<par:ResStartDate></par:ResStartDate>\n"
        //            + "<par:ReservationCode></par:ReservationCode>\n"
        //            + "<par:ReservationPhone></par:ReservationPhone>\n"
        //            + "</par:PrepaidReservations>\n"
        //            + "</par:ReservationInfo>\n"*/
        //            //
        //            //Services
        //            + "<par:ServiceInfo>\n"
        //            + self.createServicesRequestXML(ticketBO.services!)
        //            + "</par:ServiceInfo>\n"
        //            //
        //            + "<par:ShiftCode>" + (naviController?.shiftCode)! + "</par:ShiftCode>\n"
        //            + "<par:SpaceDescription>" + ticketBO.spaceDescription! + "</par:SpaceDescription>\n"
        //            + "<par:TicketID>" + ticketBO.ticketID! + "</par:TicketID>\n"
        //            + "<par:TicketNumber>" + ticketBO.barcodeNumberString! + "</par:TicketNumber>"
        //            + "<par:TicketStatus>" + ticketBO.ticketStatus! + "</par:TicketStatus>\n"
        //            //VehicleDamageInfo
        //            + "<par:VehicleDamageInfo>\n"
        //            + self.createVehicleDamagesRequestXML(ticketBO.vehicleDamages!)
        //            + "</par:VehicleDamageInfo>\n"
        //            //
        //            + "<par:VehicleID>" + ticketBO.vehicleID! + "</par:VehicleID>\n"
        //            //Vehicle Valuables
        //            + "<par:VehicleValuableInfo />"
        //            /* + "<par:VehicleValuableInfo>\n"
        //            + "<par:TabletVehicleValuables>\n"
        //            + "<par:Details></par:Details>\n"
        //            + "<par:Location></par:Location>\n"
        //            + "<par:ValuablesTypeID></par:ValuablesTypeID>\n"
        //            + "<par:VehicleValuableID></par:VehicleValuableID>\n"
        //            + "</par:TabletVehicleValuables>\n"
        //            + "</par:VehicleValuableInfo>\n"*/
        //            //
        //            + "</tem:tabletTicket>\n"
        //            + "</tem:UpdateValetInfoForTablet>\n"
        //            + "</soapenv:Body>\n"
        //            + "</soapenv:Envelope>"
        
        return ticketXML
    }
    
    func createDiscountsRequestXML(_ discountsArray: NSMutableArray?) -> String {
        
        var discountsXML: String = ""
        
        if let _ = discountsArray {
            
            discountsXML += "<par:DiscountInfo>\n"
            discountsArray!.enumerateObjects({ discountObj, index, stop in
                discountsXML += self.createDiscountRequestXML(discountObj as! DiscountInfoBO)
            })
            discountsXML += "</par:DiscountInfo>\n"
            
        } else {
            discountsXML += "<par:DiscountInfo />\n"
        }
        
        return discountsXML
    }
    
    func createDiscountRequestXML(_ discountInfoBO: DiscountInfoBO) -> String {
        //" + discountInfoBO.! + "
        //" + "\(discountInfoBO.!)" + "
        let discountXML: String = "<par:DiscountInfo>\n"
            + "<par:ActualDays>" + discountInfoBO.actualDays! + "</par:ActualDays>\n"
            + "<par:ActualHours>" + discountInfoBO.actualHours! + "</par:ActualHours>\n"
            + "<par:AllDiscountParkingValue>" + discountInfoBO.allDiscountParkingValue! + "</par:AllDiscountParkingValue>\n"
            + "<par:AllDiscountServicesValue>" + discountInfoBO.allDiscountServicesValue! + "</par:AllDiscountServicesValue>\n"
            + "<par:AllowMultiple>" + "\(discountInfoBO.allowMultiple!)" + "</par:AllowMultiple>\n"
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
            + "<par:DiscountTypeID>" + discountInfoBO.discountTypeID! + "</par:DiscountTypeID>\n"
            + "<par:DiscountUnitID>" + discountInfoBO.discountUnitID! + "</par:DiscountUnitID>\n"
            + "<par:DiscountValue>" + discountInfoBO.discountValue! + "</par:DiscountValue>\n"
            + "<par:EndDate xsi:nil=\"true\" />\n"
            + "<par:HourlyCharge>" + discountInfoBO.hourlyCharge! + "</par:HourlyCharge>\n"
            + "<par:HourlyRate>" + discountInfoBO.hourlyRate! + "</par:HourlyRate>\n"
            + "<par:IsActive>" + "\(discountInfoBO.isActive!)" + "</par:IsActive>\n"
            + "<par:IsCap>" + "\(discountInfoBO.isCap!)" + "</par:IsCap>\n"
            + "<par:IsCouponAlreadyUsed>" + "\(discountInfoBO.isCouponAlreadyUsed!)" + "</par:IsCouponAlreadyUsed>\n"
            + "<par:IsRequiredStayAll>" + "\(discountInfoBO.isRequiredStayAll!)" + "</par:IsRequiredStayAll>\n"
            + "<par:IsSelected>" + "\(discountInfoBO.isSelected!)" + "</par:IsSelected>\n"
            + "<par:IsValid>" + "\(discountInfoBO.isValid!)" + "</par:IsValid>\n"
            + "<par:MaxDuration xsi:nil=\"true\" />\n"
            + "<par:MaxDurationUnitID xsi:nil=\"true\" />\n"
            + "<par:MinDuration xsi:nil=\"true\" />\n"
            + "<par:MinDurationUnitID xsi:nil=\"true\" />\n"
            + "<par:MonthlyCharge>" + discountInfoBO.monthlyCharge! + "</par:MonthlyCharge>\n"
            + "<par:MonthlyRate>" + discountInfoBO.monthlyRate! + "</par:MonthlyRate>\n"
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
        /*let discountXML: String = "<par:DiscountInfo>\n"
         + "<par:ActualDays>" + "\(discountInfoBO.actualDays!)" + "</par:ActualDays>\n"
         + "<par:ActualHours>" + "\(discountInfoBO.actualHours!)" + "</par:ActualHours>\n"
         + "<par:AllDiscountParkingValue>" + "\(discountInfoBO.allDiscountParkingValue!)" + "</par:AllDiscountParkingValue>\n"
         + "<par:AllDiscountServicesValue>" + "\(discountInfoBO.allDiscountServicesValue!)" + "</par:AllDiscountServicesValue>\n"
         + "<par:AllowMultiple>" + "\(discountInfoBO.allowMultiple!)" + "</par:AllowMultiple>\n"
         + "<par:AppliedDate>" + "\(discountInfoBO.appliedDate!)" + "</par:AppliedDate>\n"
         + "<par:ArrivalDay>" + "\(discountInfoBO.arrivalDay!)" + "</par:ArrivalDay>\n"
         + "<par:CanCombine>" + "\(discountInfoBO.canCombine!)" + "</par:CanCombine>\n"
         + "<par:ChannelID>" + "\(discountInfoBO.channelID!)" + "</par:ChannelID>\n"
         + "<par:ChannelName>" + "\(discountInfoBO.channelName!)" + "</par:ChannelName>\n"
         + "<par:CouponApply>" + "\(discountInfoBO.couponApply!)" + "</par:CouponApply>\n"
         + "<par:CouponCode>" + "\(discountInfoBO.couponCode!)" + "</par:CouponCode>\n"
         + "<par:CouponExpirationDate>" + "\(discountInfoBO.couponExpirationDate!)" + "</par:CouponExpirationDate>\n"
         + "<par:DailyCharge>" + "\(discountInfoBO.dailyCharge!)" + "</par:DailyCharge>\n"
         + "<par:DailyRate>" + "\(discountInfoBO.dailyRate!)" + "</par:DailyRate>\n"
         + "<par:DiscountApplyTo>" + "\(discountInfoBO.discountApplyTo!)" + "</par:DiscountApplyTo>\n"
         + "<par:DiscountCode>" + "\(discountInfoBO.discountCode!)" + "</par:DiscountCode>\n"
         + "<par:DiscountDesc>" + "\(discountInfoBO.discountDesc!)" + "</par:DiscountDesc>\n"
         + "<par:DiscountID>" + "\(discountInfoBO.discountID!)" + "</par:DiscountID>\n"
         + "<par:DiscountName>" + "\(discountInfoBO.discountName!)" + "</par:DiscountName>\n"
         + "<par:DiscountOrder>" + "\(discountInfoBO.discountOrder!)" + "</par:DiscountOrder>\n"
         + "<par:DiscountTypeID>" + "\(discountInfoBO.discountTypeID!)" + "</par:DiscountTypeID>\n"
         + "<par:DiscountUnitID>" + "\(discountInfoBO.discountUnitID!)" + "</par:DiscountUnitID>\n"
         + "<par:DiscountValue>" + "\(discountInfoBO.discountValue!)" + "</par:DiscountValue>\n"
         + "<par:EndDate>" + "\(discountInfoBO.endDate!)" + "</par:EndDate>\n"
         + "<par:FreeDuration>" + "\(discountInfoBO.freeDuration!)" + "</par:FreeDuration>\n"
         + "<par:HourlyCharge>" + "\(discountInfoBO.hourlyCharge!)" + "</par:HourlyCharge>\n"
         + "<par:HourlyRate>" + "\(discountInfoBO.hourlyRate!)" + "</par:HourlyRate>\n"
         + "<par:IsActive>" + "\(discountInfoBO.isActive!)" + "</par:IsActive>\n"
         + "<par:IsCap>" + "\(discountInfoBO.isCap!)" + "</par:IsCap>\n"
         + "<par:IsCouponAlreadyUsed>" + "\(discountInfoBO.isCouponAlreadyUsed!)" + "</par:IsCouponAlreadyUsed>\n"
         + "<par:IsDiscountOnOverstay>" + "\(discountInfoBO.isDiscountOnOverstay!)" + "</par:IsDiscountOnOverstay>\n"
         + "<par:IsRequiredStayAll>" + "\(discountInfoBO.isRequiredStayAll!)" + "</par:IsRequiredStayAll>\n"
         + "<par:IsSelected>" + "\(discountInfoBO.isSelected!)" + "</par:IsSelected>\n"
         + "<par:IsValid>" + "\(discountInfoBO.isValid!)" + "</par:IsValid>\n"
         + "<par:MaxDuration>" + "\(discountInfoBO.maxDuration!)" + "</par:MaxDuration>\n"
         + "<par:MaxDurationUnitID>" + "\(discountInfoBO.maxDurationUnitID!)" + "</par:MaxDurationUnitID>\n"
         + "<par:MinDuration>" + "\(discountInfoBO.minDuration!)" + "</par:MinDuration>\n"
         + "<par:MinDurationUnitID>" + "\(discountInfoBO.minDurationUnitID!)" + "</par:MinDurationUnitID>\n"
         + "<par:MonthlyCharge>" + "\(discountInfoBO.monthlyCharge!)" + "</par:MonthlyCharge>\n"
         + "<par:MonthlyRate>" + "\(discountInfoBO.monthlyRate!)" + "</par:MonthlyRate>\n"
         + "<par:Occurance>" + "\(discountInfoBO.occurance!)" + "</par:Occurance>\n"
         + "<par:ParkingTypeID>" + "\(discountInfoBO.parkingTypeID!)" + "</par:ParkingTypeID>\n"
         + "<par:Quantity>" + "\(discountInfoBO.quantity!)" + "</par:Quantity>\n"
         + "<par:RequiredStay>" + "\(discountInfoBO.requiredStay!)" + "</par:RequiredStay>\n"
         + "<par:ShowUpFront>" + "\(discountInfoBO.showUpFront!)" + "</par:ShowUpFront>\n"
         + "<par:StartDate>" + "\(discountInfoBO.startDate!)" + "</par:StartDate>\n"
         + "<par:TaxesExempted>" + "\(discountInfoBO.taxesExempted!)" + "</par:TaxesExempted>\n"
         + "<par:TotalCharge>" + "\(discountInfoBO.totalCharge!)" + "</par:TotalCharge>\n"
         + "<par:TotalDiscount>" + "\(discountInfoBO.totalDiscount!)" + "</par:TotalDiscount>\n"
         + "<par:UniqID>" + "\(discountInfoBO.uniqID!)" + "</par:UniqID>\n"
         + "<par:ValidationID>" + "\(discountInfoBO.validationID!)" + "</par:ValidationID>\n"
         + "<par:ValidationMessage>" + "\(discountInfoBO.validationMessage!)" + "</par:ValidationMessage>\n"
         + "<par:WeeklyCharge>" + "\(discountInfoBO.weeklyCharge!)" + "</par:WeeklyCharge>\n"
         + "<par:WeeklyRate>" + "\(discountInfoBO.weeklyRate!)" + "</par:WeeklyRate>\n"
         + "</par:DiscountInfo>\n"*/
        
        return discountXML
    }
    
    func reservationRequestXML(_ reservationArray: [ReservationAndFPCardDetailsBO]?) -> String {
        
        var reservationXML: String = ""
        
        if let _ = reservationArray {
            reservationXML += "<par:ReservationInfo>\n"
            for reservationBO in reservationArray! {
                reservationXML += self.createReservationRequestXML(reservationBO)
            }
            reservationXML += "</par:ReservationInfo>\n"
        }else {
            reservationXML = "<par:ReservationInfo />\n"
        }
        
        return reservationXML
    }
    
    func createReservationRequestXML(_ reservationDetails: ReservationAndFPCardDetailsBO?) -> String {
        
        var reservationXML: String = ""
        
        if let _ = reservationDetails {
            
            reservationXML = "<par:PrepaidReservations>\n"
                + "<par:ParkingType>" + "\((reservationDetails?.parkingType)!)" + "</par:ParkingType>\n"
                + "<par:RedeemVoucherNumber></par:RedeemVoucherNumber>\n"
                + "<par:ResEndDate>" + "\((reservationDetails?.toDate)!)" + "</par:ResEndDate>\n"
                + "<par:ResStartDate>" + "\((reservationDetails?.fromDate)!)" + "</par:ResStartDate>\n"
                + "<par:ReservationCode>" + "\((reservationDetails?.reservationCode)!)" + "</par:ReservationCode>\n"
                + "<par:ReservationPhone>" + "\((reservationDetails?.phoneNumber)!)" + "</par:ReservationPhone>\n"
                + "</par:PrepaidReservations>\n"
            
        } else {
            reservationXML = "<par:ReservationInfo />\n"
        }
        
        return reservationXML
    }
    
    func createServicesRequestXML(_ servicesArray: NSMutableArray?) -> String {
        
        var servicesXML: String = ""
        
        if let _ = servicesArray {
            
            servicesXML += "<par:ServiceInfo>\n"
            
            servicesArray!.enumerateObjects({ serviceObj, index, stop in
                servicesXML += self.createServiceRequestXML(serviceObj as! ServiceBO)
            })
            
            servicesXML += "</par:ServiceInfo>\n"
        } else {
            servicesXML += "<par:ServiceInfo />\n"
        }
        
        return servicesXML
    }
    
    func createServiceRequestXML(_ serviceBO: ServiceBO) -> String {
        
        /*let serviceXML: String = "<par:AddService>\n"
         + "<par:AllowOverSize xsi:nil=\"true\" />\n"
         + "<par:DiscountedServiceCharge>" + "\(serviceBO.discountedServiceCharge!)" + "</par:DiscountedServiceCharge>\n"
         + "<par:FacilityID>" + "\(serviceBO.facilityID!)" + "</par:FacilityID>\n"
         + "<par:IsEnabled>" + "\(serviceBO.isEnabled!)" + "</par:IsEnabled>\n"
         + "<par:IsOverSizeChargeApplicable>" + "\(serviceBO.isOverSizeChargeApplicable!)" + "</par:IsOverSizeChargeApplicable>\n"
         + "<par:IsSelected>" + "\(serviceBO.isSelected!)" + "</par:IsSelected>\n"
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
         + self.getServiceStatusTag(serviceBO.serviceCompleted)
         + "<par:ServiceDate>" + "\(serviceBO.serviceDate!)" + "</par:ServiceDate>\n"
         + "<par:ServiceTechnician>" + "\(serviceBO.serviceTechnician!)" + "</par:ServiceTechnician>\n"
         + "<par:AppliedDate>" + "\(serviceBO.appliedDate!)" + "</par:AppliedDate>\n"
         + "</par:AddService>\n"*/
        
        /*let serviceXML1: String = "<par:AddService>\n"
         + "<par:AllowOverSize xsi:nil=\"true\" />\n"
         + "<par:AllowOverSize>" + "\(serviceBO.allowOverSize!)" + "</par:AllowOverSize>\n"
         + "<par:DiscountedServiceCharge>" + "\(serviceBO.discountedServiceCharge!)" + "</par:DiscountedServiceCharge>\n"
         + "<par:FacilityID>" + "\(serviceBO.facilityID!)" + "</par:FacilityID>\n"
         + "<par:FinalServiceDiscount>" + "\(serviceBO.finalServiceDiscount!)" + "</par:FinalServiceDiscount>\n"
         + "<par:IsEnabled>" + "\(serviceBO.isEnabled!)" + "</par:IsEnabled>\n"
         + "<par:IsOverSizeChargeApplicable>" + "\(serviceBO.isOverSizeChargeApplicable!)" + "</par:IsOverSizeChargeApplicable>\n"
         + "<par:IsSelected>" + "\(serviceBO.isSelected!)" + "</par:IsSelected>\n"
         + "<par:IsTaxable>" + "\(serviceBO.isTaxable!)" + "</par:IsTaxable>\n"
         + "<par:IsVariablePrice>" + "\(serviceBO.isVariablePrice!)" + "</par:IsVariablePrice>\n"
         + "<par:OversizeCharge>" + "\(serviceBO.oversizeCharge!)" + "</par:OversizeCharge>\n"
         + "<par:Quantifiable>" + "\(serviceBO.quantifiable!)" + "</par:Quantifiable>\n"
         + "<par:Quantity>" + "\(serviceBO.quantity!)" + "</par:Quantity>\n"
         + "<par:ServiceCharge>" + "\(serviceBO.serviceCharge!)" + "</par:ServiceCharge>\n"
         + "<par:ServiceCode>" + "\(serviceBO.serviceCode!)" + "</par:ServiceCode>\n"
         + "<par:ServiceDesc>" + "\(serviceBO.serviceDesc!)" + "</par:ServiceDesc>\n"
         + "<par:ServiceID>" + "\(serviceBO.serviceID!)" + "</par:ServiceID>\n"
         + "<par:ServiceName>" + "\(serviceBO.serviceName!)" + "</par:ServiceName>\n"
         + "<par:ServiceNotes>" + "\(serviceBO.serviceNotes!)" + "</par:ServiceNotes>\n"
         + "<par:ServiceTypeID>" + "\(serviceBO.serviceTypeID!)" + "</par:ServiceTypeID>\n"
         + "<par:Taxes>" + "\(serviceBO.taxes!)" + "</par:Taxes>\n"
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
        
        var cashierUserNameTag = ""
        if serviceBO.cashierUserName != nil && serviceBO.cashierUserName?.characters.count > 0 {
            cashierUserNameTag = "<par:CashierUserName>" + (serviceBO.cashierUserName)! + "</par:CashierUserName>\n"
        } else {
            cashierUserNameTag = "<par:CashierUserName>" + authenticateUser! + "\\" + userName! + "</par:CashierUserName>\n"
        }
        
        let serviceXML: String = "<par:AddService>\n"
            + "<par:AllowMultiple>" + "\((serviceBO.allowMultiple)!)" + "</par:AllowMultiple>\n"
            + "<par:AllowOverSize xsi:nil=\"true\"></par:AllowOverSize>\n"
            + appliedDateTag
            + cashierUserNameTag
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
    
    func createVehicleDamagesRequestXML(_ vehicleDamagesArray: NSMutableArray?) -> String {
        
        //        + "<par:VehicleDamageInfo>\n"
        //            + self.createVehicleDamagesRequestXML(ticketBO.vehicleDamages!)
        //            + "</par:VehicleDamageInfo>\n"
        
        var vehicleDamagesXML: String = ""
        
        if let _ = vehicleDamagesArray {
            
            vehicleDamagesXML += "<par:VehicleDamageInfo>\n"
            
            vehicleDamagesArray!.enumerateObjects({ vehicleDamageObj, index, stop in
                vehicleDamagesXML += self.createVehicleDamageRequestXML(vehicleDamageObj as! VehicleDamageBO)
            })
            
            vehicleDamagesXML += "</par:VehicleDamageInfo>\n"
        } else {
            vehicleDamagesXML += "<par:VehicleDamageInfo />\n"
        }
        
        return vehicleDamagesXML
    }
    
    func createVehicleDamageRequestXML(_ vehicleDamageBO: VehicleDamageBO) -> String {
        
        let vehicleDamageXML: String = "<par:TabletVehicleDamages>\n"
            + "<par:DamageDesc>" + vehicleDamageBO.damageDesc! + "</par:DamageDesc>\n"
            + "<par:ImageStream>" + vehicleDamageBO.imageStream! + "</par:ImageStream>\n"
            + "<par:Location>" + vehicleDamageBO.location! + "</par:Location>\n"
            + "<par:ReportDateTime>" + vehicleDamageBO.reportDateTime! + "</par:ReportDateTime>\n"
            + "<par:TicketID>" + "\(vehicleDamageBO.ticketId!)" + "</par:TicketID>\n"
            //+ "<par:VehicleDamageID>" + "\(vehicleDamageBO.vehicleDamageId!)" + "</par:VehicleDamageID>\n"
            + self.getVehicleDamageIdTag(vehicleDamageBO.vehicleDamageId)
            + "</par:TabletVehicleDamages>\n"
        
        /*let vehicleDamageXML1: String = "<par:TabletVehicleDamages>\n"
         + "<par:DamageDesc>" + "\(vehicleDamageBO.damageDesc!)" + "</par:DamageDesc>\n"
         + "<par:ImageName>" + "\(vehicleDamageBO.imageName!)" + "</par:ImageName>\n"
         + "<par:ImageStream>" + "\(vehicleDamageBO.imageStream!)" + "</par:ImageStream>\n"
         + "<par:Location>" + "\(vehicleDamageBO.location!)" + "</par:Location>\n"
         + "<par:ReportDateTime>" + "\(vehicleDamageBO.reportDateTime!)" + "</par:ReportDateTime>\n"
         + "<par:TicketID>" + "\(vehicleDamageBO.ticketId!)" + "</par:TicketID>\n"
         + "<par:VehicleDamageID>" + "\(vehicleDamageBO.vehicleDamageId!)" + "</par:VehicleDamageID>\n"
         + "</par:TabletVehicleDamages>\n"*/
        
        return vehicleDamageXML
    }
    
    func getVehicleDamageIdTag(_ vehicleDamageId:Int?) -> String {
        if let _ = vehicleDamageId {
            return "<par:VehicleDamageID>" + "\(vehicleDamageId!)" + "</par:VehicleDamageID>\n"
        } else {
            return "<par:VehicleDamageID xsi:nil=\"true\" />\n"
        }
    }
    
    // MARK: - Connection Delegates
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if (dict.getStringFromDictionary(withKeys: ["UpdateValetInfoForTabletResponse","UpdateValetInfoForTabletResult"]) as NSString) == "true" {
            
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: dict)
            }
        } else {
            if self.delegate?.didFailedWithError != nil {
                self.delegate!.didFailedWithError!(self.identifier, errorMessage:dict.getStringFromDictionary(withKeys: ["UpdateValetInfoForTabletResponse","message"]) as String)
            }
        }
    }
    
    override func didFailedWithError(_ error: AnyObject) {
        if self.delegate?.didFailedWithError != nil {
            self.delegate!.didFailedWithError!(self.identifier, errorMessage: error.localizedDescription)
        }
    }
}
