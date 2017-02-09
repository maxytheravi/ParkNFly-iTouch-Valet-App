//
//  AddTicketUpdateValetInfoForTabletService.swift
//  ParkNFlyiTouch
//
//  Created by Ravi Karadbhajane on 25/02/16.
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


class AddTicketUpdateValetInfoForTabletService: GenericServiceManager {
    
    var vehicleID: String?
    
    func addTicketUpdateValetInfoForTabletWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        self.vehicleID = parameters ["VEHICLEID"] as? String
        if self.vehicleID?.characters.count == 0 && self.vehicleID == "" {
            self.vehicleID = "0"
        }
        let connection = ConnectionManager()
        connection.delegate = self
        
        let soapMessage = self.createTicketRequestXML()
        
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"UpdateValetInfoForTablet")
    }
    
    func createTicketRequestXML() -> String {
        
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        let authenticateUser = naviController?.authenticateUser
        let userName = naviController?.userName
        let updatedDateTime = (naviController?.updatedDate)! + "T" + (naviController?.updatedTime)!
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let updatedParkingTypeID = naviController?.updatedParkingTypeID
        let shiftCode = naviController?.shiftCode
        
        var vehicleColor = ""
        if naviController?.vehicleDetails?.vehicleColor?.characters.count > 0 {
            vehicleColor = (naviController?.vehicleDetails?.vehicleColor)!
        }
        var damageMarkImage = ""
        if naviController?.vehicleDetails?.damageMarkImage?.characters.count > 0 {
            damageMarkImage = (naviController?.vehicleDetails?.damageMarkImage)!
        }
        var vehicleMake = ""
        if naviController?.vehicleDetails?.vehicleMake?.characters.count > 0 {
            vehicleMake = (naviController?.vehicleDetails?.vehicleMake)!
        }
        var vehicleModel = ""
        if naviController?.vehicleDetails?.vehicleModel?.characters.count > 0 {
            vehicleModel = (naviController?.vehicleDetails?.vehicleModel)!
        }
        var vehicleVIN = ""
        if naviController?.vehicleDetails?.vehicleVIN?.characters.count > 0 {
            vehicleVIN = (naviController?.vehicleDetails?.vehicleVIN)!
        }
        var vehicleYear = ""
        if naviController?.vehicleDetails?.vehicleYear?.characters.count > 0 {
            vehicleYear = (naviController?.vehicleDetails?.vehicleYear)!
        }
        
        var vehicleTag = ""
        if naviController?.vehicleDetails?.licenseNumber?.characters.count > 0 {
            vehicleTag = (naviController?.vehicleDetails?.licenseNumber)!
        }
        
        let damageMarksArray = naviController?.vehicleDetails?.damageMarksArray
        
        let customerProfileID = naviController?.reservationDetails?.customerProfileID
        let customerProfileTag = customerProfileID != nil && customerProfileID?.characters.count > 0 ? ("<par:CustomerProfileID>" + "\(customerProfileID!)" + "</par:CustomerProfileID>\n") : "<par:CustomerProfileID xsi:nil=\"true\" />\n"
        
        let updatedFirstName = naviController?.updatedFirstName == nil ? "" : naviController?.updatedFirstName
        let updatedLastName = naviController?.updatedLastName == nil ? "" : naviController?.updatedLastName
        
        var phoneNumber = ""
        if naviController?.phoneNumber?.characters.count > 0 {
            phoneNumber = (naviController?.phoneNumber)!
        }
        
        let isOversizeVehicle = naviController?.isOversizeVehicle
        let priprintedNumber = naviController?.priprintedNumber
        
        var identifierKeyTag = "<par:IdentifierKey></par:IdentifierKey>\n"
        if let fpCardNo = naviController?.reservationDetails?.fpCardNo {
            identifierKeyTag = "<par:IdentifierKey>" + fpCardNo + "</par:IdentifierKey>\n"
        }
        
        let ticketFromServerTicketID = naviController?.ticketFromServerTicketID
        let ticketFromServerPrintDateTime = naviController?.ticketFromServerPrintDateTime
        
        let reservationDetails = naviController?.reservationDetails
        
        let servicesArray = naviController?.servicesArray
        
        let ticketXML: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            + "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\" xmlns:tem=\"http://tempuri.org/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:UpdateValetInfoForTablet>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:tabletTicket>\n"
            + "<par:Barcode>" + priprintedNumber! + "</par:Barcode>\n"
            + "<par:CashierUserName>" + authenticateUser! + "\\" + userName! + "</par:CashierUserName>\n"
            + "<par:ContractCardNumbetID xsi:nil=\"true\" />\n"
            + "<par:CreditCardFirstSixLastFour xsi:nil=\"true\" />\n"
            + "<par:CreditCardTrackData xsi:nil=\"true\" />\n"
            + customerProfileTag
            + "<par:DeviceCode>" + deviceCode! + "</par:DeviceCode>\n"
            //Discounts
            //            + "<par:DiscountInfo>\n"
            //            + self.createDiscountsRequestXML(discounts)
            + "<par:DiscountInfo />\n"
            //            + "</par:DiscountInfo>\n"
            //
            + "<par:ExitDateTime>" + updatedDateTime + "</par:ExitDateTime>\n"
            + "<par:FacilityCode>" + facilityCode! + "</par:FacilityCode>\n"
            + "<par:GateKey xsi:nil=\"true\" />\n"
            //GuestCustomerInfo
            + "<par:GuestCustomerInfo>\n"
            + "<par:TabletGuestCustomer>\n"
            + "<par:Address xsi:nil=\"true\" />\n"
            + "<par:City xsi:nil=\"true\" />\n"
            + "<par:Color>" + vehicleColor + "</par:Color>\n"
            + "<par:EmailAddress xsi:nil=\"true\" />\n"
            + "<par:FirstName>" + updatedFirstName! + "</par:FirstName>\n"
            + "<par:FriendlyName xsi:nil=\"true\" />\n"
            + "<par:GuestCustomerID>0</par:GuestCustomerID>\n"//HardCode
            + "<par:LastName>" + updatedLastName! + "</par:LastName>\n"
            + "<par:Make>" + vehicleMake + "</par:Make>\n"
            + "<par:Model>" + vehicleModel + "</par:Model>\n"
            + "<par:Oversized>" + "\(isOversizeVehicle!)" + "</par:Oversized>\n"
            + "<par:PhoneNumber>" + phoneNumber + "</par:PhoneNumber>\n"
            + "<par:StateID xsi:nil=\"true\" />\n"
            + "<par:Tag>" + vehicleTag + "</par:Tag>\n"
            + "<par:Year>" + vehicleYear + "</par:Year>\n"
            + "<par:Zip xsi:nil=\"true\" />\n"
            + "</par:TabletGuestCustomer>\n"
            + "</par:GuestCustomerInfo>\n"
            //
            + identifierKeyTag
            + "<par:ImageStream xsi:nil=\"true\" />\n"
            //+ "<par:LocationID></par:LocationID>\n"//Removed
            + "<par:ParkingTypeID>" + "\(updatedParkingTypeID!)" + "</par:ParkingTypeID>\n"
            + "<par:PrintDateTime>" + ticketFromServerPrintDateTime! + "</par:PrintDateTime>\n"
            //Reservation Object
            //            + "<par:ReservationInfo>\n"
            + self.createReservationRequestXML(reservationDetails)
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
            + self.createServicesRequestXML(servicesArray)
            //            + "</par:ServiceInfo>\n"
            //
            + "<par:ShiftCode>" + shiftCode! + "</par:ShiftCode>\n"
            + "<par:SpaceDescription></par:SpaceDescription>\n"
            + "<par:TicketID>" + ticketFromServerTicketID! + "</par:TicketID>\n"
            + "<par:TicketNumber>" + priprintedNumber! + "</par:TicketNumber>\n"
            + "<par:TicketStatus>" + /*ticketStatus!*/ "1" + "</par:TicketStatus>\n"//HardCode
            //VehicleDamageInfo
            //            + "<par:VehicleDamageInfo>\n"
            //            + self.createVehicleDamagesRequestXML(vehicleDamages)
            + "<par:VehicleDamageInfo />\n"
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
            + "<par:TicketID>" + ticketFromServerTicketID! + "</par:TicketID>\n"//HardCode
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
            + "<par:VehicleID>" + self.vehicleID! + "</par:VehicleID>\n"
            //Vehicle Valuables
            + "<par:VehicleValuableInfo />"
            + "</tem:tabletTicket>\n"
            + "</tem:UpdateValetInfoForTablet>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>"
        
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
        
        if reservationDetails != nil && reservationDetails?.reservationCode != nil && reservationDetails?.reservationCode?.characters.count > 0 {
            
            reservationXML =
                "<par:ReservationInfo>\n"
                + "<par:PrepaidReservations>\n"
                + "<par:ParkingType>" + "\((reservationDetails?.parkingType)!)" + "</par:ParkingType>\n"
                + "<par:RedeemVoucherNumber></par:RedeemVoucherNumber>\n"
                + "<par:ResEndDate>" + "\((reservationDetails?.toDate)!)" + "</par:ResEndDate>\n"
                + "<par:ResStartDate>" + "\((reservationDetails?.fromDate)!)" + "</par:ResStartDate>\n"
                + "<par:ReservationCode>" + "\((reservationDetails?.reservationCode)!)" + "</par:ReservationCode>\n"
                + "<par:ReservationPhone>" + "\((reservationDetails?.phoneNumber)!)" + "</par:ReservationPhone>\n"
                + "</par:PrepaidReservations>\n"
                + "</par:ReservationInfo>"
            
        } else {
            reservationXML = "<par:ReservationInfo />\n"
        }
        
        return reservationXML
    }
    
    func createServicesRequestXML(_ servicesArray: [ServiceBO]?) -> String {
        
        var servicesXML: String = ""
        
        if let _ = servicesArray {
            
            servicesXML += "<par:ServiceInfo>\n"
            
            for serviceBO in servicesArray! {
                servicesXML += self.createServiceRequestXML(serviceBO)
            }
            
            servicesXML += "</par:ServiceInfo>\n"
        } else {
            servicesXML += "<par:ServiceInfo />\n"
        }
        
        return servicesXML
    }
    
    func createServiceRequestXML(_ serviceBO: ServiceBO) -> String {
        
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
        
        let serviceXML: String = "<par:AddService>\n"
            + "<par:AllowMultiple>" + "\((serviceBO.allowMultiple)!)" + "</par:AllowMultiple>\n"
            + "<par:AllowOverSize xsi:nil=\"true\"></par:AllowOverSize>\n"
            + appliedDateTag
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
