//
//  CalculateRateService.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 12/30/15.
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


class CalculateRateService: GenericServiceManager {
    
    /**
     This method will create CalculateRate request.
     :param: identifier string
     :param: parameters NSDictionary
     :returns: Void returns nothing
     */
    
    func calculateRateWebService(_ identifier: String, parameters: NSDictionary) {
        
        self.identifier = identifier
        let connection = ConnectionManager()
        connection.delegate = self
        let ticketDetails:TicketBO = parameters["TicketDetails"] as! TicketBO
        let soapMessage = self.createCalculateRateRequestXML(ticketDetails)
        connection.callWebService(Utility.getBaseURL(), soapMessage:soapMessage, soapActionName:"CalculateRate")
    }
    
    func createCalculateRateRequestXML(_ ticketDetails:TicketBO) -> String {
        
        let updatedDateTime = (naviController?.updatedDate)! + "T" + (naviController?.updatedTime)!//"2015-11-30T13:17:23"
        let currentDateTime = Utility.stringFromDateAdjustmentWithT(Utility.getServerDateTimeFormat(), date: Date())//"2015-11-27T13:19:58"
        let productSetId = ticketDetails.parkingType
        let ticketStatus = ticketDetails.ticketStatus
        let redeemDays = ticketDetails.redeemPoints
        let adhocDisAmountForPC = ticketDetails.adhocDiscountPC
        let discountArray = ticketDetails.discounts
        let serviceArray = ticketDetails.services
        let reservationArray = ticketDetails.reservationsArray
        let contractCardNumber = ticketDetails.contractCardNumber
        var contractCardNumberTag: String?
        if contractCardNumber?.characters.count > 0 {
            contractCardNumberTag = contractCardNumber
        }else {
            contractCardNumberTag = "0"
        }
        
        let facilityCode = naviController?.facilityConfig?.facilityCode
        let deviceCode = naviController?.deviceIdByDeviceByDeviceAddress?.deviceCode
        
        let ticketXML: String = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:par=\"http://schemas.datacontract.org/2004/07/ParkNFly.GCS.Entities\">\n"
            + "<soapenv:Header/>\n"
            + "<soapenv:Body>\n"
            + "<tem:CalculateRate>\n"
            + "<tem:FacilityCode>" + facilityCode! + "</tem:FacilityCode>\n"
            + "<tem:DeviceCode>" + deviceCode! + "</tem:DeviceCode>\n"
            + "<tem:LanguageCode></tem:LanguageCode>\n"
            + "<tem:entryDate>" + currentDateTime + "</tem:entryDate>\n"
            + "<tem:exitDate>" + updatedDateTime + "</tem:exitDate>\n"
            + "<tem:productSetId>" + productSetId! + "</tem:productSetId>\n"
            //            Discounts
            + self.createDiscountsRequestXML(discountArray)
            + ""
            //Services
            + self.createServicesRequestXML(serviceArray)
            + ""
            //Reservations
            + self.reservationRequestXML(reservationArray)
            + "<tem:ticketstatus>" + ticketStatus! + "</tem:ticketstatus>\n"
            + "<tem:redeemDays>" + redeemDays! + "</tem:redeemDays>\n"
            + "<tem:adhocDisAmountForPC>" + adhocDisAmountForPC! + "</tem:adhocDisAmountForPC>\n"
            + "<tem:contractCardNumber>" + contractCardNumberTag! + "</tem:contractCardNumber>\n"
            + "</tem:CalculateRate>\n"
            + "</soapenv:Body>\n"
            + "</soapenv:Envelope>\n"
        
        return ticketXML
    }
    
