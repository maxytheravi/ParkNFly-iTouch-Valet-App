//
//  ReservationAndFPCardDetailsBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 10/15/15.
//  Copyright © 2015 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class ReservationAndFPCardDetailsBO: NSObject {
    
    var amountPaid: NSString? = nil
    var customerProfileID: String? = nil
    var days: NSInteger? = nil
    var emailAddress: NSString? = nil
    var fpCardNo: String? = nil
    var firstName: String? = nil
    var fromDate: String? = nil
    var globalCode: NSString? = nil
    var hours: NSInteger? = nil
    var lastName: String? = nil
    var parkingType: NSInteger? = nil
    var parkingTypeName: String? = nil
//    var phoneNumber: NSInteger? = nil
    var phoneNumber: UInt64? = nil
    var points: NSInteger? = nil
    var profileIdentifierID: NSInteger?
    var reservationCode: String? = nil
    var reservationTaxes: Double? = nil
    var rewardDays: NSInteger? = nil
    var tier: NSString? = nil
    var toDate:String? = nil
    var fpCode: String? = nil
    var reservationID: String? = nil
    var totalParkingPrice: NSString? = nil
    var redeemVoucherNumber: NSString? = nil
    
    func getReservationAndFPCardDetailsBOFromDictionary(_ attributeDict: NSDictionary) -> ReservationAndFPCardDetailsBO {
        self.amountPaid = attributeDict.getInnerText(forKey: "a:AmountPaid") as NSString?
        self.customerProfileID = attributeDict.getInnerText(forKey: "a:CustomerProfileID")
        self.days = attributeDict.getIntegerFromDictionary(withKeys: ["a:Days"])
        
        if ((attributeDict["a:EmailId"]) != nil){
            self.emailAddress = attributeDict.getInnerText(forKey: "a:EmailId") as NSString?
        } else if ((attributeDict["a:EmailAddress"]) != nil){
            self.emailAddress = attributeDict.getInnerText(forKey: "a:EmailAddress") as NSString?
        }
        self.firstName = attributeDict.getInnerText(forKey: "a:FirstName")
        self.globalCode = attributeDict.getInnerText(forKey: "a:GlobalCode") as NSString?
        self.hours = attributeDict.getIntegerFromDictionary(withKeys: ["a:Hours"])
        self.lastName = attributeDict.getInnerText(forKey: "a:LastName")
        self.parkingType = attributeDict.getIntegerFromDictionary(withKeys: ["a:ParkingType"])
        self.parkingTypeName = attributeDict.getInnerText(forKey: "a:ParkingTypeName")
        
//        self.phoneNumber = attributeDict.getIntegerFromDictionaryWithKeys(["a:PhoneNumber"])
        self.phoneNumber = UInt64(attributeDict.getInnerText(forKey: "a:PhoneNumber"))
        if self.phoneNumber == nil {
            self.phoneNumber = 0
        }
        
        self.points = attributeDict.getIntegerFromDictionary(withKeys: ["a:Points"])
        self.profileIdentifierID = attributeDict.getIntegerFromDictionary(withKeys: ["a:ProfileIdentifierID"])
        self.reservationCode = attributeDict.getInnerText(forKey: "a:ReservationCode")
        self.reservationTaxes = attributeDict.getDoubleFromDictionary(withKeys: ["a:ReservationTaxes"])
        self.rewardDays = attributeDict.getIntegerFromDictionary(withKeys: ["a:RewardDays"])
        self.tier = attributeDict.getInnerText(forKey: "a:Tier") as NSString?
        self.fromDate = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:From"))
        if (self.fromDate == nil || self.fromDate == "") {
            self.fromDate = Utility.getFormatedDateTimeWithT(attributeDict.getAttributedData(forKey: "a:StartDate"))
        }
        self.toDate = Utility.getFormatedDateTimeWithT(attributeDict.getInnerText(forKey: "a:To"))
        if (self.toDate == nil || self.toDate == "") {
            self.toDate = Utility.getFormatedDateTimeWithT(attributeDict.getAttributedData(forKey: "a:EndDate"))
        }
        
        self.fpCardNo = attributeDict.getInnerText(forKey: "a:FPCardNo")
        self.fpCode = attributeDict.getInnerText(forKey: "a:Code")
        
        if self.fpCode == nil || self.fpCode == "" {
            self.fpCode = self.fpCardNo
        }
        if self.fpCardNo == nil || self.fpCardNo == "" {
            self.fpCardNo = self.fpCode
        }
        
        if ((attributeDict["a:rsReserversId"]) != nil) {
            self.reservationID = attributeDict.getInnerText(forKey: "a:rsReserversId")
        }else if ((attributeDict["a:rsId"]) != nil) {
            self.reservationID = attributeDict.getInnerText(forKey: "a:rsId")
        }
        self.totalParkingPrice = attributeDict.getInnerText(forKey: "a:TotalParkingPrice") as NSString?
        
        return self
    }
    
    func getReservationAndFPCardDetailsBOFromTicketDetails(_ attributeDict: NSDictionary) -> ReservationAndFPCardDetailsBO {
        
        self.fromDate = attributeDict.getInnerText(forKey: "a:ResStartDate")
        self.toDate = attributeDict.getInnerText(forKey: "a:ResEndDate")
        self.parkingType = attributeDict.getIntegerFromDictionary(withKeys: ["a:ParkingType"])
        self.reservationCode = attributeDict.getInnerText(forKey: "a:ReservationCode")
        
//        self.phoneNumber = attributeDict.getIntegerFromDictionaryWithKeys(["a:ReservationPhone"])
        self.phoneNumber = UInt64(attributeDict.getInnerText(forKey: "a:ReservationPhone"))
        if self.phoneNumber == nil {
            self.phoneNumber = 0
        }
        
        self.redeemVoucherNumber = attributeDict.getInnerText(forKey: "a:RedeemVoucherNumber") as NSString?
        
        return self
    }
}
