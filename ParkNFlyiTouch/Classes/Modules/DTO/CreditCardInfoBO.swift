//
//  CreditCardInfoBO.swift
//  ParkNFlyiTouch
//
//  Created by Vilas M on 1/20/16.
//  Copyright © 2016 Cybage Software Pvt. Ltd. All rights reserved.
//

import UIKit

class CreditCardInfoBO: NSObject {
    
    var addressID: String? = nil
    var amountCharged: String? = nil
    var authCode: String? = nil
    var cardCode: String? = nil
    var expiryMonth: String? = nil
    var expiryYear: String? = nil
    var cardNumber: String? = nil
    var maskedCardNumber: String? = nil
    var cardNumberFirstFive: String? = nil
    var cardNumberLastFour: String? = nil
    var cardType: String? = nil
    var creditCardID: NSInteger? = nil
    var creditCardTypeID:NSInteger? = nil
    var fpCardNumber: String? = nil
    var isLinked: Bool?
    var isPrimary: Bool?
    var isSelected: Bool?
    var merchantRef: String? = nil
    var nameOnCard: String?
    var parkingCharge: String?
    var paymentResult: String?
    var paymentResultText: String?
    var personID: NSInteger?
    var postalCode: NSInteger?
    var serviceCharge: String?
    var totalCharge: String?
    var transactionID: NSInteger?
    var unMaskedNumber: String?
    var userData1: String?
    var userData2: String?
    var userData3: String?
    var userData4: String?
    var userData5: String?
    var isSwiped = false
    
    func getCreditCardInfoBOFromSwipedCard(_ creditCardData: String) -> CreditCardInfoBO {
        
        self.isSwiped = true
        
        self.cardNumber = creditCardData.components(separatedBy: "=")[0]
        if (self.cardNumber?.characters.count)! > 5 {
            self.maskedCardNumber = "xxxxxxxxxxxx" + String("\(self.cardNumber!)".characters.suffix(4))
            self.cardNumberFirstFive = String("\(self.cardNumber!)".characters.prefix(5))
            self.cardNumberLastFour = String("\(self.cardNumber!)".characters.suffix(4))
            self.unMaskedNumber = Encryptor.encrypt(self.cardNumber)
        }
        
        let expiryYearMonth = creditCardData.components(separatedBy: "=")[1]
        self.expiryYear = String(expiryYearMonth.characters.prefix(2))
        self.expiryMonth = String(expiryYearMonth.characters.suffix(2))
        
        return self
    }
    
    func getCreditCardInfoBOFromTrackData(_ creditCardTrackData: String) -> CreditCardInfoBO {
        
        _ = self.getCreditCardInfoBOFromSwipedCard(Encryptor.decrypt(creditCardTrackData)!)
        return self
    }
    
    func getCreditCardInfoBOFromDictionary(_ attributeDict: NSDictionary) -> CreditCardInfoBO {
        
        self.addressID = attributeDict.getInnerText(forKey: "a:AddressID")
        self.amountCharged = attributeDict.getInnerText(forKey: "a:AmountCharged")
        self.authCode = attributeDict.getInnerText(forKey: "a:AuthCode")
        self.cardCode = attributeDict.getInnerText(forKey: "a:CardCode")
        self.expiryMonth = attributeDict.getInnerText(forKey: "a:CardExpiryMonth")
        self.expiryYear = attributeDict.getInnerText(forKey: "a:CardExpiryYear")
        self.maskedCardNumber = attributeDict.getInnerText(forKey: "a:CardNumber")
        self.cardNumberFirstFive = attributeDict.getInnerText(forKey: "a:CardNumberFirstFive")
        self.cardNumberLastFour = attributeDict.getInnerText(forKey: "a:CardNumberLastFour")
        self.cardType = attributeDict.getInnerText(forKey: "a:CardType")
        self.creditCardID = attributeDict.getIntegerFromDictionary(withKeys: ["a:CreditCardID"])
        self.creditCardTypeID = attributeDict.getIntegerFromDictionary(withKeys: ["a:CreditCardTypeID"])
        self.fpCardNumber = attributeDict.getInnerText(forKey: "a:FPCardNumber")
        self.isLinked = attributeDict.getBoolFromDictionary(withKeys: ["a:IsLinked"])
        self.isPrimary = attributeDict.getBoolFromDictionary(withKeys: ["a:IsPrimary"])
        self.isSelected = attributeDict.getBoolFromDictionary(withKeys: ["a:IsSelected"])
        self.merchantRef = attributeDict.getInnerText(forKey: "a:MerchantRef")
        self.nameOnCard = attributeDict.getInnerText(forKey: "a:NameOnCard")
        self.parkingCharge = attributeDict.getInnerText(forKey: "a:ParkingCharge")
        self.paymentResult = attributeDict.getInnerText(forKey: "a:PaymentResult")
        self.paymentResultText = attributeDict.getInnerText(forKey: "a:PaymentResultText")
        self.personID = attributeDict.getIntegerFromDictionary(withKeys: ["a:PersonID"])
        self.postalCode = attributeDict.getIntegerFromDictionary(withKeys: ["a:PostalCode"])
        self.serviceCharge = attributeDict.getInnerText(forKey: "a:ServiceCharge")
        self.totalCharge = attributeDict.getInnerText(forKey: "a:TotalCharge")
        self.transactionID = attributeDict.getIntegerFromDictionary(withKeys: ["a:TransactionID"])
        self.unMaskedNumber = attributeDict.getInnerText(forKey: "a:UnMaskedCardNumber")
        self.userData1 = attributeDict.getInnerText(forKey: "a:UserData1")
        self.userData2 = attributeDict.getInnerText(forKey: "a:UserData2")
        self.userData3 = attributeDict.getInnerText(forKey: "a:UserData3")
        self.userData4 = attributeDict.getInnerText(forKey: "a:UserData4")
        self.userData5 = attributeDict.getInnerText(forKey: "a:UserData5")
        
        self.isSwiped = true
        
        //Override
        self.cardNumber = Encryptor.decrypt(self.unMaskedNumber)
        if (self.cardNumber?.characters.count)! > 5 {
            self.maskedCardNumber = "xxxxxxxxxxxx" + String("\(self.cardNumber!)".characters.suffix(4))
            self.cardNumberFirstFive = String("\(self.cardNumber!)".characters.prefix(5))
            self.cardNumberLastFour = String("\(self.cardNumber!)".characters.suffix(4))
            self.unMaskedNumber = Encryptor.encrypt(self.cardNumber)
        }
        
        return self
    }
}