    func createDiscountsRequestXML(_ selectedDiscountArray: NSMutableArray?) -> String {
        
        var discountsXML: String = ""
        let discountsArray = selectedDiscountArray
        
        if discountsArray?.count > 0 {
            discountsXML += "<tem:discounts>\n"
            discountsArray!.enumerateObjects({ discountObj, index, stop in
                discountsXML += self.createDiscountRequestXML(discountObj as! DiscountInfoBO)
            })
            discountsXML += "</tem:discounts>\n"
        }else {
            discountsXML = "<tem:discounts />\n"
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
            + "<par:AppliedDate i:nil=\"true\">" + discountInfoBO.appliedDate! + "</par:AppliedDate>\n"
            + "<par:ArrivalDay i:nil=\"true\">" + /*discountInfoBO.arrivalDay!*/ "0" + "</par:ArrivalDay>\n" //arrival day should be int type ex. 0
            + "<par:CanCombine>" + discountInfoBO.canCombine! + "</par:CanCombine>\n"
            + "<par:ChannelID>" + discountInfoBO.channelID! + "</par:ChannelID>\n"
            + "<par:ChannelName>" + discountInfoBO.channelName! + "</par:ChannelName>\n"
            + "<par:CouponApply>" + discountInfoBO.couponApply! + "</par:CouponApply>\n"
            + "<par:CouponCode i:nil=\"true\">" + discountInfoBO.couponCode! + "</par:CouponCode>\n"
            + "<par:CouponExpirationDate i:nil=\"true\">" + discountInfoBO.couponExpirationDate! + "</par:CouponExpirationDate>\n"
            + "<par:DailyCharge>" + discountInfoBO.dailyCharge! + "</par:DailyCharge>\n"
            + "<par:DailyRate>" + discountInfoBO.dailyRate! + "</par:DailyRate>\n"
            + "<par:DiscountApplyTo>" + discountInfoBO.discountApplyTo! + "</par:DiscountApplyTo>\n"
            + "<par:DiscountCode>" + discountInfoBO.discountCode! + "</par:DiscountCode>\n"
            + "<par:DiscountDesc>" + discountInfoBO.discountDesc! + "</par:DiscountDesc>\n"
            + "<par:DiscountID>" + discountInfoBO.discountID! + "</par:DiscountID>\n"
            + "<par:DiscountName>" + discountInfoBO.discountName! + "</par:DiscountName>\n"
            + "<par:DiscountOrder i:nil=\"true\">" + discountInfoBO.discountOrder! + "</par:DiscountOrder>\n"
            + "<par:DiscountTypeID>" + discountInfoBO.discountTypeID! + "</par:DiscountTypeID>\n"
            + "<par:DiscountUnitID>" + discountInfoBO.discountUnitID! + "</par:DiscountUnitID>\n"
            + "<par:DiscountValue>" + discountInfoBO.discountValue! + "</par:DiscountValue>\n"
            + "<par:EndDate i:nil=\"true\">" + discountInfoBO.endDate! + "</par:EndDate>\n"
            + "<par:FreeDuration i:nil=\"true\">" + discountInfoBO.freeDuration! + "</par:FreeDuration>\n"
            + "<par:HourlyCharge>" + discountInfoBO.hourlyCharge! + "</par:HourlyCharge>\n"
            + "<par:HourlyRate>" + discountInfoBO.hourlyRate! + "</par:HourlyRate>\n"
            + "<par:IsActive>" + "\(discountInfoBO.isActive!)" + "</par:IsActive>\n"
            + "<par:IsCap>" + "\(discountInfoBO.isCap!)" + "</par:IsCap>\n"
            + "<par:IsCouponAlreadyUsed>" + "\(discountInfoBO.isCouponAlreadyUsed!)" + "</par:IsCouponAlreadyUsed>\n"
            + "<par:IsDiscountOnOverstay>" + "\(discountInfoBO.isDiscountOnOverstay!)" + "</par:IsDiscountOnOverstay>\n"
            + "<par:IsRequiredStayAll>" + "\(discountInfoBO.isRequiredStayAll!)" + "</par:IsRequiredStayAll>\n"
            + "<par:IsSelected>" + "\(discountInfoBO.isSelected!)" + "</par:IsSelected>\n"
            + "<par:IsValid>" + "\(discountInfoBO.isValid!)" + "</par:IsValid>\n"
            + "<par:MaxDuration i:nil=\"true\">" + "\(discountInfoBO.maxDuration!)" + "</par:MaxDuration>\n"
            + "<par:MaxDurationUnitID i:nil=\"true\">" + "\(discountInfoBO.maxDurationUnitID!)" + "</par:MaxDurationUnitID>\n"
            + "<par:MinDuration i:nil=\"true\">" + "\(discountInfoBO.minDuration!)" + "</par:MinDuration>\n"
            + "<par:MinDurationUnitID i:nil=\"true\">" + "\(discountInfoBO.minDurationUnitID!)" + "</par:MinDurationUnitID>\n"
            + "<par:MonthlyCharge>" + discountInfoBO.monthlyCharge! + "</par:MonthlyCharge>\n"
            + "<par:MonthlyRate>" + discountInfoBO.monthlyRate! + "</par:MonthlyRate>\n"
            + "<par:Occurance>" + discountInfoBO.occurance! + "</par:Occurance>\n"
            + "<par:ParkingTypeID>" + discountInfoBO.parkingTypeID! + "</par:ParkingTypeID>\n"
            + "<par:Quantity>" + discountInfoBO.quantity! + "</par:Quantity>\n"
            + "<par:RequiredStay i:nil=\"true\">" + discountInfoBO.requiredStay! + "</par:RequiredStay>\n"
            + "<par:ShowUpFront>" + discountInfoBO.showUpFront! + "</par:ShowUpFront>\n"
            + "<par:StartDate>" + discountInfoBO.startDate! + "</par:StartDate>\n"
            + "<par:TaxesExempted i:nil=\"true\">" + discountInfoBO.taxesExempted! + "</par:TaxesExempted>\n"
            + "<par:TotalCharge>" + discountInfoBO.totalCharge! + "</par:TotalCharge>\n"
            + "<par:TotalDiscount>" + discountInfoBO.totalDiscount! + "</par:TotalDiscount>\n"
            + "<par:UniqID>" + discountInfoBO.uniqID! + "</par:UniqID>\n"
            + "<par:ValidationID>" + discountInfoBO.validationID! + "</par:ValidationID>\n"
            + "<par:ValidationMessage i:nil=\"true\">" + discountInfoBO.validationMessage! + "</par:ValidationMessage>\n"
            + "<par:WeeklyCharge>" + discountInfoBO.weeklyCharge! + "</par:WeeklyCharge>\n"
            + "<par:WeeklyRate>" + discountInfoBO.weeklyRate! + "</par:WeeklyRate>\n"
            + "</par:DiscountInfo>\n"
        
        return discountXML
    }
    
    func createServicesRequestXML(_ selectedServicesArray: NSMutableArray?) -> String {
        
        var servicesXML: String = ""
        let servicesArray = selectedServicesArray
        
        if servicesArray?.count > 0 {
            servicesXML += "<tem:serviceCharges>\n"
            servicesArray!.enumerateObjects({ servicesObj, index, stop in
                servicesXML += self.createServiceRequestXML(servicesObj as! ServiceBO)
            })
            servicesXML += "</tem:serviceCharges>\n"
        }else {
            servicesXML = "<tem:serviceCharges />\n"
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
        
        /*var serviceNotes = ""
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
         + "</par:AddService>\n"*/
        
        let serviceXML: String = "<par:AddService>\n"
            + "<par:AllowMultiple>" + "\(serviceBO.allowMultiple!)" + "</par:AllowMultiple>\n"
            + "<par:AllowOverSize>" + "\(serviceBO.allowOverSize!)" + "</par:AllowOverSize>\n"
            + "<par:AppliedDate>" + "\(serviceBO.appliedDate!)" + "</par:AppliedDate>\n"
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
            + "<par:ServiceCharge>"  + "\(serviceBO.serviceCharge!)" + "</par:ServiceCharge>\n"
            + "<par:ServiceCode>" + "\(serviceBO.serviceCode!)" + "</par:ServiceCode>\n"
            + "<par:ServiceCompleted>" + "\(serviceBO.serviceCompleted!)" + "</par:ServiceCompleted>\n"
            + "<par:ServiceDate>" + "\(serviceBO.appliedDate!)" + "</par:ServiceDate>\n"
            + "<par:ServiceDesc>" + "\(serviceBO.serviceDesc!)" + "</par:ServiceDesc>\n"
            + "<par:ServiceID>" + "\(serviceBO.serviceID!)" + "</par:ServiceID>\n"
            + "<par:ServiceName>" + "\(serviceBO.serviceName!)" + "</par:ServiceName>\n"
            + "<par:ServiceNotes>" + "\(serviceBO.serviceNotes!)" + "</par:ServiceNotes>\n"
            + "<par:ServiceTechnician>" + "\(serviceBO.serviceTechnician!)" + "</par:ServiceTechnician>\n"
            + "<par:ServiceTypeID>" + "\(serviceBO.serviceTypeID!)" + "</par:ServiceTypeID>\n"
            + "<par:Taxes>" + "\(serviceBO.taxes!)" + "</par:Taxes>\n"
            + "<par:TotalServieCharge>" + "\(serviceBO.totalServiceCharge!)" + "</par:TotalServieCharge>\n"
            + "<par:TotalServiceDiscount>" + "\(serviceBO.totalServiceDiscount!)" + "</par:TotalServiceDiscount>\n"
            + "<par:VariableServiceCharge>" + "\(serviceBO.variableServiceCharge!)" + "</par:VariableServiceCharge>\n"
            + "</par:AddService>\n"
        
        return serviceXML
    }
    
    func reservationRequestXML(_ reservationArray: [ReservationAndFPCardDetailsBO]?) -> String {
        
        var reservationXML: String = ""
        
        if let _ = reservationArray {
            reservationXML += "<tem:prepaidReservations>\n"
            for reservationBO in reservationArray! {
                reservationXML += self.createReservationRequestXML(reservationBO)
            }
            reservationXML += "</tem:prepaidReservations>\n"
        }else {
            reservationXML = "<tem:prepaidReservations />\n"
        }
        
        return reservationXML
    }
    
    func createReservationRequestXMLSingleObject(_ reservationDetails: ReservationAndFPCardDetailsBO?) -> String {
        
        var reservationXML: String = ""
        
        if let _ = reservationDetails {
            reservationXML += "<tem:prepaidReservations>\n"
            reservationXML += self.createReservationRequestXML(reservationDetails!)
            reservationXML += "</tem:prepaidReservations>\n"
        } else {
            reservationXML = "<tem:prepaidReservations />\n"
        }
        
        return reservationXML
    }
    
    func createReservationRequestXML(_ reservationDetails: ReservationAndFPCardDetailsBO) -> String {
        
        let reservationXML: String = "<par:PrepaidReservations>\n"
            + "<par:ParkingType>" + "\((reservationDetails.parkingType)!)" + "</par:ParkingType>\n"
            + "<par:RedeemVoucherNumber></par:RedeemVoucherNumber>\n"
            + "<par:ResEndDate>" + "\((reservationDetails.toDate)!)" + "</par:ResEndDate>\n"
            + "<par:ResStartDate>" + "\((reservationDetails.fromDate)!)" + "</par:ResStartDate>\n"
            + "<par:ReservationCode>" + "\((reservationDetails.reservationCode)!)" + "</par:ReservationCode>\n"
            + "<par:ReservationPhone>" + "\((reservationDetails.phoneNumber)!)" + "</par:ReservationPhone>\n"
            + "</par:PrepaidReservations>\n"
        
        return reservationXML
    }
    
    // MARK: - Connection Delegates
    
    override func connectionDidFinishLoading(_ dict: NSDictionary) {
        
        //        let dict: NSDictionary = GenericXmlParser.dictionaryParserXML(response as! XMLParser) as NSDictionary
        if dict.getObjectFromDictionary(withKeys: ["CalculateRateResponse","CalculateRateResult"]) != nil {
            
            let calculateRateDict = dict.getObjectFromDictionary(withKeys: ["CalculateRateResponse","CalculateRateResult"])
            if self.delegate?.connectionDidFinishLoading != nil {
                self.delegate!.connectionDidFinishLoading!(self.identifier, response: calculateRateDict as AnyObject)
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
